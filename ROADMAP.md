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

## P1 — Job API substrate (the (나) layer everything sits on)

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
