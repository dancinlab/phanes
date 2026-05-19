#!/usr/bin/env bash
# deploy.sh — ship phanes to Cloudflare Containers (Decision 22 2-tier ·
# 24 queue=REST). Supersedes service/deploy.sh's EC2/systemd path
# (Decision 11/14, kept on record).
#
# What this does (idempotent, re-runnable):
#   1. preflight: npx wrangler present, `secret` CLI present, the prod
#      Cloudflare resources exist (R2 bucket + the `phanes-jobs` queue +
#      scoped tokens were created during the deploy-infra step and live
#      in the `secret` store under r2.phanes.* / cloudflare.queues.*).
#   2. push the runtime secrets to the Worker (NOT committed — public
#      repo) via `wrangler secret put`, sourced from the `secret` CLI.
#   3. `npx wrangler deploy` — Cloudflare builds ./Dockerfile (this is
#      where the linux hexa-bootstrap is first exercised for real) and
#      rolls out PhanesWeb + PhanesWorker (wrangler.jsonc).
#
# Explicitly NOT done here (g3 — by design, user-in-the-loop):
#   - `wrangler login` / CF account auth (interactive; run once first).
#   - DNS cutover of dancinlab.org → the Worker (Decision 20). That is
#     the single irreversible, outward-facing step; do it deliberately
#     in the Cloudflare dashboard / `wrangler` route config after a
#     successful deploy + smoke, never silently from a script.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
WRANGLER=(npx --yes wrangler@latest)

command -v npx >/dev/null   || { echo "deploy: npx (node) required" >&2; exit 3; }
command -v secret >/dev/null|| { echo "deploy: 'secret' CLI required" >&2; exit 3; }

_get() { secret get "$1" 2>/dev/null || true; }
_req() { local v; v="$(_get "$1")"; [ -n "$v" ] || { echo "deploy: missing secret '$1' (deploy-infra step not run?)" >&2; exit 4; }; printf '%s' "$v"; }

echo "deploy: preflight — prod Cloudflare resources"
R2_AK="$(_req r2.phanes.access_key_id)"
R2_SK="$(_req r2.phanes.secret_access_key)"
R2_ACC="$(_req r2.phanes.account_id)"
R2_BK="$(_get r2.phanes.bucket)"; R2_BK="${R2_BK:-phanes}"
Q_ACC="$(_req cloudflare.queues.account_id)"
Q_ID="$(_req cloudflare.queues.id)"
Q_TOK="$(_req cloudflare.queues.token)"
echo "deploy:   R2 bucket=$R2_BK  queue_id=$Q_ID  (account ${R2_ACC:0:8}…)"

echo "deploy: pushing Worker secrets (wrangler secret put)"
_put_secret() { printf '%s' "$2" | "${WRANGLER[@]}" secret put "$1" >/dev/null \
  && echo "deploy:   ✓ $1" || { echo "deploy:   ✗ $1 (wrangler auth? run 'npx wrangler login')" >&2; exit 5; }; }
_put_secret R2_ACCESS_KEY_ID      "$R2_AK"
_put_secret R2_SECRET_ACCESS_KEY  "$R2_SK"
_put_secret R2_ACCOUNT_ID         "$R2_ACC"
_put_secret R2_BUCKET             "$R2_BK"
_put_secret PHANES_Q_ACCOUNT_ID   "$Q_ACC"
_put_secret PHANES_Q_ID           "$Q_ID"
_put_secret PHANES_Q_TOKEN        "$Q_TOK"

echo "deploy: wrangler deploy (Cloudflare builds ./Dockerfile)"
"${WRANGLER[@]}" deploy

echo
echo "deploy: ✓ rolled out. NEXT (manual, deliberate):"
echo "  1. smoke the *.workers.dev URL wrangler printed (GET / and /v1/healthz)"
echo "  2. only then cut DNS: dancinlab.org → this Worker (Decision 20)"
echo "  3. rotate the scoped tokens on a schedule (Decision 21/24 pre-launch)"
