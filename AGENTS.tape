#!/usr/bin/env tape
# ══════════════════════════════════════════════════════════════════════
# .tape v1.2 — grammar primer (cold-read by any LLM / agent / human)
# ══════════════════════════════════════════════════════════════════════
# Form: each entry is `@<type> <id> := "<subject>" :: <kind> [<grades>]`
#       optionally followed by body lines (2-space indent) — key=value,
#       edges (<- -> => …), or quoted prose.
#
# ENTRY TYPES (17):
#   Runtime (10): @S session  @U user  @A assistant  @T tool-call  @R result
#                 @H hook  @D decision  @K cost  @P provider  @? anomaly
#   Foundation:   @I identity-claim
#   Declarative:  @X external-citation  @F forbidden-pattern  @N note
#                 @C config  @L layout  @V spec-version
#
# Full spec: ~/core/tape/spec/tape.md (or github.com/dancinlab/tape)
# ══════════════════════════════════════════════════════════════════════
#
# AGENTS.tape for `phanes` — SaaS web product wrapping the hexa-lang
# OUROBOROS discovery engine (`hexa kick`). DOWNSTREAM of hexa-lang.

@V := "tape" :: spec [active]
  version = "1.2"

# ─── §1 Identity ─────────────────────────────────────────────────────

@I id001 := "phanes" :: identity-claim [d=2026-05-19 active]
  kind = "SaaS web product — hosted autonomous discovery (hexa kick / OUROBOROS) for companies"
  brief = "seed → autonomous OUROBOROS discovery loop → verified, provenance-tracked discovery catalog (a private echoes)"
  parent = "dancinlab"
  signature = "🥚 the cosmic egg cracks — hidden truth brought to light, wrapped by the self-feeding serpent"
  lore = "Phanes (Φάνης, φαίνω 'to bring to light') — Orphic primordial deity of revelation, depicted entwined by the OUROBOROS. Ouro = the serpent (engine codename); Phanes = the light it reveals. Brand-token trademark risk acknowledged — see @D g_name_risk."
  upstream = "hexa-lang (`hexa kick` = compiler/drill/drill.hexa OUROBOROS engine, cycle h36 COMPLETE)"

@I id002 := "phanes.downstream-position" :: identity-claim [d=2026-05-19 active]
  <: id001
  rule = "phanes is a DOWNSTREAM consumer of hexa-lang — it consumes `hexa kick`; nothing in hexa-lang imports from phanes."
  apply = "when phanes hits a hexa-lang gap (engine / multi-tenant / API), the patch goes to ~/core/hexa-lang/inbox/patches/<name>.md, never inline-patched from here."

# ─── §2 Repo layout ──────────────────────────────────────────────────

@L l1 := "phanes-layout" :: structure [draft]
  readme = "README.md — centered-header product overview (dancinlab format)"
  agents = "AGENTS.tape — governance + identity (tape v1.2); CLAUDE.md symlinks here"
  goal = "GOAL.md — one-sentence north-star · scope OPEN until Decision 1"
  design = "design.md — step-by-step decision-gate log (SSOT for product decisions)"
  gitignore = ".gitignore — standard"

# ─── §3 Governance rules ─────────────────────────────────────────────

@D g_downstream := "downstream-of-hexa-lang" :: governance [required]
  rule = "phanes consumes hexa-lang's `hexa kick` engine. No fork of the engine here; gaps go upstream via inbox/patches."
  authority = "hexa-lang AGENTS.tape @I id002 · @D g7 · [@x_hexa_agents]"
  @> AGENTS.md

@D g_honest_scope := "honest-scope — no over-claim" :: governance [required deny:write]
  rule = "phanes markets what `hexa kick` actually produces: verified, atlas-bound mathematical/algorithmic DISCOVERIES with a per-round honesty (falsification) audit trail. NOT 'autonomously completes your software project'."
  why = "the OUROBOROS honesty gate is advisory (non-blocking); saturation is the only hard stop. Selling AGI-completion = over-claim. hexa-lang g3 real-limits-first applies downstream."
  scope_b = "Under Decision 1 = B (generic cycle platform): the tenant-supplied verifier/oracle is the SOLE authority for 'objective met'. phanes surfaces saturation + the tenant verifier's verdict; it never substitutes the engine's advisory honesty gate for the tenant verifier's PASS, nor claims objective-met without it."
  authority = "hexa-lang LATTICE_POLICY.md · [@x_lattice_policy]"
  @> AGENTS.md

@D g_public_demo_constraint := "public demo = preset verifiers only" :: governance [required deny:write d=2026-05-19 active]
  rule = "The public demo site (Decision 3 = 가) runs ONLY preset, curated objective+verifier scenarios — round-capped and sandboxed. It MUST NOT accept arbitrary tenant-supplied verifiers or unbounded seeds."
  why = "Under scope B an arbitrary verifier on an unauthenticated surface = over-claim risk + arbitrary-compute/abuse hole. Arbitrary verifier submission is authenticated/paid-only via the dashboard (Decision 3 = 다)."
  authority = "design.md Decision 3 · g_honest_scope.scope_b · hexa-lang g3 [@x_lattice_policy]"
  @> AGENTS.md

@D g_name_risk := "brand-token trademark risk acknowledged" :: governance [required d=2026-05-19 active]
  rule = "The token 'Phanes' has adjacent collisions — Phanes Technologies (autonomous multi-agent AI) + Phanes Therapeutics (USPTO-registered TMs). User chose Phanes with this on record (2026-05-19)."
  remedy = "Treat Phanes as project narrative/lore; before any public launch or remote/org push, run a formal USPTO/class-42 clearance and reconsider the public-facing mark (clean fallback on record: Ouro / Kythera / Haechi)."
  authority = "user directive 2026-05-19 '파네스 go' (override of assistant ownability caveat, logged in design.md Decision 2)"
  @> AGENTS.md

@D g_inbox_patches := "gaps go upstream via inbox/patches" :: governance [required]
  rule = "Any hexa-lang / hexa-kick limitation phanes hits is filed at ~/core/hexa-lang/inbox/patches/<descriptive>.md (one concept per file), never worked around downstream."
  authority = "hexa-lang @D g7 inbox-patches-pipeline"
  @> AGENTS.md

@D g_decision_gate := "step-by-step decision gate" :: governance [required]
  rule = "Product is built one decision at a time, never batched. Each lands in design.md as `### Decision N — <picked>` with picked + 3+ rationale bullets before the next is opened."
  status = "DECIDED: 1 = B Generic cycle platform · 2 = name Phanes · 3 = deployment 가+다 · 4 = dancinlab/phanes private remote · 6 = multi-tenant isolation 다 hybrid. Upstream handoffs FILED (hexa-lang inbox/patches): phanes-hx-data-dir-per-tenant-isolation + phanes-pluggable-verifier-oracle-for-drill-loop. NEXT GATE: Decision 5 (license)."
  @> AGENTS.md

@D g_commit_trailer := "commit-trailer co-author" :: governance [recommended]
  rule = "AI-assisted commits include: Co-Authored-By: <model> <noreply@anthropic.com>"
  @> AGENTS.md

# ─── §5 External citations ───────────────────────────────────────────

@X x_hexa_agents := "hexa-lang AGENTS.tape" :: spec [active]
  url = "https://github.com/dancinlab/hexa-lang/blob/main/AGENTS.tape"
  scope = "upstream identity + g7 inbox-patches + downstream invariant"

@X x_lattice_policy := "hexa-lang LATTICE_POLICY.md" :: policy [active]
  url = "https://github.com/dancinlab/hexa-lang/blob/main/LATTICE_POLICY.md"
  scope = "real-limits-first · over-claim forbidden — applies to phanes marketing"

@X x_hexa_kick := "hexa kick / OUROBOROS engine" :: spec [d=2026-05-19 active]
  source = "hexa-lang compiler/drill/drill.hexa · compiler/PLAN.md §'hexa kick COMPLETE — cycle h36'"
  scope = "seed → 6-stage chain (smash→free→absolute→meta→hyper→resonance) × rounds → saturation; per-round honesty gate; JSON DrillResult; overlay catalog. Proto-SaaS surface already exists: gate/ hexa://kick?topic= remote dispatch."

# ─── §6 Notes ────────────────────────────────────────────────────────

@N n_scope := "product scope = B (decided)" :: note [d=2026-05-19 active]
  text = "Decision 1 DECIDED = B Generic cycle platform (user directive 2026-05-19, over assistant rec A). README/GOAL concretized for B. B's new engine surface = a pluggable seed+verifier/oracle abstraction over hexa kick — an upstream hexa-lang inbox/patches candidate, NOT a downstream fork. tenant verifier = sole authority for 'objective met' (see g_honest_scope.scope_b). See design.md Decision 1."

@N n_ouro_phanes := "Ouro ⊂ Phanes lore" :: note [active]
  text = "Engine codename in hexa-lang = OUROBOROS (the self-feeding serpent: discoveries reseed the next round to saturation). In Orphic myth Phanes is the radiant first-born the OUROBOROS entwines. So Ouro = mechanism, Phanes = the truth it brings to light — one image, inside and out."
