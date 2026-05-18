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

## P1 — Job API substrate (the (나) layer everything sits on) · P1a DONE (measured 2026-05-19)

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

**P1b — next**: thin HTTP transport over `jobctl` semantics
(`service/API.md`). Stack: hexa-native preferred (ecosystem hexa-first;
wilson/wisp precedent) — final transport choice = Decision 7 sub-gate at
P1b start.

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
  result, wrong-token rc=4). **P1a DONE, measured.** Recorded honest
  gaps: integer-second wall meter (refine ms @P2), no concurrency test
  yet (@P2), HTTP not built (P1b next). Decision 7 (service language)
  logged in design.md.
