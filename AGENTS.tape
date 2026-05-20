#!/usr/bin/env tape
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

@L l1 := "phanes-layout" :: structure [active]
  readme = "README.md — centered-header product overview (dancinlab format)"
  agents = "AGENTS.tape — governance + identity (tape v1.2); CLAUDE.md symlinks here"
  goal = "GOAL.md — one-sentence north-star (scope B) + Log"
  design = "design.md — step-by-step decision-gate log (SSOT — Decisions 1-8 + B-surface CLOSED)"
  roadmap = "ROADMAP.md — phased execution plan (P0 · P1 · P2.1/2/4/x · P3.thin DONE measured · P3.x/P4/P5 next)"
  service = "service/{job_runner.sh,jobctl.sh,http_phanes.hexa,build.sh,API.md,concurrency_test.sh,example_verifier.sh} — P1+P2 substrate (shell+hexa-native HTTP w/ HTMX dashboard routes)"
  web = "web/index.html — vanilla JS+Canvas dev API console (P1b smoke); P3 HTMX dashboard served inline by http_phanes /dashboard route (Decision 8)"
  license = "LICENSE — proprietary, © dancinlab all rights reserved (Decision 5)"
  gitignore = ".gitignore — standard (+ bin/ build/ .store/ runtime artifacts)"

# ─── §3 Governance rules ─────────────────────────────────────────────

@D g_downstream := "downstream of hexa-lang" :: governance [required]
  do   = "`hexa kick` engine 소비 · 한계 발견 시 ~/core/hexa-lang/inbox/patches/<name>.md (one concept = one file)"
  dont = "engine fork · downstream inline workaround"
  @> AGENTS.md

@D g_honest_scope := "honest-scope" :: governance [required deny:write]
  do   = "marketing = atlas-bound discovery + falsification audit · tenant verifier = objective authority"
  dont = "AGI-completion · engine honesty 로 tenant verifier 대체 · saturation 단독 objective-met"
  @> AGENTS.md

@D g_public_demo_constraint := "public demo preset only" :: governance [required d=2026-05-19]
  do   = "public 데모 = preset scenario · round-cap · sandbox"
  dont = "unauth 에 tenant verifier · unbounded seed (arbitrary = dashboard 인증 만)"
  @> AGENTS.md

@D g_name_risk := "Phanes TM risk" :: governance [required d=2026-05-19]
  do   = "Phanes = project lore · pre-launch USPTO clearance (TRADEMARK.md FC-1~6)"
  dont = "public launch w/o FC-5 opinion · Manteia/Mimir/Ouro/Kythera/Haechi 를 clean 가정"
  @> AGENTS.md

@D g_inbox_patches := "gaps → inbox/patches" :: governance [required]
  do   = "hexa-lang/hexa-kick 한계 → ~/core/hexa-lang/inbox/patches/<descriptive>.md"
  dont = "downstream 우회 · 즉석 patch · 한 file 에 multi-concept"
  @> AGENTS.md

@D g_decision_gate := "step-by-step decision gate" :: governance [required]
  do   = "design.md 에 `### Decision N — <picked>` + 3+ rationale bullet 완료 후 다음 decision open"
  dont = "결정 batch · rationale <3 bullet · 다음 decision pre-open"
  @> AGENTS.md

@D g_commit_trailer := "commit-trailer co-author" :: governance [recommended]
  do   = "AI 보조 commit 에 `Co-Authored-By: <model> <noreply@anthropic.com>` trailer 포함"
  dont = "AI 작업 commit 의 trailer 누락"
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
