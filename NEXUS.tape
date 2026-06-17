#!/usr/bin/env tape
# NEXUS.tape — phanes cross-repo reuse lattice (SSOT)
# phanes is a hosted OUROBOROS platform; primary substrate = hexa-lang (hexa kick engine).
# Governance: commons @D g67 (intra-project, light) + g68 (cross-repo bidirectional peers).
# Scope: 4 bidirectional cross-repo peers (hexa-lang, anima, demiurge, echoes).
#        Per-tenant private catalog repos are unidirectional consumers (not enumerated here).
#
# Block legend:
#   @I nexus              — identity (kind · scope)
#   @X xr<n> :: cross-repo-peer — a declared cross-repo bidirectional peer (g68)
#   @N n<n> :: note             — usage protocol / scope policy

@V := "tape" :: spec [active]
  version = "1.2"

@I nexus := "phanes cross-repo reuse lattice" :: identity [active]
  kind    = "hosted OUROBOROS platform — hexa kick driver + per-tenant catalog producer"
  scope   = "4 cross-repo bidirectional peers (g68): hexa-lang, anima, demiurge, echoes"
  ssot    = "this file (NEXUS.tape) · README.md project description · ARCHITECTURE.json design SSOT (Decisions 1–24)"
  governs = "commons @D g68 (cross-repo bidirectional peers) + project @D t_downstream_discipline"

# ── 1. cross-repo bidirectional peers (g68) — declared 2026-05-28 ──

@X xr1 := "phanes <-> hexa-lang" :: cross-repo-peer [bidirectional active]
  peer       = "hexa-lang (substrate hub — hexa kick engine)"
  from-hexa  = "hexa kick engine (OUROBOROS loop · 36-lens drill · auto-fold to atlas on verify)"
  to-hexa    = "engine/platform gap patches filed via ~/core/hexa-lang/inbox/patches/ (consume, don't fork)"
  evidence   = "phanes ARCHITECTURE.json (D1/D6 · t_downstream_discipline) · CHANGELOG · hexa-lang NEXUS.tape p_kick + e5"

@X xr2 := "phanes <-> anima" :: cross-repo-peer [bidirectional declared]
  peer       = "anima (HEXAD/* consciousness substrate)"
  evidence   = "user NEXUS scope 2026-05-28 — anima discovery loops are candidate phanes tenant patterns"

@X xr3 := "phanes <-> demiurge" :: cross-repo-peer [bidirectional declared]
  peer       = "demiurge (universal technical-design architecture)"
  evidence   = "user NEXUS scope 2026-05-28 — demiurge-style objectives are candidate phanes tenants"

@X xr4 := "phanes <-> echoes" :: cross-repo-peer [bidirectional declared]
  peer       = "echoes (HEXA-* discoveries catalog · σφτ identity at centre)"
  evidence   = "phanes README — per-tenant catalog positioned as 'their own private echoes'"

# ── 2. notes — downstream discipline + tenant consumer scope ──

@N n1 := "downstream discipline (t_downstream_discipline)" :: note [active]
  rule = "consume hexa kick, do NOT fork the engine. engine/platform gaps go upstream via ~/core/hexa-lang/inbox/patches/."
  ssot = "phanes project.tape @D t_downstream_discipline · CHANGELOG"

@N n2 := "tenant unidirectional consumers (not enumerated)" :: note [active]
  rule = "per-tenant private catalog repos consume phanes (objectives + verifier -> verified catalog) but are NOT enumerated here. phanes does not enumerate its tenants in NEXUS.tape."
  ssot = "phanes README scope-B section · per-tenant isolation contract"

@N n3 := "cross-repo scope policy (g68)" :: note [active]
  rule = "ONLY 4 declared bidirectional peers (hexa-lang, anima, demiurge, echoes). other cross-repo relations are unidirectional and live at the source repo's NEXUS.tape."
  ssot = "hexa-lang NEXUS.tape n2.scope_rule — hub<->peer at hub; peer-mesh at peer."
