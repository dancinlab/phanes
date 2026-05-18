#!/usr/bin/env bash
# phanes — P1 job runner (the verified engine-invocation contract)
#
# This script IS the de-risked core of the P1 substrate. It runs one
# `hexa kick` (OUROBOROS) job inside a per-job $HOME-jail sandbox with
# the cycle-h36 arena-aliasing fix, captures the JSON DrillResult + the
# discovery overlay, and meters wall time.
#
# Measured contract (2026-05-19, arm64 macOS, seed sigma(6), rounds=1):
#   rc=0 · wall≈1s · overlay written ONLY inside the jail · real
#   ~/.hx/data untouched · stdout last line = JSON DrillResult.
#
# Isolation = Decision 6 (가) hybrid: per-job $HOME jail. The canonical
# path (upstream HX_DATA_DIR) is filed at hexa-lang
# inbox/patches/phanes-hx-data-dir-per-tenant-isolation; once it lands,
# swap HOME-jail for HX_DATA_DIR and keep the jail as defense-in-depth.
#
# Production note: hexa-lang Axis D forbids Mac-native `hexa kick`; the
# production compute plane runs this on the Linux fleet (P2). This runner
# is host-agnostic; it does not vendor hexa-lang (downstream invariant —
# it invokes the upstream binary).
#
# Usage:
#   job_runner.sh --seed "<>=10 char problem>" [--rounds N] \
#                 [--jobdir DIR] [--engine mk9|mk10]
# Env:
#   PHANES_HEXA_HOME   hexa-lang checkout (default: ~/core/hexa-lang)
#   PHANES_ROUNDS_MAX  hard cap on --rounds (default: 5)
# Exit: 0 ok · 2 bad args / seed reject · 3 engine binary missing
#       · 124 timeout · other = engine rc passthrough
set -euo pipefail

SEED=""; ROUNDS=1; JOBDIR=""; ENGINE="mk9"
HEXA_HOME="${PHANES_HEXA_HOME:-$HOME/core/hexa-lang}"
ROUNDS_MAX="${PHANES_ROUNDS_MAX:-5}"
TIMEOUT_SEC="${PHANES_TIMEOUT_SEC:-1800}"

while [ $# -gt 0 ]; do
  case "$1" in
    --seed)   SEED="${2:-}"; shift 2;;
    --rounds) ROUNDS="${2:-1}"; shift 2;;
    --jobdir) JOBDIR="${2:-}"; shift 2;;
    --engine) ENGINE="${2:-mk9}"; shift 2;;
    *) echo "phanes job_runner: unknown arg '$1'" >&2; exit 2;;
  esac
done

# --- seed pre-validation (engine's _validate_seed is authoritative;
#     this is a cheap fail-fast mirror) ---
SEED_TRIM="$(printf '%s' "$SEED" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [ "${#SEED_TRIM}" -lt 10 ]; then
  echo "phanes job_runner: --seed rejected (need a substantive problem statement, >=10 chars)" >&2
  exit 2
fi

# --- clamp rounds to the hard cap (metering / abuse guard) ---
case "$ROUNDS" in (*[!0-9]*|"") ROUNDS=1;; esac
[ "$ROUNDS" -lt 1 ] && ROUNDS=1
[ "$ROUNDS" -gt "$ROUNDS_MAX" ] && ROUNDS="$ROUNDS_MAX"

# --- resolve engine binary (downstream: invoke upstream, never vendor) ---
KICK="$HEXA_HOME/bin/hexa-absorbed-kick"
if [ ! -x "$KICK" ]; then
  echo "phanes job_runner: engine binary not found/executable: $KICK" >&2
  echo "  (set PHANES_HEXA_HOME to a hexa-lang checkout with bin/hexa-absorbed-kick)" >&2
  exit 3
fi

# --- per-job $HOME-jail sandbox (Decision 6 가) ---
if [ -z "$JOBDIR" ]; then JOBDIR="$(mktemp -d "${TMPDIR:-/tmp}/phanes_job.XXXXXX")"; fi
JAIL="$JOBDIR/jail"
mkdir -p "$JAIL/.hx/data"

# --- run: HOME-jail + cycle-h36 arena fix + wall meter ---
T0=$(date +%s)
set +e
HOME="$JAIL" HEXA_VAL_ARENA=0 timeout "$TIMEOUT_SEC" \
  "$KICK" --seed "$SEED_TRIM" --rounds "$ROUNDS" --engine "$ENGINE" \
  > "$JOBDIR/stdout.txt" 2> "$JOBDIR/stderr.txt"
RC=$?
set -e
T1=$(date +%s); WALL=$((T1 - T0))

# --- capture artifacts: JSON DrillResult (stdout last JSON line) +
#     the discovery overlay (the only persistent artifact; checkpoint is
#     cleared by the engine on normal exit) ---
RESULT_JSON="$(grep -E '^\{.*"rounds".*\}$' "$JOBDIR/stdout.txt" | tail -1 || true)"
[ -f "$JAIL/.hx/data/atlas.overlay.n6" ] && cp "$JAIL/.hx/data/atlas.overlay.n6" "$JOBDIR/overlay.n6" || true
OVERLAY_LINES=$( [ -f "$JOBDIR/overlay.n6" ] && wc -l < "$JOBDIR/overlay.n6" | tr -d ' ' || echo 0 )

# --- job manifest (machine-readable; phanes API serves this) ---
cat > "$JOBDIR/job.json" <<EOF
{"phanes_job":1,"rc":$RC,"wall_sec":$WALL,"rounds":$ROUNDS,"engine":"$ENGINE",
 "overlay_lines":$OVERLAY_LINES,"result":${RESULT_JSON:-null},
 "artifacts":{"stdout":"stdout.txt","stderr":"stderr.txt","overlay":"overlay.n6","result":"job.json"}}
EOF

echo "$JOBDIR"
exit "$RC"
