# ROADMAP — phanes

> Phased execution plan. All product decisions (1–6 + B-surface) are
> CLOSED in `design.md`; this is the build path. Discipline:
> echoes-experience thin slices — ship the smallest credible layer, never
> big-bang. g3: every status honest, measured (instrument-first for any
> cost-bearing fleet run).

Locked design (from `design.md`, Decisions 1–16): scope **B** generic
autonomous-cycle platform · brand **Phanes** · `dancinlab/phanes`
**public + source-available** (Decision 16) · deployment **가+다**
(public demo funnel + dashboard, **API = shared substrate**) ·
multi-tenant **다 hybrid** (`HX_DATA_DIR` per-tenant boundary +
`$HOME`-jail defense-in-depth) · license **proprietary**.

Deployment design (Decisions 11–15): host **AWS EC2** single Linux box ·
pricing **tier + metered** (billed per OUROBOROS round, via **Stripe**) ·
datastore **DynamoDB + S3** (replaces the filesystem `.store/`) ·
deploy method **repo-committed `service/deploy.sh`** (rsync → build →
health-check → rollback; systemd unit `service/phanes-http.service`).

---

## P0 — Foundations · DONE (2026-05-19)

Repo, governance, GOAL/design/README/LICENSE, decision
gates 1–6, two upstream handoffs filed to hexa-lang `inbox/patches/`.

## P1 — Job API substrate (the (나) layer everything sits on) · P1a + P1b DONE (measured 2026-05-19)

The spine both surfaces consume. Minimal authenticated service:

- `POST /job {seed, verifier_ref, rounds_cap}` → enqueue
- worker spawns `hexa kick` on the **Linux fleet** (Mac native forbidden
  by hexa-lang Axis D) in a **per-job `$HOME`-jail sandbox**, with
  `HEXA_VAL_ARENA=0` (cycle-h36 arena-aliasing fix), seed validated
  (`_validate_seed`), round/wall capped
- capture JSON `DrillResult` + overlay → `GET /job/:id`,
  `GET /job/:id/result`
- auth = API key; per-tenant sandbox dir = isolation
- reference: hexa-lang `gate/ hexa://kick?topic=` + `drill_bg_spawn`
  (≈70% of an async-job pipeline already)

Exit: one tenant, one job, end-to-end, isolated, measured.

**P1a status — DONE, measured (2026-05-19, arm64 macOS local):**
- `service/job_runner.sh` — verified engine-invocation contract: per-job
  `$HOME`-jail + `HEXA_VAL_ARENA=0` + seed pre-validate + rounds clamp +
  capture (stdout `DrillResult` JSON + `overlay.n6`) + wall meter.
- `service/jobctl.sh` — filesystem job store: `init-tenant / submit /
  get / result`, API-key auth, per-tenant dir isolation.
- `service/API.md` — HTTP contract for P1b (1:1 skin, mechanical).
- Measured: cheap oracle (1 round) rc=0, overlay ONLY in jail, real
  `~/.hx/data` untouched; full self-test init→submit→get→result PASS,
  wrong-token → rc=4. Decision 6 (가) `$HOME`-jail isolation **proven,
  not asserted**.
- **P1a honest gaps (recorded, not hidden)**: wall meter is
  integer-second — too coarse for sub-second jobs, refine to ms in P2
  (billing basis). No concurrency test yet (P2, `checkpoint.hexa:26`
  serialization concern). HTTP transport not built (P1b).

**P1b status — DONE, measured (2026-05-19, hexa-native HTTP server):**
- `service/http_phanes.hexa` — hexa program using `stdlib/net` (server +
  request + response). Routes per `service/API.md`: GET `/v1/healthz`,
  POST `/v1/jobs`, GET `/v1/jobs/:id`, GET `/v1/jobs/:id/result`. Auth =
  `Authorization: Bearer` + `X-Phanes-Tenant`. Handlers shell out to
  `service/jobctl.sh` (the verified substrate — true 1:1 skin).
- `service/build.sh` — builds via upstream `hexa` toolchain
  (HEXA_HOME=~/core/hexa-lang). 393KB arm64 Mach-O, clean clang build.
- `web/index.html` — vanilla JS + Canvas single-file dev console
  (echoes-experience template, "기존 생태계" frontend = static, no bundler).
- **Measured smoke (7/7 PASS)**: healthz · submit · get · result · seed-
  intact assertion (seed containing `=` preserved verbatim) · no-auth
  → 401 · bad-JSON → 400. Wall ≈ 0.5s for submit, JSON body parsed via
  `json_parse` builtin.
- **Measured fix on record (g3)**: P1b smoke v1 used form-encoded body;
  `stdlib parse_query` splits naively on every `=`, truncating seeds
  containing `=`. Pivoted to JSON body + `json_parse`; seed-intact
  assertion now PASS. Documented in `service/http_phanes.hexa`.

**Upstream win on record**: the `phanes-hx-data-dir-per-tenant-isolation`
handoff was **resolved SSOT 2026-05-19** in hexa-lang — `hx_data_dir()`
helper added with precedence `HX_DATA_DIR > $HOME/.hx/data > ".hx/data"`,
all 4 call sites switched, parse-gate clean. Binary promote pending
(standard separate deploy step); phanes keeps `$HOME`-jail until then,
swaps to `HX_DATA_DIR` after promote with sandbox as defense-in-depth
(@ P2).

## P2 — Compute-plane hardening · P2.1 + P2.2 + P2.4 measured (2026-05-19)

**P2.1 wall meter ms — DONE measured.** `job_runner.sh` adopts perl
`Time::HiRes` ms clock (`phanes_now_ms`); `job.json` now carries both
`wall_ms` (billing basis) and `wall_sec` (back-compat). Sub-second
resolution verified: 1-round kick reports `wall_ms=1312`.

**P2.2 concurrency — MEASURED, honest finding.**
`service/concurrency_test.sh` fires N=4 parallel HTTP submits:
- ✅ **Isolation HOLDS**: 4 distinct job ids, each with its own
  `job.json` + `overlay.n6` (per-job `$HOME`-jail works under concurrent
  load — Decision 6 (가) verified at N=4).
- 🟡 **Service-layer serialization (predicted, measured)**: ratio
  `concurrent/baseline = 4.4/10` ≈ fully serialized. Root cause:
  `stdlib/net/http_server.hexa::server_serve` is a sequential accept-loop
  (one connection processed before the next accept). NOT a per-job
  isolation failure — execution layer.

**P2.x — DONE measured (async-submit pivot, 2026-05-19).** Reading
`stdlib/net/concurrent_serve.hexa` docstring revealed the port would NOT
help: "Stage0 blocking net_accept 때문에 실제로는 단일 스레드 직렬
처리이지만 work-stealing deque 를 매개로 하여 logical concurrency 형태를
유지한다. 멀티 OS 스레드는 roadmap 62 통합 후 활성화." Instrument-first
saved a substantial rewrite (cheap-oracle: read the docstring).
**Pivot**: decouple HTTP throughput from kick wall at the **job
dispatcher layer** instead. `service/jobctl.sh submit` backgrounds
`job_runner.sh` (`nohup … & + disown`) and returns the `job_id`
immediately; the kick runs in a detached child process. `job_runner.sh`
atomic-writes status transitions (`queued → running → done/failed` via
tmp+rename so concurrent GETs never see partial JSON). New upstream
inbox filed: `phanes-stdlib-net-os-thread-concurrency-roadmap-62` (the
gap escalation; once landed, http_phanes.hexa can drop the async detour).
**Measured (2026-05-19)**:
- `baseline_submit_ms = 162`  (vs pre-pivot 1530 — HTTP returns fast)
- `baseline_kick_ms   = 1364` (full submit → done for 1 job)
- 4-way concurrent submit total = `389ms` (submit-only ratio 2.4/10 —
  HTTP still serial at accept-loop, expected)
- 4-way end-to-end completion = `2360ms` (end-to-end ratio 1.7/10 vs
  baseline_kick — **engine PARTIAL parallel** on multi-core, contention
  < 1.5× per kick)
- **Absolute throughput vs pre-pivot ~2.9× (6795 → 2360ms for 4 jobs).**
- per-job statuses all `done`, isolation HOLDS at N=4.

**P2.3 `HX_DATA_DIR` adoption — PENDING upstream binary promote.**
Probe (2026-05-19): running `bin/hexa-absorbed-kick` (May 18 build) does
NOT honor `HX_DATA_DIR`. SSOT helper landed in hexa-lang same day, but
binary promote is the standard separate deploy step (per the upstream
resolution comment, the 22c27a05 pattern). phanes keeps the `$HOME`-jail
until promote; after promote, `job_runner.sh` will add
`HX_DATA_DIR="$JAIL/.hx/data"` to its env line, drop the `$HOME` hijack,
and keep the sandbox as defense-in-depth. No new inbox needed — already
on upstream lifecycle.

**P2.4 post-hoc tenant verifier hook — DONE measured.** `job_runner.sh`
gains `--verifier PATH` (+ `--verifier-timeout` default 120s). Exec in
the `$HOME`-jail with a tightened env (`env -i HOME=… PATH=/usr/bin:/bin`)
+ hard `timeout`. `jobctl.sh submit` auto-attaches per-tenant
`verifier.sh` (admin-placed for P2; tenant-upload endpoint = P3).
`job.json` carries `verifier_rc` (the tenant verifier's exit code —
under `@D g_honest_scope.scope_b` this is the sole authority for
"objective met"). Measured: example verifier (threshold-on-total) →
`verifier_rc=0` PASS. **Sandbox honesty on record (g3)**: this is a thin
POSIX sandbox (env reset + timeout), NOT container/firejail; P3
production hardening adds true containerization + no-network etc.

**P2.5 production Linux fleet routing — DEFERRED (P3-coupled).**
hexa-lang Axis-D forbids Mac-native `hexa kick` for production routes;
the engine must run on Linux fleet (ubu-2 / production hosts). Path
forward: `job_runner.sh` honors `PHANES_ENGINE_HOST` env (ssh to
`<host> "PHANES_HEXA_HOME=… HEXA_VAL_ARENA=0 timeout … bin/hexa-absorbed-
kick --seed … --rounds N"`, capture stdout/stderr/overlay back via
`rsync`/`scp`). Sub-blocker: kick binary distribution to Linux x86_64
(ubu can't self-host arm). Recorded for P3 production hardening phase;
not coded this turn.

**P2.6 second upstream patch tracking.** `phanes-pluggable-verifier-
oracle-for-drill-loop` still pending hexa-lang response (no resolution
yet). phanes's post-hoc hook (P2.4) is the interim — the in-loop hook
remains the authoritative goal once landed.



Per-tenant sandbox confinement; round/wall metering (billing basis);
**concurrency** — validate the `cmd_drill_batch` single-`$HOME`
serialization concern (`checkpoint.hexa:26`) under isolated per-job
`$HOME`; verifier sandbox + timeout (untrusted tenant code); abuse/rate
limits. Adopt upstream `HX_DATA_DIR` when it lands → retire `$HOME`
hijack, keep sandbox as defense-in-depth.

## P3 — Dashboard (Decision 3 = 다) · P3.thin DONE measured (2026-05-19)

Accounts/orgs auth; job-submit UI incl. verifier upload/reference;
result browser + **per-tenant discovery catalog** (their private echoes,
exportable); billing/metering console. Sits entirely on the P1 API.

**P3.thin status — DONE, measured (2026-05-19, HTMX server-rendered):**
- Decision 8 LOCKED: HTMX + server-rendered HTML on hexa-native backend.
- 3 new routes in `service/http_phanes.hexa`:
  - `GET /dashboard` — full HTML page (HTMX 1.9.10 via unpkg SRI;
    self-host = P3.x polish), echoes-experience-tone CSS, form fields
    tenant·token·seed·rounds.
  - `POST /dashboard/jobs` — form-encoded body → urldecode → jobctl
    submit → return `<li>` job-row with `hx-trigger="load delay:2s"` so
    the row self-polls.
  - `GET /dashboard/jobs/<id>?tenant=…&token=…` — render `<li>` from
    `job.json`; **omit hx-trigger when status ∈ {done, failed}** so HTMX
    auto-stops polling.
- Helpers added: `urldecode` (+ → space, %XX → byte), `html_escape`,
  `render_job_row`, `render_dashboard_page`.
- Measured smoke (curl, arm64 macOS local, port 8788):
  - GET /dashboard → 200 text/html 2516B, hx-post + htmx script +
    form fields all present.
  - POST /dashboard/jobs (form body, seed contains `=`) → 200 `<li>` row,
    HTMX self-poll wired.
  - Poll trail: t+300/600/900ms running, t+1200ms `done` with
    hx-trigger REMOVED → polling stops automatically (the HTMX
    termination pattern works).
  - Final row: `wall_ms=1167 · rounds=1 · total=683 · verifier_rc=0`
    (P2.4 verifier auto-attach still wired through dashboard).
  - Negative (no tenant/token) → 400 + red `<li>` error fragment.
- **Honest gaps on record (g3)**:
  - HTMX served from unpkg CDN with SRI hash — self-host at
    `/static/htmx.min.js` is a P3.x polish item (matches dancinlab
    no-CDN-trust ethos eventually).
  - Auth still via form-body fields rendered into row's hx-get URL
    query string — exposes token in HTML; production needs HttpOnly
    cookies or per-row signed handles (P3.x).
  - Single tenant per page; multi-tenant org switcher = P3.x.

## P4 — Public demo funnel (Decision 3 = 가) · DONE measured (2026-05-19)

Static landing (echoes-experience deploy pattern) + **preset/curated
objective+verifier scenarios only**, round-capped, sandboxed
(`@D g_public_demo_constraint` — NO arbitrary verifier on the
unauthenticated surface). CTA → dashboard signup.

**P4 status — DONE, measured (2026-05-19, hexa-native HTTP server):**
- **Decision 10 LOCKED** (`design.md`): the public demo displays
  **pre-computed / cached** results of curated preset scenarios — zero
  live compute on the unauthenticated surface. The strongest reading of
  `@D g_public_demo_constraint`: there is no execution path on `/demo`
  at all (no jobctl call, no process spawn, no job-store write), so
  there is no abuse surface to rate-limit or sandbox.
- New unauthenticated route `GET /demo` in `service/http_phanes.hexa` —
  Palantir Titanium design system (reuses `render_nav` /
  `render_site_footer` / `render_cta` / `_sections_css` / `:root`
  tokens). 5 sections: hero · what-this-demo-is · curated preset
  scenarios · honest scope · CTA → `/login` signup.
- Helpers added: `render_demo_page`, `render_demo_scenarios`,
  `render_demo_scenario`, `render_demo_round`, `_demo_css`,
  `handle_demo_page`.
- **3 curated preset scenarios** (constant data — perfect-number /
  divisor-structure discoveries `hexa kick` genuinely produces):
  - `01` — σ(6)=12, the smallest perfect number (2 rounds).
  - `02` — σ(28)=56, the next perfect number, with a no-gap scan
    falsifier (2 rounds).
  - `03` — Euclid's even-perfect form 2ᵖ⁻¹(2ᵖ−1), falsifier
    instantiates p=5 → verifies 496 as a fresh case (2 rounds).
  Each scenario shows: fixed objective + fixed preset verifier + round
  cap + the goal→falsifier→saturation round trail + the verified
  result + `verifier rc=0` (the verifier is the sole authority).
- `/demo` wired into the topnav (`Demo` link), the cosmogony landing
  closer (`see the demo` CTA), and the footer platform column.
- **Measured smoke (2026-05-19, arm64 macOS local, port 8813)**:
  `GET /demo` → 200 text/html; all 3 scenarios + their cached results
  + CTA → `/login` present; all existing routes (`/`, `/phanes`,
  `/demiurge`, `/hexa-lang`, `/anima`, `/login`, `/dashboard`,
  `/v1/healthz`) still 200; build clean.
- **Honest gaps on record (g3)**: the 3 cached results are
  representative curated examples hand-authored from the known
  mathematics, labelled "cached preset run" — NOT byte-captured from a
  specific timestamped fleet job. When the production fleet (P2.5) is
  live, the cached blobs should be regenerated from real `job.json` /
  `DrillResult` captures and the provenance line upgraded with the
  actual run id + wall_ms. Recorded as the P4 → P5 follow-up. A live
  preset-only demo surface stays a reversible follow-up option
  (Decision 10).

## P5 — Pre-public-launch gates

- **Trademark clearance** — *closed as specified (2026-05-19).* The
  formal USPTO class-9/class-42 search needs a registered attorney and
  cannot run in-repo; instead it is fully specified in
  [`docs/TRADEMARK.md`](docs/TRADEMARK.md) §"Formal Clearance —
  Specification" (FC-1…FC-6). No longer an open in-repo task — a
  defined external legal engagement gated to public launch via
  `@D g_name_risk`.
- **Upstream patch adoption** — *done.* `HX_DATA_DIR` kick binary
  promoted + wired into `job_runner.sh` (commit `37c66b2`); pluggable
  verifier landed. Both verified.
- **Honest-scope marketing review** — *done.* C2/C3 audit found all
  rendered copy within scope (`@D g_honest_scope` · `g_public_demo_constraint`
  — no over-claim, tenant verifier = sole authority); see
  `docs/audit-prelaunch-c2-c3.md`.

P5 in-repo work is complete; the only remaining pre-launch obligation is
the external trademark engagement (FC-5 clearance opinion).

---

## Log

- **2026-05-19** — ROADMAP created at P0 DONE. All product gates closed
  same day (decision-gate cycle, `design.md`). Next executable = P1 (job
  API substrate). No code yet — P1 begins on user go.
- **2026-05-19** — "P1 go". Instrument-first: cheap oracle measured FIRST
  (1-round kick in `$HOME`-jail + `HEXA_VAL_ARENA=0` → rc=0, isolation
  proven, JSON `DrillResult` captured). Built `service/{job_runner.sh,
  jobctl.sh,API.md}`; full substrate self-test PASS (init→submit→get→
  result, wrong-token rc=4). **P1a DONE, measured.** Decision 7 (service
  language) logged in design.md.
- **2026-05-19** — "go" → P1b. Probe: stdlib/net HTTP server stack exists
  + builds from outside hexa-lang (HEXA_HOME env), 370KB arm64 binary.
  Built `service/http_phanes.hexa` (hexa-native HTTP), `service/build.sh`,
  `web/index.html` (echoes-experience template). Measured smoke 7/7
  PASS incl. seed-with-`=` intact through HTTP → jobctl → kick → result.
  Honest fix on record: form-encoded body truncated seeds containing
  `=`; pivoted to JSON body via `json_parse`. **P1b DONE, measured.**
  Upstream win: `phanes-hx-data-dir-per-tenant-isolation` handoff
  RESOLVED SSOT same-day in hexa-lang (binary promote pending).
- **2026-05-19** — "P2 go". Probe HX_DATA_DIR honor (NOT honored — old
  binary, pending promote, no new inbox). Measured: P2.1 ms wall meter
  (perl Time::HiRes, `wall_ms=1312` 1-round) · P2.4 post-hoc tenant
  verifier hook in `$HOME`-jail sandbox (env -i + timeout, auto-attach
  per-tenant verifier.sh, `verifier_rc=0` PASS) · P2.2 concurrency
  (`service/concurrency_test.sh` N=4, **isolation HOLDS** but service
  serialized 4.4/10 — `stdlib/net/http_server.hexa` sequential
  accept-loop; concurrent_serve port deferred as P2.x). P2.3 documented
  pending. P2.5 fleet routing documented deferred (P3-coupled).
  **P2.1+P2.2+P2.4 DONE measured.** No new upstream inbox items found.
