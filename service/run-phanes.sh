#!/usr/bin/env bash
# service/run-phanes.sh — launch phanes-http with AWS credentials fetched
# from the `secret` CLI (design.md Decision 17, the startup-wrapper
# pattern). The repo is public + source-available — credentials never
# live in the tree, only the env-var names and the `secret get` keys do.
#
# `secret` is the user's unified credential CLI (~/.local/bin/secret);
# `secret get <key>` writes the value to stdout with no trailing newline.
#
# Datastore = Cloudflare R2 (Decision 21 — S3-compatible, AWS-SigV4).
# Secret keys, dot-separated per the existing `secret` store convention
# (`cloudflare.email`, `postmark.server_token`, ...):
#   r2.phanes.access_key_id      -> R2_ACCESS_KEY_ID      (required)
#   r2.phanes.secret_access_key  -> R2_SECRET_ACCESS_KEY  (required)
#   r2.phanes.account_id         -> R2_ACCOUNT_ID         (required; the
#                                   R2 endpoint host is
#                                   <account_id>.r2.cloudflarestorage.com)
#   r2.phanes.bucket             -> R2_BUCKET             (optional; default "phanes")
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

# R2 credentials (Decision 21). R2 speaks S3 + AWS SigV4; the
# phanes-http R2 layer reads these env names. account_id determines the
# endpoint host (<account_id>.r2.cloudflarestorage.com).
R2_ACCESS_KEY_ID="$(_get_required r2.phanes.access_key_id)"
R2_SECRET_ACCESS_KEY="$(_get_required r2.phanes.secret_access_key)"
R2_ACCOUNT_ID="$(_get_required r2.phanes.account_id)"
R2_BUCKET="$(_get_optional r2.phanes.bucket)"
R2_BUCKET="${R2_BUCKET:-phanes}"
export R2_ACCESS_KEY_ID R2_SECRET_ACCESS_KEY R2_ACCOUNT_ID R2_BUCKET

# PHANES_HOME so the server resolves /web/static, .store/, jobctl.
export PHANES_HOME="${PHANES_HOME:-$PHANES_ROOT}"

exec "$BIN"
