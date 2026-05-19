#!/usr/bin/env bash
# service/run-phanes.sh — launch phanes-http with AWS credentials fetched
# from the `secret` CLI (design.md Decision 17, the startup-wrapper
# pattern). The repo is public + source-available — credentials never
# live in the tree, only the env-var names and the `secret get` keys do.
#
# `secret` is the user's unified credential CLI (~/.local/bin/secret);
# `secret get <key>` writes the value to stdout with no trailing newline.
#
# Secret keys read here (set with `secret set <key>` before first run):
#   aws/phanes/access_key_id      -> AWS_ACCESS_KEY_ID         (required)
#   aws/phanes/secret_access_key  -> AWS_SECRET_ACCESS_KEY     (required)
#   aws/phanes/region             -> AWS_REGION                (optional; default us-east-1)
#   aws/phanes/session_token      -> AWS_SESSION_TOKEN         (optional; STS only)
#
# Usage:  bash service/run-phanes.sh
#         (PHANES_BIND_HOST / PHANES_BIND_PORT honored by phanes-http itself.)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PHANES_ROOT="$(cd "$HERE/.." && pwd)"
BIN="$PHANES_ROOT/bin/phanes-http"

[ -x "$BIN" ] || { echo "run-phanes.sh: bin/phanes-http missing — build first (service/build.sh)" >&2; exit 3; }

if ! command -v secret >/dev/null 2>&1; then
  echo "run-phanes.sh: 'secret' CLI not on PATH (expected at ~/.local/bin/secret)" >&2
  exit 3
fi

# Fetch a required secret or fail clean with the missing-key hint.
_get_required() {
  local key="$1" v
  if ! v="$(secret get "$key" 2>/dev/null)" || [ -z "$v" ]; then
    echo "run-phanes.sh: missing required secret '$key' (run: secret set $key)" >&2
    exit 4
  fi
  printf '%s' "$v"
}

# Fetch an optional secret; empty string on absence (no error).
_get_optional() {
  secret get "$1" 2>/dev/null || true
}

# AWS credentials — standard SDK env-var names so phanes-http stays
# generic-AWS-conventional and is not coupled to the secret tool.
AWS_ACCESS_KEY_ID="$(_get_required aws/phanes/access_key_id)"
AWS_SECRET_ACCESS_KEY="$(_get_required aws/phanes/secret_access_key)"
REGION="$(_get_optional aws/phanes/region)"
AWS_REGION="${REGION:-us-east-1}"
SESSION="$(_get_optional aws/phanes/session_token)"
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION
[ -n "$SESSION" ] && export AWS_SESSION_TOKEN="$SESSION"

# PHANES_HOME so the server resolves /web/static, .store/, jobctl.
export PHANES_HOME="${PHANES_HOME:-$PHANES_ROOT}"

exec "$BIN"
