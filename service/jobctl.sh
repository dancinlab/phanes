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

# ── B3: tenant token on R2 (Decision 21/23), list-independent slice ──
# The token is the one tenant record jobctl owns. In the Decision 22
# 2-tier split the web container must auth a tenant without local disk,
# so the token moves to R2. We do NOT hand-roll SigV4 in bash (that
# would duplicate stdlib/aws/sigv4.hexa, against @D g_stdlib_ownership);
# instead we call the phanes-http binary's PHANES_R2_OP CLI — the one
# measured signer (r2_*/_kv_*). R2 key: tenants/<tenant>/token.
# Degrades to the filesystem $TDIR/token byte-identically when R2 creds
# are absent, so the verified local contract is unchanged. (jobs/job.json
# stay filesystem here — that is the deeper F-D23-gated B3 remainder.)
PHANES_BIN="${PHANES_BIN:-$HERE/../bin/phanes-http}"
_r2_on() {
  [ -n "${R2_ACCESS_KEY_ID:-}" ] && [ -n "${R2_SECRET_ACCESS_KEY:-}" ] \
    && [ -n "${R2_ACCOUNT_ID:-}" ] && [ -x "$PHANES_BIN" ]
}
_r2op() {  # _r2op <get|put|del> <key> [stdin=body for put]
  PHANES_R2_OP="$1" PHANES_R2_KEY="$2" "$PHANES_BIN"
}
# token I/O — R2 when enabled, else filesystem. Echoes the token (get)
# or returns non-zero when absent; write reads the token from stdin.
_token_key() { echo "tenants/$TENANT/token"; }
_token_get() {
  if _r2_on; then _r2op get "$(_token_key)" 2>/dev/null
  else [ -f "$TDIR/token" ] && cat "$TDIR/token"; fi
}
_token_exists() {
  if _r2_on; then _r2op get "$(_token_key)" >/dev/null 2>&1
  else [ -f "$TDIR/token" ]; fi
}
_token_put() {  # token on stdin
  if _r2_on; then _r2op put "$(_token_key)"
  else umask 077; mkdir -p "$TDIR"; cat > "$TDIR/token"; fi
}
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
  _token_exists || { echo "jobctl: unknown tenant" >&2; exit 4; }
  [ -n "$TOKEN" ] && [ "$TOKEN" = "$(_token_get)" ] || {
    echo "jobctl: auth failed (bad/absent --token)" >&2; exit 4; }
}

case "$CMD" in
  init-tenant)
    mkdir -p "$TDIR/jobs"
    if ! _token_exists; then
      head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n' | _token_put
    fi
    echo "tenant=$TENANT token=$(_token_get)"
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
    # B3: also write the full job spec to R2 so a queue worker (which
    # only receives the {tenant,job_id} pointer, Decision 23) can fetch
    # seed/rounds. Key: tenants/<tenant>/jobs/<JID>/job.json. Best-effort
    # + gated by _r2_on — a failed/disabled R2 write never blocks submit
    # (the local detached spawn below is the path until the worker tier
    # is the sole consumer). seed is JSON-escaped via python3 (already a
    # phanes-substrate dependency, see concurrency_test.sh).
    if _r2_on; then
      SPEC=$(SEED="$SEED" ROUNDS="$ROUNDS" TENANT="$TENANT" python3 -c '
import json,os
print(json.dumps({"phanes_job":1,"status":"queued","tenant":os.environ["TENANT"],
  "seed":os.environ["SEED"],"rounds":int(os.environ["ROUNDS"])}))')
      printf '%s' "$SPEC" | _r2op put "tenants/$TENANT/jobs/$JID/job.json" >/dev/null 2>&1 || true
    fi
    # Detached engine spawn — submit returns once jobctl's bookkeeping
    # is durable on disk; the kick runs in an OS-level child process.
    # `${arr[@]+"${arr[@]}"}` — expand to the elements, or to nothing if
    # the array is empty. A bare `"${EXTRA_ARGS[@]}"` is an "unbound
    # variable" fatal under `set -u` on bash < 4.4 (macOS ships 3.2), so a
    # verifier-less submit aborted before spawning job_runner.
    nohup "$HERE/job_runner.sh" --seed "$SEED" --rounds "$ROUNDS" \
      --jobdir "$JOBDIR" ${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"} \
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
