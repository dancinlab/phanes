# phanes — design decision log

> Step-by-step decision gate (hexa-lang `@D g_decision_gate`): one
> user-confirmation per decision, never batched. Each = `### Decision N —
> <picked>` with **picked** + **rationale** (3+ bullets). This file is the
> SSOT for product decisions.

---

## Status board

| # | Decision | State |
|---|----------|-------|
| 1 | Product scope (A Conjecture-Mine / B Generic cycle / C Echoes-as-a-Service) | **OPEN** |
| 2 | Brand name | **DECIDED — Phanes** |
| 3 | Deployment shape (public demo+paid backend / API-only / full dashboard) | queued (after #1) |
| 4 | GitHub org + remote · private | **DECIDED — dancinlab/phanes (private)** |
| 5 | License (commercial SaaS — not auto-MIT) | queued |
| 6 | Multi-tenant overlay isolation approach (per-job HX data dir vs upstream patch) | queued |

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
TMs, pharma). Clean fallbacks evidenced clean by web search: `Ouro` /
`Kythera` / `Haechi` / `Bythos`. Mitigation: treat Phanes as project
narrative/lore; run formal USPTO class-42 clearance before any public
launch or remote/org push; reconsider public-facing mark then.
(Governance: `AGENTS.tape @D g_name_risk`.)

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

### Decision 1 — Product scope  *(OPEN — next gate)*

Options (assistant recommendation: **A**):

- **A. Conjecture-Mine** — seed → verified discovery catalog (a private
  echoes). Narrowest honest scope; reuses the existing `gate/ hexa://kick`
  remote pipeline most directly; literal "echoes처럼 완성"; smallest
  credible v1; A → C is a natural superset path.
- **B. Generic cycle platform** — pluggable seed+verifier, any measurable
  objective (goal→falsifier→saturation). Largest TAM, largest build,
  highest over-claim risk vs the advisory honesty gate.
- **C. Echoes-as-a-Service** — hosted private *verified-discovery ledger*
  + provenance + Lean/Python re-verification. Audit/compliance angle;
  superset of A.

*Not yet picked — awaiting user.*
