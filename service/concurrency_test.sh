#!/usr/bin/env bash
# phanes — P2.2 concurrency measurement
#
# Fires N concurrent HTTP submits at a running phanes-http and measures:
#   (a) parallel speedup vs N×single-job baseline → reveals whether the
#       service-layer serialization (the current sequential accept-loop in
#       stdlib/net/http_server.hexa) is the bottleneck;
#   (b) per-job artifact isolation (each job has its own DrillResult +
#       overlay, no cross-contamination) — even if exec is serialized at
#       the HTTP layer, the per-job $HOME-jail isolation must hold.
#
# Honest scope: this is a measurement script, not a fix. The path to true
# parallelism is to port http_phanes.hexa to stdlib/net/concurrent_serve
# (ConcurrentServer + register_endpoint + run(workers)) — recorded as a
# P2.x follow-up, not done here.
set -euo pipefail

ROOT="${PHANES_ENDPOINT:-http://127.0.0.1:8788}"
TENANT="${PHANES_TENANT:-demo}"
TOK="${PHANES_TOKEN:-}"
N="${1:-4}"
SEED='prove sigma(6)=12 perfect-number divisor structure'

if [ -z "$TOK" ]; then
  PHANES_STORE="${PHANES_STORE:-$(dirname "$0")/.store}"
  TOK="$(cat "$PHANES_STORE/tenants/$TENANT/token" 2>/dev/null || true)"
fi
[ -n "$TOK" ] || { echo "concurrency_test: token missing (set PHANES_TOKEN or init demo tenant)"; exit 2; }

# perl-based ms clock (matches job_runner.sh)
ms() { perl -MTime::HiRes=time -e 'printf "%d\n", time()*1000'; }

submit_one() {
  local i="$1"
  local out
  out=$(curl -s \
    -H "X-Phanes-Tenant: $TENANT" \
    -H "Authorization: Bearer $TOK" \
    -H "Content-Type: application/json" \
    --data-binary "{\"seed\":\"$SEED\",\"rounds\":1}" \
    "$ROOT/v1/jobs")
  echo "$out" | python3 -c "import json,sys;print(json.loads(sys.stdin.read())['job_id'])"
}

echo "=== baseline: 1 sequential submit (wall_ms) ==="
T0=$(ms); JID0=$(submit_one 0); T1=$(ms)
BASELINE_MS=$((T1 - T0))
echo "  baseline_ms=$BASELINE_MS  job=$JID0"

echo "=== fire $N concurrent submits ==="
PIDS=(); OUTS=()
T0=$(ms)
for i in $(seq 1 "$N"); do
  out=$(mktemp /tmp/phanes_conc.$i.XXXX)
  ( submit_one "$i" > "$out" 2>&1 ) &
  PIDS+=($!); OUTS+=("$out")
done
for p in "${PIDS[@]}"; do wait "$p"; done
T1=$(ms)
TOTAL_MS=$((T1 - T0))
echo "  concurrent total_ms=$TOTAL_MS · expected if serialized ≈ ${N}×baseline=$((N*BASELINE_MS))ms"

echo "=== verify all jobs got distinct ids + isolated artifacts ==="
declare -a JIDS=()
PHANES_STORE="${PHANES_STORE:-$(dirname "$0")/.store}"
for o in "${OUTS[@]}"; do JIDS+=("$(cat "$o")"); done
UNIQ=$(printf '%s\n' "${JIDS[@]}" | sort -u | wc -l | tr -d ' ')
echo "  jobs=${#JIDS[@]} unique=$UNIQ"
ISO_OK=1
for jid in "${JIDS[@]}"; do
  d="$PHANES_STORE/tenants/$TENANT/jobs/$jid"
  if [ ! -f "$d/job.json" ] || [ ! -f "$d/overlay.n6" ]; then
    echo "  FAIL isolation: $jid missing artifacts"; ISO_OK=0
  fi
done
[ "$ISO_OK" -eq 1 ] && echo "  isolation: PASS (every job has its own job.json + overlay.n6)"

echo "=== verdict ==="
RATIO_X10=$(( TOTAL_MS * 10 / (BASELINE_MS == 0 ? 1 : BASELINE_MS) ))
echo "  concurrent/baseline ratio = ${RATIO_X10}/10 (1.0 = perfect parallel, ${N}.0 = fully serialized)"
if [ "$RATIO_X10" -lt $((N * 7)) ]; then
  echo "  → SOME parallelism present (better than worst-case serialization)"
else
  echo "  → fully serialized (expected: single-threaded accept-loop in stdlib/net/http_server.hexa)"
fi
rm -f "${OUTS[@]}"
