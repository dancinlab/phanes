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

# PHANES_STORE always needed (poll_to_done reads job.json from it),
# even when caller supplies PHANES_TOKEN directly.
PHANES_STORE="${PHANES_STORE:-$(dirname "$0")/.store}"
if [ -z "$TOK" ]; then
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

echo "=== baseline: 1 sequential submit + poll-to-done (wall_ms) ==="
# Two baselines for honest verdicts under the P2.x async-submit pivot:
#   BASELINE_SUBMIT_MS = time for one submit reply (HTTP-accept layer)
#   BASELINE_KICK_MS   = time for one submit + queued→running→done
#                        (the engine layer; what 4 concurrent kicks
#                         should approach if true OS-level parallel).
poll_to_done() {
  local jid="$1" deadline=10000 t_start
  t_start=$(ms)
  while :; do
    local d="$PHANES_STORE/tenants/$TENANT/jobs/$jid"
    if [ -f "$d/job.json" ]; then
      local st; st=$(grep -Eo '"status":"[a-z]+"' "$d/job.json" 2>/dev/null | head -1 || true)
      case "$st" in '"status":"done"'|'"status":"failed"') return 0 ;; esac
    fi
    local now=$(ms)
    [ "$((now - t_start))" -gt "$deadline" ] && return 1
    sleep 0.05
  done
}
T0=$(ms); JID0=$(submit_one 0); T1=$(ms)
BASELINE_SUBMIT_MS=$((T1 - T0))
poll_to_done "$JID0" || true
T1_DONE=$(ms)
BASELINE_KICK_MS=$((T1_DONE - T0))
BASELINE_MS=$BASELINE_SUBMIT_MS    # back-compat for the existing submit-ratio
echo "  baseline_submit_ms=$BASELINE_SUBMIT_MS  baseline_kick_ms=$BASELINE_KICK_MS  job=$JID0"

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

echo "=== verify all jobs got distinct ids + poll to completion ==="
declare -a JIDS=()
PHANES_STORE="${PHANES_STORE:-$(dirname "$0")/.store}"
for o in "${OUTS[@]}"; do JIDS+=("$(cat "$o")"); done
UNIQ=$(printf '%s\n' "${JIDS[@]}" | sort -u | wc -l | tr -d ' ')
echo "  jobs=${#JIDS[@]} unique=$UNIQ"

# P2.x async-submit: poll job.json until status transitions to done/failed.
# We measure end-to-end completion wall (submits in parallel + kicks in
# parallel) vs baseline (1 sequential submit+kick).
T_DONE_0=$T0  # we count from the same start so completion_ms includes
              # both the submit phase and the parallel kick phase.
deadline_ms=$((TOTAL_MS + 30000))  # generous: TOTAL_MS already elapsed; +30s slack
all_done=0
while [ "$all_done" -eq 0 ]; do
  all_done=1
  for jid in "${JIDS[@]}"; do
    d="$PHANES_STORE/tenants/$TENANT/jobs/$jid"
    if [ -f "$d/job.json" ]; then
      st=$(grep -Eo '"status":"[a-z]+"' "$d/job.json" 2>/dev/null | head -1 || true)
      case "$st" in
        '"status":"done"'|'"status":"failed"') : ;;
        *) all_done=0 ;;
      esac
    else
      all_done=0
    fi
  done
  [ "$all_done" -eq 1 ] && break
  now=$(ms)
  elapsed=$((now - T0))
  if [ "$elapsed" -gt "$deadline_ms" ]; then
    echo "  TIMEOUT after $((elapsed/1000))s — not all jobs reached done"; break
  fi
  sleep 0.1
done
T_DONE_1=$(ms)
COMPLETION_MS=$((T_DONE_1 - T0))
echo "  completion_total_ms=$COMPLETION_MS · expected if serialized ≈ ${N}×baseline=$((N*BASELINE_MS))ms"

ISO_OK=1; STATUSES=()
for jid in "${JIDS[@]}"; do
  d="$PHANES_STORE/tenants/$TENANT/jobs/$jid"
  st=$(grep -Eo '"status":"[a-z]+"' "$d/job.json" 2>/dev/null | head -1 | sed 's/.*:"//;s/"//')
  STATUSES+=("$st")
  if [ ! -f "$d/job.json" ] || [ ! -f "$d/overlay.n6" ]; then
    echo "  FAIL isolation: $jid missing artifacts"; ISO_OK=0
  fi
done
[ "$ISO_OK" -eq 1 ] && echo "  isolation: PASS (every job has its own job.json + overlay.n6)"
echo "  per-job statuses: ${STATUSES[*]}"

echo "=== verdict ==="
SUB_RATIO=$(( TOTAL_MS * 10 / (BASELINE_SUBMIT_MS == 0 ? 1 : BASELINE_SUBMIT_MS) ))
CMP_RATIO=$(( COMPLETION_MS * 10 / (BASELINE_KICK_MS   == 0 ? 1 : BASELINE_KICK_MS) ))
echo "  submit-only ratio     = ${SUB_RATIO}/10  vs baseline_submit_ms=$BASELINE_SUBMIT_MS  (HTTP layer; 1.0=async, ${N}.0=serial)"
echo "  end-to-end ratio      = ${CMP_RATIO}/10  vs baseline_kick_ms=$BASELINE_KICK_MS    (engine layer; 1.0=full parallel, ${N}.0=serial)"
if [ "$CMP_RATIO" -lt 15 ]; then
  echo "  → END-TO-END: NEAR-PARALLEL (kicks overlap on cores; contention < 1.5×)"
elif [ "$CMP_RATIO" -lt $((N * 7)) ]; then
  echo "  → END-TO-END: PARTIAL parallel (engine layer overlaps but with contention)"
else
  echo "  → END-TO-END: serialized (engine layer also blocking — investigate)"
fi
rm -f "${OUTS[@]}"
