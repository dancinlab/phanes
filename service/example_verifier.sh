#!/usr/bin/env bash
# phanes — example tenant verifier (illustrative; tenants write their own)
#
# Sandbox contract (P2.4): job_runner.sh execs this as
#     env -i HOME=<sandbox> PATH=/usr/bin:/bin \
#       timeout <VERIFIER_TIMEOUT_SEC> bash <this> <JOBDIR>
# `$1` (JOBDIR) contains: stdout.txt · stderr.txt · overlay.n6 · job.json
# Under scope B the tenant verifier is the sole authority for "objective
# met" (`@D g_honest_scope.scope_b`). Exit 0 = PASS, anything else = FAIL.
#
# Example policy: PASS if drill produced >= 100 total absorptions.
set -euo pipefail
JOBDIR="${1:?usage: example_verifier.sh <JOBDIR>}"
RESULT="$JOBDIR/stdout.txt"
[ -r "$RESULT" ] || { echo "verifier: no stdout.txt"; exit 2; }
TOTAL=$(grep -Eo '"total":[0-9]+' "$RESULT" | head -1 | sed 's/.*://' || echo 0)
THRESHOLD="${PHANES_VERIFIER_THRESHOLD:-100}"
if [ -z "$TOTAL" ] || [ "$TOTAL" -lt "$THRESHOLD" ]; then
  echo "verifier: FAIL — total=$TOTAL < threshold=$THRESHOLD"; exit 1
fi
echo "verifier: PASS — total=$TOTAL >= threshold=$THRESHOLD"
