# GOAL.log — phanes

Chronological log of GOAL-domain events (scope, decisions narrated as
goal-history, measured milestones). Current GOAL spec = [`GOAL.md`](GOAL.md).

---

- **2026-05-19** — repo scaffold. `~/core/phanes` git init (main). Decision 2
  (name = Phanes) DECIDED with trademark-risk on record; Decision 1 (product
  scope A/B/C) OPEN — next gate. SSOT for progress/decisions = `DESIGN.log.md`.
- **2026-05-19** — Decision 4 DECIDED: pushed to `github.com/dancinlab/phanes`
  (**private**, `origin`/main). Trademark clearance deferred-but-owed before
  any public launch (`@D g_name_risk`).
- **2026-05-19** — Decision 1 DECIDED = **B (Generic cycle platform)** (user
  directive, over assistant rec A). North-star + IS reframed for B; honest-
  scope tightened (`@D g_honest_scope` scope_b — tenant verifier = sole
  authority). B's new engine surface = pluggable seed+verifier abstraction
  (upstream inbox/patches candidate).
- **2026-05-19** — Decision 3 DECIDED = **가+다** (public demo funnel + full
  dashboard; job API = shared substrate) (user directive, over assistant rec
  나 API-only). New governance `@D g_public_demo_constraint`: public demo =
  preset/curated verifiers only, round-capped — arbitrary verifier is
  auth/paid-only.
- **2026-05-19** — Decision 6 DECIDED = **다 (hybrid)**: per-job `$HOME`-jail
  now + upstream first-class `HX_DATA_DIR` patch (canonical). Grounded in
  `compiler/drill/checkpoint.hexa:53` (`env("HOME")`). Two upstream handoffs
  filed to hexa-lang `inbox/patches/` (untracked drafts, pin `50f5f073`):
  `phanes-hx-data-dir-per-tenant-isolation` + `phanes-pluggable-verifier-
  oracle-for-drill-loop`. Next gate: Decision 5 (license).
- **2026-05-19** — Decision 5 DECIDED = **가 Proprietary / All Rights
  Reserved** (LICENSE committed; grant scoped to phanes-original code).
  **ALL PRODUCT GATES CLOSED.** ROADMAP.md created (P0 DONE → P1 job API
  substrate next). Remaining = execution; pre-public-launch obligations
  tracked (trademark clearance · upstream patches · honest-scope review).
- **2026-05-19** — "P1 go". Instrument-first: cheap oracle measured first
  (1-round kick in `$HOME`-jail + `HEXA_VAL_ARENA=0` → rc=0, isolation
  proven). `service/{job_runner.sh,jobctl.sh,API.md}` built; full
  substrate self-test PASS. **P1a DONE, measured** (Decision 6 (가)
  isolation proven). Decision 7 (service lang) = shell substrate /
  hexa-native preferred P1b+.
- **2026-05-19** — "go" → P1b (가 hexa-native backend + 기존생태계
  frontend). `service/http_phanes.hexa` (hexa-native HTTP using
  `stdlib/net`) builds clean (393KB arm64) + `web/index.html` (vanilla
  JS, echoes-experience template). Measured HTTP smoke 7/7 PASS incl.
  seed-with-`=` intact end-to-end. Honest fix: form→JSON body pivot
  (parse_query naive `=` split → json_parse). **P1b DONE, measured.**
  Upstream win: `phanes-hx-data-dir-per-tenant-isolation` RESOLVED SSOT
  same-day in hexa-lang (binary promote pending; phanes uses `$HOME`-
  jail until then).
- **2026-05-19** — "P2 go". P2.1 ms wall meter (perl Time::HiRes,
  `wall_ms=1312`), P2.4 post-hoc tenant verifier hook (env -i + timeout
  sandbox, `verifier_rc=0` PASS), P2.2 concurrency N=4 measured —
  **isolation HOLDS** but service serialized (4.4/10) by
  `stdlib/net/http_server.hexa` accept-loop; concurrent_serve port
  recorded as P2.x. P2.3 HX_DATA_DIR pending upstream binary promote;
  P2.5 fleet routing deferred to P3. **P2.1+P2.2+P2.4 DONE measured.**
  Standing upstream-inbox policy applied: 0 new items this turn.
- **2026-05-19** — "프론트" → Decision 8 = (다) HTMX + server-rendered.
  P3 thin slice landed: `GET /dashboard` HTML + `POST /dashboard/jobs`
  form-body + `GET /dashboard/jobs/<id>` HTMX-polled row that auto-stops
  polling on done/failed. Smoke 5/5 PASS (page · submit · poll trail ·
  final row · negative). Same day: 3rd upstream RESOLVED SSOT
  (`socket_set_nonblock + socket_select`) and hexa-arch brand-pair
  LOCKED as Demiurge (D23/D24/D25). **3/3 upstream + Phanes-Demiurge
  brand pair + P3 thin DONE — all 2026-05-19.**
- **2026-05-19** — "phanes 진행" → P2.x. Instrument-first cheap oracle:
  `stdlib/net/concurrent_serve.hexa` docstring says "실제로는 단일 스레드
  직렬 처리 … 멀티 OS 스레드는 roadmap 62 통합 후" → porting wouldn't
  help. **Pivot**: async-submit at the dispatcher layer (nohup + disown
  + atomic status transitions). **Measured**: baseline_submit_ms 162
  (vs 1530 pre-pivot) · 4-job end-to-end 2360ms (vs 6795 pre-pivot,
  **~2.9× absolute throughput**) · engine ratio 1.7/10 PARTIAL parallel
  on multi-core. Filed 3rd upstream inbox `phanes-stdlib-net-os-thread-
  concurrency-roadmap-62` (escalation; filed 3 / resolved-ssot 2).
  **P2.x DONE measured.**
