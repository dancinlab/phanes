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

## All product gates closed (2026-05-19)

Decisions 1–6 + B-surface upstream handoff resolved. Remaining work is
**execution**, tracked in `ROADMAP.md` (phased, echoes-experience thin-
slice discipline). Pre-public-launch obligations on record: trademark
clearance (`@D g_name_risk`), upstream patches landing
(`HX_DATA_DIR` + pluggable verifier), honest-scope marketing review
(`@D g_honest_scope` · `@D g_public_demo_constraint`).
