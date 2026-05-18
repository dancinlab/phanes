# ROADMAP — phanes

> Phased execution plan. All product decisions (1–6 + B-surface) are
> CLOSED in `design.md`; this is the build path. Discipline:
> echoes-experience thin slices — ship the smallest credible layer, never
> big-bang. g3: every status honest, measured (instrument-first for any
> cost-bearing fleet run).

Locked design (from `design.md`): scope **B** generic autonomous-cycle
platform · brand **Phanes** · `dancinlab/phanes` private · deployment
**가+다** (public demo funnel + dashboard, **API = shared substrate**) ·
multi-tenant **다 hybrid** ($HOME-jail now + upstream `HX_DATA_DIR`) ·
license **proprietary**.

---

## P0 — Foundations · DONE (2026-05-19)

Repo, governance (AGENTS.tape), GOAL/design/README/LICENSE, decision
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

## P2 — Compute-plane hardening

Per-tenant sandbox confinement; round/wall metering (billing basis);
**concurrency** — validate the `cmd_drill_batch` single-`$HOME`
serialization concern (`checkpoint.hexa:26`) under isolated per-job
`$HOME`; verifier sandbox + timeout (untrusted tenant code); abuse/rate
limits. Adopt upstream `HX_DATA_DIR` when it lands → retire `$HOME`
hijack, keep sandbox as defense-in-depth.

## P3 — Dashboard (Decision 3 = 다)

Accounts/orgs auth; job-submit UI incl. verifier upload/reference;
result browser + **per-tenant discovery catalog** (their private echoes,
exportable); billing/metering console. Sits entirely on the P1 API.

## P4 — Public demo funnel (Decision 3 = 가)

Static landing (echoes-experience deploy pattern) + **preset/curated
objective+verifier scenarios only**, round-capped, sandboxed
(`@D g_public_demo_constraint` — NO arbitrary verifier on the
unauthenticated surface). CTA → dashboard signup.

## P5 — Pre-public-launch gates

Trademark clearance USPTO class-42 (`@D g_name_risk`) BEFORE public;
upstream patches landed or interim documented (`HX_DATA_DIR` +
pluggable verifier); honest-scope marketing review (`@D g_honest_scope`
· `g_public_demo_constraint` — no over-claim, tenant verifier = sole
authority).

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
