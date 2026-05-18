# phanes service — API contract (P1)

P1 ships the substrate as a CLI (`jobctl.sh`) over a filesystem job
store. **P1b** adds an HTTP transport that is a thin 1:1 skin over these
exact semantics — no new behaviour, just transport. Documented here so
P1b is mechanical.

Auth: `Authorization: Bearer <token>` ↔ `jobctl --token`. Tenant scoping
is mandatory on every call (no cross-tenant read — confidentiality,
`@D g_honest_scope`).

| HTTP (P1b)                     | CLI (P1, verified)                         | Notes |
|--------------------------------|--------------------------------------------|-------|
| `POST /v1/jobs`                | `jobctl submit --tenant T --token K --seed S [--rounds N]` | body `{seed, rounds?}` → `{job_id}`; rounds clamped to `PHANES_ROUNDS_MAX` |
| `GET /v1/jobs/:id`             | `jobctl get --tenant T --token K --job ID` | → `job.json` (rc, wall_sec, rounds, overlay_lines, result) |
| `GET /v1/jobs/:id/result`      | `jobctl result --tenant T --token K --job ID` | → JSON `DrillResult` + overlay handle |
| (admin) provision tenant       | `jobctl init-tenant --tenant T`            | → shared token (P2: real account/billing) |

`job.json` schema (served verbatim):

```
{ "phanes_job":1, "rc":int, "wall_sec":int, "rounds":int, "engine":str,
  "overlay_lines":int, "result": <DrillResult|null>,
  "artifacts": { "stdout","stderr","overlay","result" } }
```

`DrillResult` (from `hexa kick`, passed through unmodified):

```
{ "seed":str, "rounds":int, "total":int, "saturated":bool,
  "engine":str, "overlay_lines":int }
```

Scope-B note: P1 has **no in-loop tenant verifier** (upstream gap filed:
`phanes-pluggable-verifier-oracle-for-drill-loop`). Until it lands, a
tenant verifier is an **external post-hoc gate** over `result` +
`overlay.n6` (`@D g_honest_scope.scope_b` — tenant verifier is the sole
authority for "objective met"; phanes never asserts it itself).

Out of P1 scope (later phases): billing/metering surface (P2 uses
`wall_sec`·`rounds`), dashboard (P3), public preset-only demo (P4,
`@D g_public_demo_constraint`), production Linux-fleet routing (P2,
hexa-lang Axis D).
