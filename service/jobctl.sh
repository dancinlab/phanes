#!/usr/bin/env bash
# phanes — P1 substrate control (filesystem job store + API-key + tenant)
#
# The P1 substrate is a local CLI over a filesystem job store. The HTTP
# API (service/API.md) is a thin transport added in P1b on top of these
# exact semantics — submit / get / result, API-key auth, per-tenant
# isolation. This keeps P1 a runnable, measured slice without a premature
# server-runtime rabbit hole (echoes-experience thin-slice discipline).
#
# Store layout:
#   $PHANES_STORE/tenants/<tenant>/token              (shared secret)
#   $PHANES_STORE/tenants/<tenant>/jobs/<jobid>/...    (job_runner output)
#
# Usage:
#   jobctl.sh init-tenant   --tenant T                 -> prints token
#   jobctl.sh submit  --tenant T --token K --seed S [--rounds N]
#   jobctl.sh get     --tenant T --token K --job ID
#   jobctl.sh result  --tenant T --token K --job ID
# Exit: 0 ok · 2 bad args · 4 auth fail · 5 not found · else runner rc
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
STORE="${PHANES_STORE:-$HERE/.store}"
CMD="${1:-}"; shift || true
TENANT=""; TOKEN=""; SEED=""; ROUNDS=1; JOB=""
while [ $# -gt 0 ]; do
  case "$1" in
    --tenant) TENANT="${2:-}"; shift 2;;
    --token)  TOKEN="${2:-}";  shift 2;;
    --seed)   SEED="${2:-}";   shift 2;;
    --rounds) ROUNDS="${2:-1}"; shift 2;;
    --job)    JOB="${2:-}";    shift 2;;
    *) echo "jobctl: unknown arg '$1'" >&2; exit 2;;
  esac
done
[ -z "$TENANT" ] && { echo "jobctl: --tenant required" >&2; exit 2; }
TDIR="$STORE/tenants/$TENANT"

auth() {
  [ -f "$TDIR/token" ] || { echo "jobctl: unknown tenant" >&2; exit 4; }
  [ -n "$TOKEN" ] && [ "$TOKEN" = "$(cat "$TDIR/token")" ] || {
    echo "jobctl: auth failed (bad/absent --token)" >&2; exit 4; }
}

case "$CMD" in
  init-tenant)
    mkdir -p "$TDIR/jobs"
    if [ ! -f "$TDIR/token" ]; then
      umask 077
      head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n' > "$TDIR/token"
    fi
    echo "tenant=$TENANT token=$(cat "$TDIR/token")"
    ;;
  submit)
    auth
    JID="job_$(date +%s)_$(head -c6 /dev/urandom | od -An -tx1 | tr -d ' \n')"
    JOBDIR="$TDIR/jobs/$JID"; mkdir -p "$JOBDIR"
    # P2.4: auto-attach per-tenant verifier (sandboxed, post-hoc gate).
    EXTRA_ARGS=()
    if [ -r "$TDIR/verifier.sh" ]; then
      EXTRA_ARGS+=(--verifier "$TDIR/verifier.sh")
    fi
    # P2.x — async-submit pivot (downstream workaround for the
    # logical-only stdlib/net concurrency; see inbox note
    # phanes-stdlib-net-os-thread-concurrency-roadmap-62).
    # Initial status: queued. job_runner transitions to running -> done/failed.
    # Atomic write tmp+rename so concurrent GETs never see a partial file.
    cat > "$JOBDIR/job.json.tmp" <<EOF
{"phanes_job":1,"status":"queued"}
EOF
    mv -f "$JOBDIR/job.json.tmp" "$JOBDIR/job.json"
    # Detached engine spawn — submit returns once jobctl's bookkeeping
    # is durable on disk; the kick runs in an OS-level child process.
    nohup "$HERE/job_runner.sh" --seed "$SEED" --rounds "$ROUNDS" \
      --jobdir "$JOBDIR" "${EXTRA_ARGS[@]}" \
      >> "$JOBDIR/submit.log" 2>&1 < /dev/null &
    disown $! 2>/dev/null || true
    echo "$JID"
    exit 0
    ;;
  get)
    auth
    [ -f "$TDIR/jobs/$JOB/job.json" ] || { echo "jobctl: job not found" >&2; exit 5; }
    cat "$TDIR/jobs/$JOB/job.json"
    ;;
  result)
    auth
    [ -f "$TDIR/jobs/$JOB/job.json" ] || { echo "jobctl: job not found" >&2; exit 5; }
    grep -E '^\{.*"rounds".*\}$' "$TDIR/jobs/$JOB/stdout.txt" | tail -1 || echo "null"
    echo "overlay: $TDIR/jobs/$JOB/overlay.n6"
    ;;
  *)
    echo "jobctl: command required (init-tenant|submit|get|result)" >&2; exit 2;;
esac
