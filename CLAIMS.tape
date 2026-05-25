@V := "tape" :: spec [active]
  version = "1.2"

@I := "claims-index" :: identity [active]
  brief = "Single audit index of verifiable phanes discovery-catalog claims (t_claim_manifest)."
  flow  = "claim → hexa verify (g5) → .verdicts/<slug>/<id>.txt → /paper gate (t_paper_gate)"

# Method legend (t_claim_verify):
#   atom        — `hexa verify <id>` (atlas atom recompute → 🔵)
#   expr        — `hexa verify --expr <fn> <n> <v>` (hexa-native recompute → 🔵/🟢)
#   run         — `hexa kick` DrillResult / job.json capture (empirical OUROBOROS round)
#   measure     — service-layer bench (job_runner wall_ms · concurrency_test) capture
#
# Gate (t_paper_gate): every section claim must be terminal —
#   🔵 formal / 🟢 numerical / 🔴 CLOSED-negative. No 🟠 / 🟡 / ⚪ residual.
# Groups (t_paper_one_per_group): DISCOVERY · OUROBOROS · PLATFORM — one canonical paper each.
# Provenance (t_claim_provenance): each claim links its generating hexa kick round when known.

# ───────────────────────────────────────────────────────────────────────
# DISCOVERY — discovery-perfect-numbers-euclid (slug · group=DISCOVERY · paper-track)
# The /demo curated catalog: hexa kick rediscovers the first three even
# perfect numbers and Euclid's generating form. All section claims are
# 🔵 SUPPORTED-FORMAL (hexa verify --expr, verbatim stdout persisted).
# Provenance = /demo scenarios 01·02·03 (service/http_phanes.hexa render_demo_scenarios).

@C disc_perfect_6 := "6 is perfect: aliquot(6) = 1+2+3 = 6, sigma(6) = 12" :: formula [slug=discovery-perfect-numbers-euclid group=DISCOVERY]
  method = "expr"
  cmd    = "hexa verify --expr is_perfect 6 1 ; hexa verify --expr sigma 6 12"
  raw    = ".verdicts/discovery-perfect-numbers-euclid/perfect_6.txt"
  raw2   = ".verdicts/discovery-perfect-numbers-euclid/sigma_6.txt"
  src    = "/demo scenario 01 (service/http_phanes.hexa render_demo_scenarios)"
  status = "🔵 SUPPORTED-FORMAL — terminal, gate-eligible."

@C disc_perfect_28 := "28 is the next perfect number: 28 = 1+2+4+7+14, sigma(28) = 56" :: formula [slug=discovery-perfect-numbers-euclid group=DISCOVERY]
  method = "expr"
  cmd    = "hexa verify --expr is_perfect 28 1 ; hexa verify --expr sigma 28 56"
  raw    = ".verdicts/discovery-perfect-numbers-euclid/perfect_28.txt"
  raw2   = ".verdicts/discovery-perfect-numbers-euclid/sigma_28.txt"
  src    = "/demo scenario 02 (no-gap scan falsifier over 7..27)"
  status = "🔵 SUPPORTED-FORMAL — terminal, gate-eligible."

@C disc_perfect_496 := "Euclid form p=5: 2^4(2^5-1) = 16*31 = 496 is perfect, aliquot(496) = 496" :: formula [slug=discovery-perfect-numbers-euclid group=DISCOVERY]
  method = "expr"
  cmd    = "hexa verify --expr is_perfect 496 1 ; hexa verify --expr aliquot 496 496"
  raw    = ".verdicts/discovery-perfect-numbers-euclid/perfect_496.txt"
  raw2   = ".verdicts/discovery-perfect-numbers-euclid/aliquot_496.txt"
  src    = "/demo scenario 03 (Euclid 2^(p-1)(2^p-1) form, falsifier instantiates p=5)"
  status = "🔵 SUPPORTED-FORMAL — terminal, gate-eligible. Mersenne prime 2^5-1 = 31."

# ───────────────────────────────────────────────────────────────────────
# OUROBOROS — ouroboros-saturation-stop (slug · group=OUROBOROS · paper-track)
# STRUCTURAL STUB — NOT yet verdict-persisted. Candidate canonical claim:
# the OUROBOROS loop terminates by saturation (no open goal survives its
# own falsifier) rather than by an LLM self-judge. Promote to paper only
# after t_claim_verify captures a real hexa kick DrillResult trail to
# .verdicts/ouroboros-saturation-stop/<id>.txt. DO NOT fabricate a verdict.
#
# @C ouro_saturation_stop := "<claim>" :: run [slug=ouroboros-saturation-stop group=OUROBOROS]
#   method = "run"
#   cmd    = "hexa kick --seed '<seed>' --rounds N   # capture DrillResult JSON"
#   raw    = ".verdicts/ouroboros-saturation-stop/<id>.txt"
#   src    = "service/job_runner.sh DrillResult · ROADMAP P1a–P2"

# ───────────────────────────────────────────────────────────────────────
# PLATFORM — platform-isolation-stub (slug · group=PLATFORM · paper-track)
# STRUCTURAL STUB — NOT yet verdict-persisted. Candidate canonical claim:
# per-job $HOME-jail isolation holds under N-way concurrent load (measured
# at N=4, ROADMAP P2.2). This is a `measure` claim (service bench), NOT a
# `hexa verify` atom — it needs a captured concurrency_test.sh trail with a
# terminal pass/fail framing before it is gate-eligible. DO NOT fabricate.
#
# @C plat_isolation_concurrent := "<claim>" :: measure [slug=platform-isolation-stub group=PLATFORM]
#   method = "measure"
#   cmd    = "service/concurrency_test.sh   # N distinct job ids, per-job overlay.n6"
#   raw    = ".verdicts/platform-isolation-stub/<id>.txt"
#   src    = "ROADMAP P2.2 (isolation HOLDS at N=4) · service/concurrency_test.sh"
