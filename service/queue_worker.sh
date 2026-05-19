#!/usr/bin/env bash
# phanes — B3 queue worker (Decision 22 worker tier · Decision 24 REST).
#
# The consumer mirror of http_phanes.hexa::q_send. Pulls the
# {tenant,job_id} pointer from the Cloudflare Queue over the REST API
# (no Worker sidecar — Decision 24), fetches the full job spec from R2
# (Decision 23: the queue carries a pointer, the data is in R2), runs
# one `hexa kick` via job_runner.sh, writes the terminal status back to
# R2, then acks the message lease so it is not redelivered. CF Queues
# at-least-once + the visibility-timeout lease + kick's per-job_id
# idempotence (re-running overwrites the same R2 keys) make a
# redelivered message safe (Decision 23 rationale).
#
# This is the worker that the Decision 22 Cloudflare Container ×N pool
# runs. It is host-agnostic and does not vendor hexa-lang (downstream
# invariant) — it shells the upstream engine via job_runner.sh and the
# R2 ops via the phanes-http PHANES_R2_OP CLI (one signer SSOT).
#
# Env (same names run-phanes.sh exports from `secret`):
#   PHANES_Q_ACCOUNT_ID · PHANES_Q_ID · PHANES_Q_TOKEN  (CF Queue REST)
#   R2_ACCESS_KEY_ID · R2_SECRET_ACCESS_KEY · R2_ACCOUNT_ID [· R2_BUCKET]
#   PHANES_BIN        (default <here>/../bin/phanes-http)
#   PHANES_Q_BATCH    (pull batch size, default 5)
#   PHANES_Q_VIS_MS   (visibility timeout ms, default 300000 = 5 min;
#                      MUST exceed max job wall — F-D22/containers#162)
#   PHANES_Q_POLL_SEC (idle sleep between empty pulls, default 5)
# Usage:
#   queue_worker.sh --once     # one pull batch then exit (CI / probe)
#   queue_worker.sh            # poll loop (the container entrypoint)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PHANES_BIN="${PHANES_BIN:-$HERE/../bin/phanes-http}"
ACC="${PHANES_Q_ACCOUNT_ID:-}"; QID="${PHANES_Q_ID:-}"; QTOK="${PHANES_Q_TOKEN:-}"
BATCH="${PHANES_Q_BATCH:-5}"; VIS="${PHANES_Q_VIS_MS:-300000}"
POLL="${PHANES_Q_POLL_SEC:-5}"
ONCE=0; [ "${1:-}" = "--once" ] && ONCE=1

[ -n "$ACC" ] && [ -n "$QID" ] && [ -n "$QTOK" ] || {
  echo "queue_worker: PHANES_Q_{ACCOUNT_ID,ID,TOKEN} required" >&2; exit 2; }
[ -x "$PHANES_BIN" ] || {
  echo "queue_worker: phanes-http binary missing ($PHANES_BIN)" >&2; exit 3; }

QBASE="https://api.cloudflare.com/client/v4/accounts/$ACC/queues/$QID"
QH=(-H "Authorization: Bearer $QTOK" -H "Content-Type: application/json")

_r2_get() { PHANES_R2_OP=get PHANES_R2_KEY="$1" "$PHANES_BIN"; }
_r2_put() { PHANES_R2_OP=put PHANES_R2_KEY="$1" "$PHANES_BIN"; }

# Process one pulled message: {tenant,job_id} -> R2 spec -> kick ->
# R2 terminal status. Echoes the lease_id to ack on success (empty on
# a hard failure so the message is left for redelivery).
_handle() {  # $1=tenant $2=job_id $3=lease_id
  local tenant="$1" jid="$2" lease="$3" key spec seed rounds jobdir rc
  key="tenants/$tenant/jobs/$jid/job.json"
  spec="$(_r2_get "$key" 2>/dev/null || true)"
  if [ -z "$spec" ]; then
    echo "queue_worker: no R2 spec for $key — leaving for redelivery" >&2
    return 0   # no lease echoed -> not acked
  fi
  seed="$(SPEC="$spec" python3 -c 'import json,os;print(json.loads(os.environ["SPEC"])["seed"])')"
  rounds="$(SPEC="$spec" python3 -c 'import json,os;print(json.loads(os.environ["SPEC"]).get("rounds",1))')"
  jobdir="$(mktemp -d "/tmp/phanes_qw_${jid}_XXXX")"
  set +e
  "$HERE/job_runner.sh" --seed "$seed" --rounds "$rounds" --jobdir "$jobdir" \
    >>"$jobdir/qw.log" 2>&1
  rc=$?
  set -e
  local status="done"; [ "$rc" -eq 0 ] || status="failed"
  # terminal status back to R2 (best-effort; overlay copy is the deeper
  # remainder — the spec→status transition is the closure-measured part)
  local result; result="$(SPEC="$spec" ST="$status" RC="$rc" python3 -c '
import json,os
s=json.loads(os.environ["SPEC"]); s["status"]=os.environ["ST"]; s["rc"]=int(os.environ["RC"])
print(json.dumps(s))')"
  printf '%s' "$result" | _r2_put "$key" >/dev/null 2>&1 || true
  rm -rf "$jobdir"
  echo "$lease"   # ack this message
}

_drain_once() {
  local pull acks n
  pull="$(curl -sS -X POST "${QH[@]}" "$QBASE/messages/pull" \
    --data "{\"batch_size\":$BATCH,\"visibility_timeout_ms\":$VIS}")"
  n="$(PULL="$pull" python3 -c 'import json,os;print(len(json.loads(os.environ["PULL"])["result"]["messages"]))')"
  [ "$n" -eq 0 ] && { echo 0; return 0; }
  acks="[]"
  local i=0
  while [ "$i" -lt "$n" ]; do
    local row tenant jid lease leaseout
    row="$(PULL="$pull" IDX="$i" python3 -c '
import json,os
m=json.loads(os.environ["PULL"])["result"]["messages"][int(os.environ["IDX"])]
b=m["body"]
b=b if isinstance(b,dict) else json.loads(b)
print(b.get("tenant","")+"\t"+b.get("job_id","")+"\t"+m["lease_id"])')"
    tenant="$(printf '%s' "$row" | cut -f1)"
    jid="$(printf '%s' "$row" | cut -f2)"
    lease="$(printf '%s' "$row" | cut -f3)"
    leaseout="$(_handle "$tenant" "$jid" "$lease" || true)"
    if [ -n "$leaseout" ]; then
      acks="$(ACKS="$acks" L="$leaseout" python3 -c '
import json,os
a=json.loads(os.environ["ACKS"]); a.append({"lease_id":os.environ["L"]}); print(json.dumps(a))')"
    fi
    i=$((i + 1))
  done
  # ack all successfully-processed leases in one call
  if [ "$acks" != "[]" ]; then
    curl -sS -X POST "${QH[@]}" "$QBASE/messages/ack" \
      --data "{\"acks\":$acks}" >/dev/null 2>&1 || true
  fi
  echo "$n"
}

if [ "$ONCE" -eq 1 ]; then
  got="$(_drain_once)"; echo "queue_worker: drained $got message(s)"; exit 0
fi
echo "queue_worker: poll loop (batch=$BATCH vis=${VIS}ms poll=${POLL}s)"
while true; do
  got="$(_drain_once || echo 0)"
  [ "$got" -eq 0 ] && sleep "$POLL"
done
