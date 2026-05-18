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

## All product gates closed (2026-05-19)

Decisions 1–6 + B-surface upstream handoff resolved. Remaining work is
**execution**, tracked in `ROADMAP.md` (phased, echoes-experience thin-
slice discipline). Pre-public-launch obligations on record: trademark
clearance (`@D g_name_risk`), upstream patches landing
(`HX_DATA_DIR` + pluggable verifier), honest-scope marketing review
(`@D g_honest_scope` · `@D g_public_demo_constraint`).
