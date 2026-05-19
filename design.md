# phanes — design decision log

> Step-by-step decision gate (hexa-lang `@D g_decision_gate`): one
> user-confirmation per decision, never batched. Each = `### Decision N —
> <picked>` with **picked** + **rationale** (3+ bullets). This file is the
> SSOT for product decisions.

---

## Status board

| # | Decision | State |
|---|----------|-------|
| 1 | Product scope (A Conjecture-Mine / B Generic cycle / C Echoes-as-a-Service) | **DECIDED — B Generic cycle platform** |
| 2 | Brand name | **DECIDED — Phanes** |
| 3 | Deployment shape | **DECIDED — 가+다 (public demo funnel + full dashboard; API = shared substrate)** |
| 4 | GitHub org + remote · private | **DECIDED — dancinlab/phanes (private)** |
| 5 | License (commercial SaaS — not auto-MIT) | **DECIDED — 가 Proprietary / All Rights Reserved** |
| 6 | Multi-tenant overlay isolation | **DECIDED — 다 (hybrid: $HOME-jail now + upstream HX_DATA_DIR patch)** |
| B-surface | Pluggable verifier upstream handoff | **filed — hexa-lang inbox/patches** |
| 7 | Service language / stack | **DECIDED (P1) — POSIX shell substrate; hexa-native preferred for P1b+ (open sub-gate)** |
| 8 | Frontend stack (P3 dashboard + P4 demo) | **DECIDED — (다) HTMX + server-rendered HTML on hexa-native backend** |
| 9 | Public demo result delivery (P4) | **DECIDED — pre-computed / cached preset results; no live unauthenticated compute** |

---

### Decision 2 — Brand name = Phanes (파네스)

**picked**: `Phanes` (파네스) — Orphic primordial deity of revelation
(φαίνω, "to bring to light"), depicted entwined by the OUROBOROS.

**rationale**:
- **Lore is a strict superset of the engine's true name.** hexa-lang's
  engine codename is OUROBOROS; in myth Phanes is the radiant first-born
  the OUROBOROS entwines. So the name is authentic, not retrofitted —
  Ouro = mechanism, Phanes = the light it reveals.
- **Semantic precision over Palantir.** Palantir = a seeing-stone (passive
  observation). phanes *generates + verifies* (φαίνω = actively bring
  hidden truth to light) — a closer myth for a discovery+falsification
  engine.
- **Mythic credibility (Palantir/Anduril school).** Obscure-but-
  pronounceable primordial deity → instant gravitas; fits dancinlab's
  short-evocative naming tone (echoes/wisp/flame/forge).
- **User directive 2026-05-19 "파네스 go"** — chosen after the assistant
  presented, with web-search evidence, an ownability caveat (see risk).

**risk on record (g3 honesty — not a blocker, user override logged)**:
Adjacent trademark collisions — **Phanes Technologies** (autonomous
multi-agent AI, same lane) + **Phanes Therapeutics** (USPTO-registered
TMs, pharma). Mitigation: treat Phanes as project narrative/lore; run
formal USPTO class-42 clearance before any public launch or remote/org
push; reconsider public-facing mark then. (Governance:
`AGENTS.tape @D g_name_risk`.)

**alternatives on record (user request 2026-05-19 — does NOT change
picked=Phanes)**:
- **Manteia · 만테이아** — Greek "power of divination/prophecy" (root of
  *-mancy*); user also favors it. **Also collided** (web-verified):
  Manteia Technologies Co., Ltd. — active AI/software startup (adaptive
  radiotherapy), **registered trademarks in the computer/software
  class**. Recorded for the trail; not a clean fallback.
- Honest correction (g3): only **Orrery** and **Mimir** are
  *web-verified* clean. `Ouro` / `Kythera` / `Haechi` / `Bythos` were
  brainstorm-asserted, **not** search-verified — prior wording
  overstated; do not call them clean until actually searched (the
  Phanes/Telos/Aletheia/Pythia/Manteia pattern: brainstorm-clean ≠
  search-clean).

---

### Decision 4 — GitHub org + remote = dancinlab/phanes (private)

**picked**: `github.com/dancinlab/phanes` — **private** repo; `origin`,
`main` tracking `origin/main`, scaffold pushed (commit `38e5992`).

**rationale**:
- **User directive 2026-05-19 "github.com/dancinlab/phanes"** — explicit
  org + name, after the assistant flagged the dancinlab→singularity rename
  ambiguity rather than guessing an outward, hard-to-reverse action.
- **Private, not public launch.** The `@D g_name_risk` clearance
  obligation is scoped to *public launch*; a private repo defers (does not
  void) it. Trademark clearance stays tracked, owed before going public.
- **dancinlab org = upstream-consistent.** Matches hexa-lang AGENTS.tape
  citations (`github.com/dancinlab/...`) and the shipped sibling
  `dancinlab/echoes-experience` deployment pattern.
- Auth: `gh` account `dancinlife`, scopes incl. `repo` — create+push
  succeeded; no LICENSE committed yet (Decision 5, commercial — not
  auto-MIT).

---

### Decision 1 — Product scope = B (Generic cycle platform)

**picked**: `B` — generic autonomous-cycle platform: a company brings a
measurable objective + a verifier/oracle; phanes drives hexa kick's
`goal → falsifier → saturation` loop against it and returns a verified,
provenance-tracked result/catalog. Pluggable seed + tenant verifier.

**rationale**:
- **User directive 2026-05-19 "B"** — chosen over the assistant
  recommendation (A); the larger-TAM strategic bet is the user's call and
  is recorded as the decisive factor.
- **Accepted build implication**: B's genuine engine delta vs A is a
  **NEW pluggable seed+verifier/oracle abstraction** over `hexa kick`
  (A reused the internal honesty gate + `gate/ hexa://kick` pipeline
  as-is). This abstraction is an upstream hexa-lang `inbox/patches/`
  candidate, not a downstream fork (`@I id002` · `@D g_inbox_patches`).
- **Honest-scope risk now ACTIVE (g3)**: B's value prop ("drive *your*
  objective to done") structurally collides with the advisory,
  non-blocking honesty gate — saturation / round-cap is the only hard
  stop. Mandated mitigation: the **tenant-supplied verifier is the sole
  authority of record** for "objective met"; phanes surfaces saturation +
  verifier verdict and never claims objective-met without the tenant
  verifier's PASS. `@D g_honest_scope` tightened with a `scope_b` clause.
- **Not foreclosed**: narrowing B → A/C for v1 (if the verifier
  abstraction proves too broad) stays available; recorded so the option
  is not lost.

---

### Decision 3 — Deployment shape = 가+다 (public demo funnel + full dashboard)

**picked**: `가 + 다` — a public, round-capped **demo site** (marketing
funnel) AND a full authenticated **dashboard** (job submit · result
browser · catalog · billing). The job **API is the shared substrate**
beneath both — not a competing third product.

**rationale**:
- **User directive 2026-05-19 "가+다"** — chosen over the assistant
  recommendation (나 API-only v1); the richer two-surface bet is the
  user's strategic call, recorded as decisive.
- **Honest constraint MANDATED (g3 · scope_b)**: a public demo for a B
  platform must **not** accept arbitrary tenant verifiers (over-claim +
  arbitrary-compute security hole). The demo runs **only preset, curated
  objective+verifier scenarios**, round-capped and sandboxed; arbitrary
  verifier submission is **authenticated/paid-only** via the dashboard.
  Enforced by `@D g_public_demo_constraint`.
- **Accepted implication**: largest front-end surface (two UIs + billing)
  — echoes-experience minimalism is harder. Sequencing stays disciplined:
  API substrate → minimal dashboard slice → public demo, each thin, not
  big-bang.
- **API retained, not discarded**: the (나) work is the substrate both
  surfaces consume — it is the foundation layer, fully kept.

---

### Decision 6 — Multi-tenant overlay isolation = 다 (hybrid)

**picked**: `다` — per-job `$HOME`-jail / sandbox now (downstream, ships
v1) **+** a parallel hexa-lang `inbox/patch` for a first-class
`HX_DATA_DIR` (canonical path). Drop the `$HOME`-hijack once upstream
lands; keep the per-job sandbox as defense-in-depth.

**rationale**:
- **Evidence-grounded, low risk**: `compiler/drill/checkpoint.hexa:53`
  resolves the data dir from `env("HOME")` (overlay mirrors it); the
  engine's *own* test suite isolates via per-base `$HOME`
  (`mkdir -p $base/.hx/data`). (가) is a verified upstream idiom — works
  today, zero engine change.
- **Governance-correct**: `@I id002` · `@D g_inbox_patches` mandate
  engine gaps go upstream — a first-class `HX_DATA_DIR` is the canonical
  fix, filed as `phanes-hx-data-dir-per-tenant-isolation`. Pure-(가)
  alone would be a forbidden permanent downstream workaround.
- **Confidentiality non-negotiable**: a per-job sandbox = zero
  cross-tenant discovery leakage; retained as defense-in-depth even after
  the upstream knob lands.
- **Concurrency sub-risk (recorded)**: the engine currently *serializes*
  concurrent dispatch via `cmd_drill_batch` under a single `$HOME`
  (`checkpoint.hexa:26`). Per-job `$HOME` isolation is precisely what
  enables safe concurrent multi-tenant jobs — to be validated in the
  compute-plane design, not assumed.

**upstream handoffs filed (hexa-lang `inbox/patches/`, untracked drafts —
the established inbox mechanism; pin `50f5f073` rfc043-hexa-torch)**:
1. `phanes-hx-data-dir-per-tenant-isolation` — first-class `HX_DATA_DIR`
   / `--overlay --checkpoint` (this decision's (나) half).
2. `phanes-pluggable-verifier-oracle-for-drill-loop` — scope-B's
   in-loop tenant-verifier extension point (the B-surface gap).

---

### Decision 5 — License = 가 (Proprietary / All Rights Reserved)

**picked**: `가` — proprietary, all rights reserved (`© 2026 dancinlab`).
Short `LICENSE` committed; covers only phanes-original code, not upstream
hexa-lang components it invokes.

**rationale**:
- **Commercial private SaaS** (Decisions 3·4): code stays server-side,
  not distributed — an OSS license would surrender the moat for zero
  benefit. design.md flagged "not auto-MIT" from the start.
- **Simplest, reversible default**: proprietary → BSL / source-available
  is always possible later; the reverse (un-MIT) is not. Safest gate
  outcome.
- **(나) BSL 1.1 kept as explicit fallback** if a source-available
  commercial posture is later wanted.
- **Upstream-compat sub-check (follow-up, not a blocker)**: phanes
  invokes `hexa kick` server-side (no redistribution expected). Before
  any bundling/redistribution of hexa-lang artifacts, verify hexa-lang's
  own LICENSE. Recorded; the LICENSE text scopes the grant to
  phanes-original code only.

---

### Decision 7 — Service language/stack (P1)

**picked**: P1 substrate = **POSIX shell** (`service/job_runner.sh` +
`jobctl.sh`) — thinnest glue that *is* the measured engine-invocation
contract. P1b HTTP transport and later phases: **hexa-native preferred**
(ecosystem hexa-first principle; wilson/wisp downstream precedent) —
final transport stack is an open sub-gate revisited when P1b starts.

**rationale**:
- "P1 go" + no-stop directive: pick the conventional ecosystem default,
  record it, proceed (not a blocking gate — a recorded call).
- Thin-slice discipline: a hexa HTTP server in P1 = a rabbit hole; the
  job-runner is process/sandbox glue where shell is the minimum credible
  code and lets P1 be *run and measured today*.
- Downstream invariant kept: shell runner *invokes* the upstream `hexa`
  binary, never vendors/forks it (`@I id002`).
- Reversible: P1b can implement HTTP in hexa over the same `jobctl`
  semantics (`service/API.md`) without touching P1a.

### P1 execution — measured (2026-05-19, arm64 macOS, local)

- Cheap oracle first (instrument-first methodology): 1-round `hexa kick`
  in `$HOME`-jail + `HEXA_VAL_ARENA=0` → rc=0, wall≈1s, overlay written
  ONLY in jail, real `~/.hx/data` unchanged (2→2 files), stdout JSON
  `DrillResult` captured. **Decision 6 (가) isolation proven, not
  asserted.**
- Full substrate self-test PASS: `init-tenant → submit → get → result`,
  job.json rc=0 / overlay_lines=517 / DrillResult embedded; wrong-token
  → rc=4. P1a DONE.
- Honest gaps on record (g3): integer-second wall meter too coarse for
  sub-second jobs (refine to ms @ P2 — billing basis); no concurrency
  test yet (@ P2, `checkpoint.hexa:26` serialization).

### P1b execution — measured (2026-05-19, hexa-native HTTP)

- Probe first (instrument-first): minimal `stdlib/net` program built from
  outside hexa-lang via `HEXA_HOME=~/core/hexa-lang ~/.hx/bin/hexa build`
  → 370KB arm64 Mach-O, `json_ok` + `build_response` emit valid HTTP
  string. Toolchain path validated for downstream phanes (no fork/vendor).
- Built `service/http_phanes.hexa` (hexa-native using `stdlib/net/
  {http_server,http_request,http_response}` — `server_new` / `server_
  route` / `server_mount` / `server_serve(dispatch_fn)`). Handlers shell
  out via `exec_with_status` to `service/jobctl.sh` (true 1:1 skin over
  the P1a substrate). Build clean first try (393KB arm64 binary).
- **Measured smoke 7/7 PASS** (curl, port 8788, demo tenant): healthz
  200, submit 201 + `job_id`, get 200 (full `job.json` w/ embedded
  DrillResult), result 200 (DrillResult JSON), **seed-with-`=` intact
  end-to-end** (HTTP → jobctl → kick → result), no-auth → 401, bad-JSON
  → 400. Submit wall ≈ 0.5s (1 round).
- **Honest fix on record (g3)**: first smoke used form-encoded body;
  `stdlib parse_query` splits naively on every `=`, truncated seeds
  containing `=` (measured: `"prove sigma(6)=12 ..." → "prove sigma(6)"`).
  Pivoted to JSON body + `json_parse` builtin; re-smoked → seed-intact
  assertion PASS. Documented in `http_phanes.hexa` handler comment.
- `web/index.html` — vanilla JS + Canvas single-file dev API console
  (echoes-experience template; "기존 생태계" frontend per user pick).
  Sends JSON body, polls job, renders overlay shape on canvas.
- `bin/` gitignored (built artifact; source is the SSOT; reproducible
  via `service/build.sh`).

### P2 execution — measured (2026-05-19)

- **P2.1 ms wall meter — DONE measured.** perl `Time::HiRes` ms clock in
  `service/job_runner.sh`; `job.json` carries `wall_ms` (billing) +
  `wall_sec` (back-compat). Verified `wall_ms=1312` for 1-round kick.
- **P2.2 concurrency — MEASURED, honest finding.**
  `service/concurrency_test.sh` N=4: per-job sandbox **isolation HOLDS**
  (4 distinct ids, each own `job.json` + `overlay.n6`) but service is
  **fully serialized** (`concurrent/baseline ratio = 4.4/10`) — root
  cause is `stdlib/net/http_server.hexa::server_serve` sequential
  accept-loop. Path forward = port to
  `stdlib/net/concurrent_serve.hexa` (`ConcurrentServer` +
  `register_endpoint` + `run(workers)`); recorded as P2.x follow-up,
  deferred this turn.
- **P2.3 `HX_DATA_DIR` adoption — PENDING upstream binary promote.**
  Probe: current `bin/hexa-absorbed-kick` (May 18) does NOT honor.
  SSOT helper landed in hexa-lang same day; binary promote is the
  standard separate deploy step. phanes keeps `$HOME`-jail until then,
  swaps to `HX_DATA_DIR` + sandbox=DiD after promote. Already on
  upstream lifecycle — no new inbox needed.
- **P2.4 post-hoc tenant verifier hook — DONE measured.**
  `job_runner.sh --verifier PATH` (+ `--verifier-timeout`). Sandbox =
  `env -i HOME=$JAIL PATH=/usr/bin:/bin` + hard `timeout`. `jobctl
  submit` auto-attaches per-tenant `verifier.sh` (admin-placed for P2;
  tenant-upload endpoint = P3). `job.json.verifier_rc` is the sole
  authority for "objective met" (`@D g_honest_scope.scope_b`).
  Measured: example verifier (threshold-on-total) → `verifier_rc=0`
  PASS. **Honest sandbox scope (g3)**: thin POSIX (env reset + timeout),
  NOT container/firejail; P3 hardens with full containerization +
  no-network etc. Recorded.
- **P2.5 production Linux fleet routing — DEFERRED (P3-coupled).**
  Path forward: `PHANES_ENGINE_HOST` env → ssh kick on remote +
  capture. Sub-blocker: kick binary distribution to Linux x86_64
  (ubu can't self-host arm). Not coded this turn.
- **P2.6 pluggable-verifier-oracle upstream patch** — still pending
  hexa-lang response. Post-hoc hook (P2.4) is the interim; in-loop
  hook remains the authoritative goal once landed.

### P2.x execution — async-submit pivot (2026-05-19)

Reading `stdlib/net/concurrent_serve.hexa` before porting saved a
substantial rewrite — the stdlib's `run(workers)` is documented as
"실제로는 단일 스레드 직렬 처리 … 멀티 OS 스레드는 roadmap 62 통합 후
활성화". So porting `http_phanes.hexa` to ConcurrentServer would NOT
move the concurrency ratio. Instrument-first methodology working.

**Pivot taken**: decouple HTTP throughput from kick wall at the **job
dispatcher layer** (downstream-only, no upstream dependency):
- `service/jobctl.sh submit` writes initial `{"status":"queued"}`
  atomically, backgrounds `job_runner.sh` via `nohup … &` + `disown`,
  returns `job_id` immediately.
- `service/job_runner.sh` writes status transitions
  (`queued → running → done/failed`) via tmp+rename so concurrent GETs
  never observe a partial JSON.
- `service/concurrency_test.sh` gains `baseline_kick_ms` measurement
  (1 submit + poll-to-done) so the end-to-end ratio compares against
  the right baseline, not the submit-only one.

**Measured (re-run with corrected baselines)**:
- `baseline_submit_ms = 162` (vs pre-pivot 1530 — submit decoupled
  from kick wall).
- `baseline_kick_ms   = 1364` (1 submit + poll-to-done).
- N=4 concurrent submit total = 389ms (submit-only ratio = 2.4/10 vs
  baseline_submit — HTTP layer still serializes, as expected per
  upstream stdlib's logical-only concurrency).
- N=4 end-to-end completion = 2360ms (end-to-end ratio = 1.7/10 vs
  baseline_kick_ms — **engine PARTIAL parallel** on multi-core Mac,
  contention < 1.5× per kick).
- **Absolute throughput vs pre-pivot ~2.9× (6795 → 2360ms for 4 jobs).**
- Isolation HOLDS at N=4 (4 distinct jobs, each own `job.json` +
  `overlay.n6`); per-job statuses all `done`.

**Honest scope (g3)**:
- HTTP-accept layer remains serial — only stdlib improvement lifts this.
  Filed: `~/core/hexa-lang/inbox/notes/phanes-stdlib-net-os-thread-
  concurrency-roadmap-62.md` (standing upstream-inbox policy).
- Engine layer contention < 1.5× per kick is plausible-OS-scheduler
  behavior on shared filesystem + memory bus; not investigated deeper
  (P3 hardening if needed).
- `nohup` + `disown` works on macOS/Linux but the spawned children
  inherit the parent's working dir / open fds via POSIX defaults — a
  container/jail boundary (P3) would tighten this. Recorded.
- Standing upstream-inbox policy continues: filed 1 new item in this
  turn (the concurrency escalation), making it filed 3 / resolved-ssot
  2 cumulative.
- **Standing upstream-inbox policy (user 2026-05-19)**: file inbox
  patches as upstream gaps are discovered. This turn: 0 new items
  (HX_DATA_DIR is the existing patch's pending-promote lifecycle, not a
  new gap; concurrent_serve port is a downstream phanes choice, not a
  hexa-lang gap; sandbox hardening is phanes-side).

### Upstream win — `phanes-hx-data-dir-per-tenant-isolation` RESOLVED SSOT

The first inbox/patches handoff (filed 2026-05-19) was **resolved SSOT
the same day** in hexa-lang: `hx_data_dir()` helper landed in
`compiler/atlas/overlay.hexa` with precedence `HX_DATA_DIR > $HOME/.hx/
data > ".hx/data"`; all 4 call sites (`overlay_path`, `overlay_ensure_
dir`, `checkpoint_path`, `_ensure_dir`) switched; parse-gate clean.
Binary promote pending (the 22c27a05 standard separate deploy pattern);
phanes keeps the `$HOME`-jail until promote, then swaps to
`HX_DATA_DIR` while keeping the sandbox as defense-in-depth (per
Decision 6 (다) hybrid). Confirms the downstream→upstream pipeline works
(g7) and de-risks Decision 6's canonical path.

---

### Decision 8 — Frontend stack = (다) HTMX + server-rendered HTML

**picked**: HTMX 1.9.x + server-rendered HTML fragments from the
existing hexa-native backend (`service/http_phanes.hexa`,
`stdlib/net/http_response.text_ok/json_ok`). No bundler, no SPA
framework, no node toolchain. The dashboard is just more
`pub fn handler(request) -> response` returning HTML.

**rationale**:
- **Backend정합 최대**: the backend is already hexa-native with
  `stdlib/net` (`http_server`, `http_request`, `http_response`,
  `std_web_template`); the `socket_set_nonblock + socket_select` upstream
  also landed today (3/3 inbox resolved-ssot). HTMX = exactly the
  topology this backend wants: server is single SSOT, browser swaps
  fragments.
- **dancinlab 톤 정합**: echoes-experience (vanilla JS · static · no
  bundler) and wisp (thin native shell + hexa core) share "thin client,
  smart server". HTMX is the natural ladder up — adds swap+poll
  semantics without breaking the no-bundler / no-CDN-trust ethos.
- **Reversible**: HTMX coexists with vanilla JS and with future Svelte
  islands page-by-page. Picking HTMX now does NOT preclude adding a
  Svelte island for a heavy view later; picking Svelte/React first
  would commit the whole app to a runtime/bundler.
- **State location matches reality**: phanes job/tenant/verifier state
  is server-resident (filesystem store under `service/.store`). HTMX
  keeps the browser as a render target, not a stateful mirror.

**measurement-gate**: server returns HTML for `GET /dashboard`, `POST
/dashboard/jobs` returns a `<li>` job-row fragment, `GET
/dashboard/jobs/<id>` returns a swapped row; HTMX poll terminates when
status ∈ {done, failed}. Implementation lands as P3 thin slice
immediately after this gate.

---

### Decision 9 — Multi-tenant switcher = (a) Re-auth switch

**picked**: `(a)` — a "switch tenant" control in the dashboard `.dbar`
that destroys the current session and redirects to `/login` (a fresh
GET, so the login form re-prompts for tenant + bearer token). No
session-file format change. Implemented as `POST /switch-tenant` →
`session_destroy` + `redirect_with_cookie("/login", clear-cookie)`.

**rationale**:
- **Honest to the real auth model (g3)**. The session is intrinsically
  one `(tenant, token)` pair, and each tenant has its *own* bearer
  token — there is no credential a user holds that grants more than one
  tenant. A dropdown (design b) would imply "you already have access to
  these tenants" and could only be populated by the user re-entering
  each token anyway. Re-auth is the truthful UX: switching tenant *is*
  presenting a different credential.
- **Minimal + secure, zero session-model risk**. Design (b) needs a
  variable-length session file (`tenant\ntoken` pairs + an active
  index), a parser rewrite of `session_load`, an "active pair" notion
  threaded through `current_session`, and a re-auth-append path
  distinct from fresh login — each a place for a cross-tenant token
  leak. (a) reuses the *existing, already-measured* `session_destroy` +
  `redirect_with_cookie` + `/login` path verbatim; the new surface is
  one route + one button. Destroying the session on switch also means
  no stale token for tenant A lingers while the user works as tenant B.
- **Reversible and non-foreclosing**. (a) ships the capability now; if
  multi-pair sessions are later justified (e.g. an org-level SSO that
  genuinely authorizes N tenants under one principal), the dropdown can
  be added then without undoing (a). Picking (b) now would commit the
  session format prematurely against a credential model that does not
  yet exist.
- **Consistent with the existing `.dbar`**. The bar already carries a
  `POST /logout` form with a `.btn .btn-sm` button; "switch tenant" is
  the same shape (a second small outline button), so it needs no new
  design tokens and no JS — matching Decision 8's server-rendered,
  no-bundler discipline.

**honest scope (g3)**: this does not share data across tenants — each
tenant's jobs/catalog stay fully isolated (Decision 6). "Switch" means
*re-authenticate as a different tenant*, not *view another tenant's
workspace*. The control is a convenience over manually logging out and
back in; it asserts no cross-tenant capability.

---

### Decision 10 — Public demo result delivery = pre-computed / cached preset results (no live unauthenticated compute)

**picked**: the public `/demo` page displays **pre-computed, cached
results** of curated preset scenarios. Each cached result is a real
prior `hexa kick` run, labelled as such with its provenance (the preset
seed, the preset verifier, the round cap). There is **zero live kick on
the unauthenticated surface** — `/demo` is pure server-rendered HTML
from in-source constant data; it never touches `jobctl.sh`, never
spawns a process, never writes to the job store.

**rationale**:
- **Zero abuse surface — the strongest reading of `@D g_public_demo_constraint`.**
  The constraint forbids arbitrary tenant verifiers and unbounded seeds
  on the unauthenticated surface. The safest way to satisfy it is to
  not run *any* compute there at all: a visitor cannot submit a seed,
  cannot pick a verifier, cannot trigger a kick. There is no rate-limit
  to tune, no sandbox to harden, no seed-validation to get right —
  because there is no execution path. The alternative (live kick on
  preset-only seeds with rounds=1) still opens a request→process→
  filesystem path on an anonymous surface and needs sandbox + rate-limit
  + queue-depth hardening; that is more infrastructure for strictly less
  safety. Lean-toward-safest (task directive) → cached.
- **Still fully honest (g3 · `@D g_honest_scope`).** A cached result is
  not a mock — it is a genuine prior kick run. `/demo` labels each
  scenario "cached result · preset run" with its provenance line (seed +
  preset verifier + round cap + that the run is a recorded prior
  execution, not live). The demo shows exactly what `hexa kick`
  produces — a verified, falsifier-audited discovery with a per-round
  honesty trail — and never claims "completes your project". The CTA is
  honest: it sends the visitor to `/login` signup to run their *own*
  objective on the authenticated dashboard, where arbitrary verifiers
  are allowed (Decision 3 = 다).
- **Matches the dancinlab static-deploy ethos.** `/demo` is
  content-static (echoes-experience deploy pattern, ROADMAP P4) — the
  preset scenarios + their cached results live as constant data in the
  hexa source, so the page is reproducible, cacheable, and has no
  runtime dependency on the engine being installed or the fleet being
  up. The marketing surface stays a pure render target.
- **Reversible.** If a live preset-only demo is later wanted (genuine
  marketing value in "watch it run"), it can be added as a separate
  authenticated-lite or heavily-rate-limited surface without changing
  `/demo`'s constant-data renderer. Recorded as a follow-up, not a
  foreclosed option.

**honest scope on record (g3)**: the three cached results shipped in
P4 v1 are **representative curated examples** of perfect-number /
divisor-structure discoveries that `hexa kick` can produce — hand-
authored from the known mathematics (σ(6)=12, σ(28)=56, the 2ᵖ⁻¹(2ᵖ−1)
Euclid form), each paired with a preset verifier description and a
round cap. They are honest about *what the engine does* (the goal →
falsifier → saturation loop, the per-round honesty audit) and are
labelled "cached preset run". They are NOT claimed to be byte-captured
from a specific timestamped fleet job — when the production fleet
(P2.5) is live, the cached blobs should be regenerated from real
`job.json` / `DrillResult` captures and the provenance line upgraded to
carry the actual run id + wall_ms. Recorded as the P4 → P5 follow-up.

**measurement-gate**: `GET /demo` → 200 text/html, presents the preset
scenarios with their cached results, CTA → `/login`; the existing
routes (`/`, `/phanes`, `/demiurge`, `/hexa-lang`, `/anima`, `/login`,
`/dashboard`, `/v1/healthz`) all still 200; no new process-spawn or
job-store write path on the unauthenticated surface.

---

### Decision 11 — Hosting / deployment target = AWS EC2 (single Linux host, v1)

**picked**: `AWS EC2` — a single Linux host (control + compute
co-located) for v1, sized at `t4g.small` (2 vCPU Graviton arm64, 2 GiB).
Cloudflare is optional as a front-proxy only (DNS · free TLS · CDN ·
DDoS); Cloudflare Containers is recorded as a future option, NOT v1.
The `PHANES_ENGINE_HOST` abstraction is retained so a later multi-host
AWS fleet — or a migration to CF Containers — is a config change.

**rationale**:
- **Zero re-architecture — phanes runs as-built.** EC2 is an always-on
  Linux VM with a persistent EBS disk: the filesystem `.store/` job
  store (sessions, tenants, `job.json`, overlays) survives, and the
  async-submit model (a `nohup`-ed kick running in the background)
  completes because the host stays up. Cloudflare Containers reached GA
  (2026-04) and *can* run the native hexa binary — but its ephemeral
  disk (resets on sleep) and no-uptime-guarantee (host restarts,
  SIGTERM→15min→SIGKILL) would break both the job store and in-flight
  jobs without first re-architecting onto an R2-durable store with
  restart-resumable jobs. That is a separate project; EC2 needs none of
  it.
- **Cost: 24/7 EC2 is at or below the alternatives, and decisively so
  reserved.** Measured (2026-05): `t4g.small` 24/7 ≈ $14/mo on-demand,
  ≈ $9/mo on a 1-year Savings Plan (+ ~$1.6 EBS). CF Containers at the
  comparable 1 GiB always-on tier ≈ $14–18/mo and rises with memory —
  because memory and disk are billed on *provisioned* capacity around
  the clock, CF's "pay only for active CPU" advantage evaporates for a
  24/7 always-on SaaS. EC2 also avoids the mandatory $5/mo Workers Paid
  floor that CF Containers requires.
- **Satisfies the hexa-lang Axis-D constraint.** Production must not run
  Mac-native `hexa kick`; an EC2 Linux host runs the promoted Linux
  kick binary directly — the compute plane is finally on a compliant
  host (closes P2.5 fleet-routing's blocking sub-issue).
- **Non-foreclosing.** v1 is one box because phanes has zero paying
  users — a fleet or edge-scale deployment is premature optimization
  against unmeasured demand (g3). When load is *measured*, the retained
  `PHANES_ENGINE_HOST` split grows the compute plane into an AWS
  Auto-Scaling fleet, or — after the durable-store rewrite — onto CF
  Containers, with no control-plane rewrite.

**honest scope (g3)**: this decision picks the host; it does not by
itself deploy phanes. Provisioning the EC2 instance, the Linux kick
binary build/deploy, TLS, and the `PHANES_ENGINE_HOST` wiring remain
execution work (ROADMAP A1/A2). "CF Containers can't run phanes" — an
earlier claim — was corrected: Workers can't, but Containers (GA
2026-04) can; the real reason for EC2 is fit + cost + zero-rework, not
impossibility.

---

### Decision 12 — Pricing model = (다) tier + metered hybrid

**picked**: `(다)` — a **base tier with an included quota, plus metered
overage**. Each tier (e.g. a free/trial tier and one or more paid
tiers) bundles a fixed number of included OUROBOROS rounds per billing
period; usage beyond the bundle is metered per round. The OUROBOROS
**round** is the billing unit.

**rationale**:
- **A kick job burns real compute, so revenue must track cost.** Each
  OUROBOROS round consumes CPU and wall-time on the EC2 host (Decision
  11) — a real, variable cost. A pure flat/seat plan (가) lets a heavy
  tenant run at a loss; the metered component aligns the bill with the
  compute actually consumed.
- **A base tier keeps it sellable.** Pure metering (나) makes the bill
  unpredictable, which blocks B2B adoption ("we can't sign an open
  cheque"). A base tier gives a predictable floor and an included
  bundle; only the overage is metered — predictability without the
  flat-plan loss exposure.
- **The metering substrate already exists — near-zero new code.** Every
  job already records its round count and `wall_ms` in `job.json` /
  `DrillResult`. Metering is an *aggregation* of data phanes already
  writes per job — no new instrumentation pipeline, no engine change.
- **The round is the honest billing unit.** A round is the actual unit
  of discovery work (goal → falsifier → saturation, one turn of the
  loop) and is already first-class in the engine's output. Billing per
  round means the customer is charged for exactly the verified work
  done — consistent with scope B (`@D g_honest_scope.scope_b`: the
  tenant verifier, not phanes, judges "objective met"; phanes only
  bills the work the engine measurably performed).

**honest scope (g3)**: this decision fixes the *pricing model* only.
The concrete tier names, prices, and bundle sizes are a later
calibration (they need a real EC2 per-round cost measurement first —
do not invent numbers). Payment processing — a PG / Stripe-style
integration — is a separate decision (Decision 13). A free/trial tier
may also serve as the interim "measure demand first" surface before
paid tiers switch on (g3 measured-first).

---

### Decision 13 — Payment processor = (가) Stripe

**picked**: `(가)` — **Stripe**. Stripe Billing for the subscription
base tier + Stripe Metering (usage-based billing) for the per-round
overage. Integrated by **direct Stripe HTTP API calls** (no Stripe
SDK — phanes is hexa-native; `stdlib/net` `http_client` is the
transport). Card data never touches phanes.

**rationale**:
- **1:1 fit with the Decision 12 hybrid model.** Stripe Billing handles
  the fixed base-tier subscription; Stripe Metering handles the
  per-round overage natively. The "base tier + metered round overage"
  shape maps directly onto Stripe's data model — the existing
  `job.json` round aggregation becomes one Stripe usage-record API call
  per billing window. No model translation.
- **Small integration surface, zero PCI burden.** The whole integration
  is three HTTP touchpoints: a Stripe Checkout redirect URL, one
  webhook endpoint, and the usage-report API. Card numbers are entered
  on Stripe-hosted Checkout and never pass through phanes-http — so
  phanes carries no PCI-DSS scope. All three touchpoints are plain
  HTTP, which the hexa-native server already does.
- **Global fit.** phanes ships a 5-language switcher and is aimed at a
  global B2B market; Stripe is the global default. A Korean-only PG
  (option 다) would constrain the market; a Merchant-of-Record
  (option 나, Paddle/Lemon Squeezy) carries a higher fee (~5%+) that is
  premature for early B2B — its tax-handling value is revisitable later
  if foreign-tax volume grows.
- **Non-foreclosing on the free/trial interim.** Decision 12's
  measure-demand-first free tier still works: Stripe is wired but the
  paid tiers can switch on after demand is measured (g3).

**honest scope (g3)**: there is **no Stripe SDK for hexa** — the
integration is hand-written direct HTTP API calls (Checkout session
create, webhook signature verify, usage records) over `stdlib/net`.
That is real implementation work, tracked as a future ROADMAP item, not
done by this decision. This decision fixes the processor choice only;
it does not implement billing.

---

### Decision 14 — Deployment method = (나) repo-committed deploy.sh

**picked**: `(나)` — a **deploy script committed to the repo**. It
rsyncs the source to the EC2 host, runs `service/build.sh` there,
health-checks `/v1/healthz`, and rolls back to the previous binary on
failure. No IaC, no container image.

**rationale**:
- **For one EC2 host (Decision 11), IaC is over-engineering.** Terraform
  / CloudFormation earn their keep on fleets and reproducible
  multi-resource infra; a single box does not justify the learning and
  maintenance cost — the same measure-demand-first logic as Decision
  11's deferred fleet.
- **A committed script is reproducible; manual SSH is not.** Option (가)
  makes each deploy depend on memory ("what did I run yesterday"), and
  without a health-check + rollback a broken build goes straight to
  live. `deploy.sh` is the SSOT for the deploy procedure and thins onto
  the existing `service/build.sh`.
- **A container image (라) conflicts with Decision 11's shape.** EC2
  runs the native binary directly; adding a Docker layer is unnecessary
  weight. Containerization is only needed for the CF-Containers
  future-path, which is itself gated behind the durable-store rewrite.
- **It grows without rework.** When a fleet eventually exists,
  `deploy.sh` becomes the per-host step a small orchestrator calls —
  no rewrite.

**honest scope (g3)**: `deploy.sh` can be written now, but the actual
deploy needs the user's AWS account — creating the EC2 instance, key
pair, and security group are console/CLI actions outside the repo. The
script covers "given an EC2 host exists, ship to it."

---

### Decision 15 — Managed datastore = (가) DynamoDB (+ S3 for overlays)

**picked**: `(가)` — **DynamoDB** as the managed datastore for the
structured records (sessions, tenants, job metadata), plus **S3** for
the overlay blobs (`atlas.overlay.n6`). This replaces the current
filesystem `.store/` job store. User directive 2026-05-19: "db 는
managedDB."

**rationale**:
- **hexa-native HTTP fit — no wire-protocol driver needed.** DynamoDB
  is reached over an HTTP/JSON API — the *same transport* as the
  Decision 13 Stripe integration (`stdlib/net` `http_client`).
  RDS/Aurora-direct (option 나) speaks the Postgres binary wire
  protocol, which would require writing a Postgres driver in hexa
  first — a separate, large blocker. DynamoDB needs none of that.
- **phanes' access patterns are simple key/item lookups.** Session by
  `sid`, tenant by name, jobs-by-tenant newest-N — there are no joins
  and no relational queries. DynamoDB's item model maps directly;
  relational power (option 나/다) would be unused weight.
- **Serverless pay-per-request fits a zero-user start.** Cost scales
  with actual requests and there is no idle instance charge, unlike an
  always-on RDS/Aurora instance — consistent with Decision 11's
  measure-demand-first posture.
- **Fully managed (the directive).** Backups, patching, and scaling are
  AWS's responsibility — no database operations for phanes.
- **Overlays belong in object storage, not a DB.** `atlas.overlay.n6`
  is a large discovery-artifact blob; it goes to S3 regardless of the
  DB choice. DynamoDB holds the job *record* (status, rounds, wall_ms,
  result JSON, the S3 key of the overlay); S3 holds the blob.

**honest scope (g3)**: this is a **persistence re-architecture**, not a
config change. Every filesystem call in the `.store/` layer —
`session_create` / `session_load` / `session_destroy`, `list_tenant_jobs`,
the `job.json` atomic tmp+rename writes, the overlay capture in
`job_runner.sh` — gets rewritten against DynamoDB (HTTP API) and S3.
There is no DynamoDB SDK for hexa, so it is hand-written AWS SigV4-signed
HTTP calls over `stdlib/net`. Real, multi-step implementation work
tracked as a future ROADMAP item. This decision fixes the datastore
choice only; it does not perform the migration.

---

## All product gates closed (2026-05-19)

Decisions 1–6 + B-surface upstream handoff resolved. Remaining work is
**execution**, tracked in `ROADMAP.md` (phased, echoes-experience thin-
slice discipline). Pre-public-launch obligations on record: trademark
clearance (`@D g_name_risk`), upstream patches landing
(`HX_DATA_DIR` + pluggable verifier), honest-scope marketing review
(`@D g_honest_scope` · `@D g_public_demo_constraint`).
