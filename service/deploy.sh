#!/usr/bin/env bash
# service/deploy.sh — ship phanes-http to its host (design.md Decision 14).
#
# Flow:  rsync source -> remote build (service/build.sh) -> swap binary
#        (previous kept) -> restart -> health-check /v1/healthz ->
#        roll back to the previous binary on failure.
#
# Scope (Decision 14, g3): this script covers "given a host exists, ship
# to it." Provisioning the EC2 instance (Decision 11), its key pair, and
# its security group are the user's AWS-account actions, out of scope.
#
# Host prerequisites (one-time, documented — not done by this script):
#   - the upstream hexa toolchain present (so service/build.sh runs);
#     OR set PHANES_DEPLOY_MODE=binary to ship a locally-built binary
#     and skip the remote build entirely.
#   - the phanes-http systemd unit installed (service/phanes-http.service).
#
# Env:
#   PHANES_DEPLOY_HOST   ssh target, e.g. ubuntu@phanes.example.com   (required)
#   PHANES_DEPLOY_PATH   remote repo path                  (default: ~/phanes)
#   PHANES_DEPLOY_PORT   health-check port                 (default: 8787)
#   PHANES_DEPLOY_MODE   "source" (remote build) | "binary" (ship prebuilt)
#                                                          (default: source)
#   PHANES_RESTART_CMD   remote restart command  (default: sudo systemctl
#                                                 restart phanes-http)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PHANES_ROOT="$(cd "$HERE/.." && pwd)"

HOST="${PHANES_DEPLOY_HOST:-}"
RPATH="${PHANES_DEPLOY_PATH:-phanes}"
PORT="${PHANES_DEPLOY_PORT:-8787}"
MODE="${PHANES_DEPLOY_MODE:-source}"
RESTART="${PHANES_RESTART_CMD:-sudo systemctl restart phanes-http}"

[ -n "$HOST" ] || { echo "deploy.sh: PHANES_DEPLOY_HOST is required" >&2; exit 2; }

say() { echo "deploy.sh: $*"; }

# 1. preflight — host reachable
say "preflight — ssh $HOST"
ssh -o BatchMode=yes -o ConnectTimeout=8 "$HOST" "true" \
  || { echo "deploy.sh: cannot ssh to $HOST" >&2; exit 3; }

# 2. rsync source (runtime state + build artifacts + local-only refs excluded)
say "rsync source -> $HOST:$RPATH"
rsync -az --delete \
  --exclude '.git' --exclude 'bin/' --exclude 'build/' \
  --exclude 'service/build/' --exclude '.store/' --exclude 'service/.store/' \
  --exclude 'web/refs/' --exclude '*.log' --exclude '.hx/' --exclude 'state/' \
  "$PHANES_ROOT/" "$HOST:$RPATH/"

# 3. keep the current binary as the rollback point
say "snapshot current binary -> bin/phanes-http.prev"
ssh "$HOST" "cd $RPATH && [ -x bin/phanes-http ] && cp bin/phanes-http bin/phanes-http.prev || true"

# 4. produce the new binary
if [ "$MODE" = "binary" ]; then
  say "mode=binary — shipping locally-built bin/phanes-http"
  [ -x "$PHANES_ROOT/bin/phanes-http" ] \
    || { echo "deploy.sh: no local bin/phanes-http — run service/build.sh first" >&2; exit 3; }
  rsync -az "$PHANES_ROOT/bin/phanes-http" "$HOST:$RPATH/bin/phanes-http"
else
  say "mode=source — remote build via service/build.sh"
  ssh "$HOST" "cd $RPATH && bash service/build.sh" \
    || { echo "deploy.sh: remote build failed — binary unchanged, no restart" >&2; exit 4; }
fi

# 5. restart
say "restart — $RESTART"
ssh "$HOST" "$RESTART" || { echo "deploy.sh: restart command failed" >&2; exit 5; }

# 6. health-check with retries
say "health-check http://$HOST:$PORT/v1/healthz"
ok=0
i=0
while [ "$i" -lt 10 ]; do
  if ssh "$HOST" "curl -fsS -m 4 http://localhost:$PORT/v1/healthz" >/dev/null 2>&1; then
    ok=1; break
  fi
  i=$((i + 1)); sleep 2
done

# 7. rollback on failure
if [ "$ok" -ne 1 ]; then
  echo "deploy.sh: health-check FAILED — rolling back to bin/phanes-http.prev" >&2
  ssh "$HOST" "cd $RPATH && [ -x bin/phanes-http.prev ] && cp bin/phanes-http.prev bin/phanes-http || true; $RESTART" || true
  exit 6
fi

say "deploy OK — phanes-http healthy on $HOST:$PORT"
