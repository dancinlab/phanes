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
