# phanes Constitution

## Core Principles

### I. hexa-lang Pointer (NON-NEGOTIABLE)
phanes consumes `hexa kick` (OUROBOROS: goal → falsifier → saturation) and the hexa-lang stdlib via direct import. It does NOT fork the engine, the stdlib, the atlas, or any toolchain primitive. Engine and platform gaps — including pluggable verifier surface, `HX_DATA_DIR`, and any stdlib gap — file upstream via `~/core/hexa-lang/inbox/patches/`. hexa-lang's constitution governs stdlib / atlas / grammar / lattice; phanes adheres to it on those subjects.

### II. Tenant Verifier Is Sole Authority — No Over-Claim
The tenant-supplied verifier/oracle is the sole authority for "objective met". phanes surfaces saturation status and the verifier's verdict; it NEVER claims objective-met without the tenant verifier's PASS. The OUROBOROS honesty gate is advisory. The only hard stop is saturation / round-cap. Undelivered is recorded as undelivered.

### III. Step-by-Step Decision Gate (NON-NEGOTIABLE)
Multi-decision work is one user-confirmation gate per decision, never batched. Each decision lands in `design.md` as `### Decision N — <picked>` with explicit **picked** value and 3+ rationale bullets before the next decision opens. `design.md` is the SSOT for product decisions.

### IV. Tenant Isolation by Construction
Multi-tenant safety is structural, not procedural. Per-job overlay, `$HOME`-jail isolation, no cross-tenant data egress, `HEXA_VAL_ARENA=0` for compute-plane runs. Erosion of isolation for performance, ergonomics, or operational convenience is rejected at review.

### V. Honest Caveat in Surface
The product surface (UI, API responses, dashboards) reflects Principle II verbatim: saturation ≠ objective met; honesty gate = advisory; tenant verifier = sole authority. Marketing language that elides this distinction is a Principle V violation.

## Repository Layout

```
phanes/
├── src/           # worker entrypoint (Cloudflare Workers)
├── service/       # control & compute plane (HTTP service, job runner, deploy)
├── web/           # static frontend (public funnel + dashboard)
├── docs/          # product / platform docs
├── design.md      # decision log (SSOT for product decisions)
├── GOAL.md        # canonical one-sentence goal
├── PLAN.md        # current implementation plan
├── ROADMAP.md     # forward-looking milestones
└── .specify/      # Spec Kit pipeline artifacts (this constitution lives here)
```

## Development Workflow

1. **Decision first.** Every product or platform direction lands in `design.md` as a Decision entry before code moves. One decision per user-confirmation gate (Principle III).
2. **Spec next.** Feature work flows through Spec Kit: `/speckit-specify → /speckit-plan → /speckit-tasks → /speckit-implement`.
3. **Upstream gaps, not local hacks.** When the engine or stdlib lacks a capability, the patch is filed at `~/core/hexa-lang/inbox/patches/<name>.md`. Local workarounds in phanes are blocked when an upstream fix is feasible.
4. **Verifier-first features.** Any feature that touches "objective met" semantics is gated on tenant verifier wiring; UI/API copy is reviewed against Principle II before merge.

## Governance

- This constitution governs phanes-local concerns (product surface, tenant isolation, decision discipline, honest reporting). On stdlib / atlas / grammar / lattice subjects, the `hexa-lang` constitution wins.
- Amendments land via a PR that updates this file, adds a `design.md` decision entry, and bumps semver: MAJOR = principle removal/redefinition · MINOR = new principle/section · PATCH = wording.
- Complexity must be justified in the corresponding `design.md` entry. Default = simpler.

**Version**: 1.0.0 | **Ratified**: 2026-05-21 | **Last Amended**: 2026-05-21
