#!/usr/bin/env bash
# cutover-domain.sh — the SINGLE deliberate, irreversible step:
# bind dancinlab.org (Decision 20) to the deployed `phanes` Worker as a
# Cloudflare Workers Custom Domain.
#
# Run this ONLY after:  npx wrangler login → bash deploy.sh → smoke the
# *.workers.dev URL (GET / and /v1/healthz both 200). Until then the
# domain has NO web target and this would point it at nothing.
#
# Why a separate script (not in deploy.sh): deploy is re-runnable and
# safe; this changes a real public domain. Keeping it one explicit
# command with a typed confirmation makes the irreversible step
# deliberate (governance: outward-facing/hard-to-reverse → confirm).
#
# Measured pre-state (2026-05-19, read-only): dancinlab.org is an ACTIVE
# zone on this Cloudflare account (zone 6c41a072…); its 8 DNS records
# are ALL mail (Postmark CNAME, CF Email-Routing MX, DKIM/SPF/DMARC) —
# there is NO root/www A/AAAA/CNAME. So a Workers Custom Domain here is
# purely ADDITIVE: it creates the proxied record for the apex, leaves
# every mail record untouched. Clean, low-risk, but still public.
set -euo pipefail

ZONE="dancinlab.org"
HOST="${1:-dancinlab.org}"          # or: bash cutover-domain.sh www.dancinlab.org
WORKER="${PHANES_WORKER_NAME:-phanes}"
WRANGLER=(npx --yes wrangler@latest)

command -v npx >/dev/null || { echo "cutover: npx (node) required" >&2; exit 3; }

cat >&2 <<EOF
cutover-domain.sh — IRREVERSIBLE PUBLIC CHANGE
  zone   : $ZONE
  host   : $HOST   →  Worker '$WORKER'  (Workers Custom Domain, proxied)
  effect : creates/repoints the apex web record to the Worker. Mail
           records (MX/SPF/DKIM/DMARC) are NOT touched.
  do this only after a green *.workers.dev smoke.
EOF
printf 'Type exactly "cutover %s" to proceed: ' "$HOST" >&2
read -r CONFIRM
[ "$CONFIRM" = "cutover $HOST" ] || { echo "cutover: aborted (no match)" >&2; exit 1; }

# Workers Custom Domain via wrangler: declarative attach. (Equivalent
# dashboard path: Workers & Pages → phanes → Settings → Domains &
# Routes → Add Custom Domain → $HOST.) wrangler manages the proxied
# DNS record automatically — no manual A/CNAME editing, mail untouched.
"${WRANGLER[@]}" deployments domains add "$HOST" --name "$WORKER" 2>/dev/null \
  || "${WRANGLER[@]}" custom-domains add "$HOST" --name "$WORKER" \
  || {
    echo "cutover: wrangler subcommand name differs by version. Do it in the" >&2
    echo "  dashboard: Workers & Pages → $WORKER → Settings → Domains & Routes" >&2
    echo "  → Add Custom Domain → $HOST  (one click; wrangler auth may also" >&2
    echo "  just need: npx wrangler login)" >&2
    exit 5
  }

echo "cutover: ✓ $HOST → Worker '$WORKER'. Verify: curl -sS https://$HOST/v1/healthz"
