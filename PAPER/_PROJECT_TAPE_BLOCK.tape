# MERGE INTO project.tape AFTER: sidecar sign project
#
# Ported from anima a_claim_*/a_paper_* (which ported hexa-codex cx_paper_*).
# Prefix = t_ (matches existing t_downstream_discipline). Groups adapted to
# phanes scope B: DISCOVERY · OUROBOROS · PLATFORM. Paste the block below
# into project.tape AFTER `sidecar sign project` unlocks the agent edit.
# Lint cap: every do=/dont= value string is ≤100 chars (verified).

# ── PAPER auto-generation flow (ported from anima a_paper_* / hexa-codex cx_paper_*) ──
# discovery result → hexa verify → .verdicts/<slug>/<id>.txt → CLAIMS.tape → /paper

@D t_claim_manifest := "CLAIMS.tape — single audit index of verifiable phanes claims" :: workflow [required active]
  do   = "every verifiable claim in root CLAIMS.tape — id · text · method · slug · verdict pointer"
  dont = "scatter claims across docs / job.json without a CLAIMS.tape index — no audit surface"

@D t_claim_verify := "every claim runs through hexa verify, verdict persisted verbatim" :: workflow [required active]
  do   = "each CLAIMS.tape entry → `hexa verify` (g5) → `.verdicts/<slug>/<id>.txt` raw stdout"
  dont = "LLM self-judge correctness (g3) · paraphrase verdicts · hide red / unfenced speculation"

@D t_claim_provenance := "every claim links its generating hexa kick round" :: workflow [required active]
  do   = "claim carries provenance — seed · falsifier · saturation round (DrillResult / /demo scenario)"
  do   = "tenant verifier rc is the sole authority for 'objective met' — never an LLM judgement"
  dont = "claim with no provenance trail · over-claim a result without a tenant verifier PASS"

@D t_paper_gate := "/paper gated on terminal verdict AND significance" :: workflow [required active]
  do   = "`/paper new <slug>` only when every section claim is terminal AND significance satisfied"
  do   = "terminal = 🔵 formal / 🟢 numerical / 🔴 CLOSED-negative — not 🟠 deferred / 🟡 citation"
  dont = "scaffold w/ any 🟠 deferred · 🟡 citation-only · ⚪ unfenced speculation · trivial recheck"

@D t_paper_significance := "paper requires a falsifiable hypothesis + real measurement + a finding" :: workflow [required active]
  do   = "trigger only on pre-registered falsifier + real measurement (hexa kick / verify) + finding"
  do   = "finding = Δ vs baseline OR a closed-negative ruling out an axis"
  dont = "paper for a bookkeeping closure · known identity · unverified prediction · 🟠 residual"

@D t_paper_negative_ok := "closed-negative findings are publishable" :: workflow [required active]
  do   = "a 🔴 FALSIFIED result that deterministically rules out a path is a valid paper"
  do   = "frame as a negative result — the falsifier + the ruled-out space"
  dont = "treat a closed-negative as a non-finding · bury a falsification · publish 🟠 as if closed"

@D t_paper_format := "paper sections — hypothesis · method · measurement · finding" :: workflow [required active]
  do   = "§hypothesis (falsifier) · §method · §measurement (real run) · §finding (Δ OR ruled-out axis)"
  do   = "commons g51 — compile ≥10 pages + ≥1 fal.ai figure"
  dont = "narrative-only · measurement substitute for hypothesis · skip §finding · vague claims"

@D t_paper_sections := "every paper section claim links to its verdict" :: workflow [required active]
  do   = "every section claim links to its `.verdicts/<slug>/<id>.txt` verdict (verbatim stdout)"
  dont = "ship paper with any unresolved residual section · treat the verdict matrix as optional"

@D t_paper_violation := "violating paper immediately revoked" :: workflow [required active]
  do   = "violating paper (gate / significance fail) revoked immediately — PAPER/<slug>/ removed"
  dont = "keep a violating paper as draft · mark WIP · defer revocation · allow a residual"

@D t_paper_one_per_group := "one canonical paper per group — DISCOVERY · OUROBOROS · PLATFORM" :: workflow [required active]
  do   = "one paper per group — DISCOVERY catalog · OUROBOROS loop engine · PLATFORM control/compute"
  do   = "replace in place when a stronger finding lands"
  dont = "multiple papers per group · accumulate a backlog · fork same-group narratives"
