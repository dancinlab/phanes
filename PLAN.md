# phanes — PLAN (remaining work)

Active to-do list after the 2026-05-19 live deploy. Distinct from
`ROADMAP.md` (phased plan) and `design.md` (decision SSOT — Decisions
1–24). Items here are honestly-scoped follow-ons; the architecture
itself is live and measured.

**Status anchor:** phanes is LIVE — `https://dancinlab.org` (Cloudflare
Containers: `phanes-phanesweb` std-1×3 + `phanes-phanesworker` std-2×5),
data plane on R2, dispatch on the `phanes-jobs` CF Queue. All routes
serve 200. Redeploy = `bash deploy.sh` (colima Docker + the
`cloudflare.deploy.token` secret).

## P-A · Deploy / ops follow-ups (small, near-term)

- [ ] **Email routing** — confirm `hello@dancinlab.org` lands in the
      team inbox (test mail delivered to Cloudflare MX, 0 bounce). If
      not, add the routing rule: Cloudflare dash → Email → Routing →
      destination for `hello@dancinlab.org`.
- [ ] **`www.dancinlab.org`** — only the apex is bound. Add `www` as a
      Workers Custom Domain, or a redirect apex↔www.
- [ ] **Scoped-token rotation** — schedule rotation for the three
      `secret`-stored CF credentials: `cloudflare.deploy.token`,
      `cloudflare.queues.token`, `r2.phanes.*`. Record the cadence.
- [ ] **Worker-tier live smoke** — the local B3 chain was measured, but
      verify end-to-end on live CF: real submit → `phanes-phanesworker`
      container consumes the queue → R2 status flips. (Local proof
      stands; this confirms the deployed worker class.)

## P-B · Datastore — B3 remainder (design.md Decision 21/23 follow-ons)

- [ ] **`overlay.n6` → R2** — `queue_worker.sh` writes terminal status
      to R2 but not yet the discovery overlay; copy `overlay.n6` to
      `overlays/<job_id>.n6` (Decision 21 key layout).
- [ ] **Job records fully on R2** — only the tenant *token* is migrated
      (`jobctl.sh` `_kv`-style). Move job.json + the `job_runner.sh`
      status writes to R2 so the web and worker tiers share one
      system-of-record (Decision 23).
- [ ] **`handle_get_or_result` R2 read-back** — the web tier still
      reads job status from the local filesystem; point it at the R2
      job record so any web instance can answer.
- [ ] **Newest-N job listing** — `r2_list` (ListObjectsV2) depends on
      the upstream SigV4 UriEncode fix (filed + resolved-ssot); adopt
      it once the hexa-lang binary phanes builds against carries it.

## P-C · Deferred sub-gates (decide when reached)

- [ ] **Worker autoscaling trigger** — candidate: CF Queue backlog
      depth → `phanes-phanesworker` instance count. Open as a decision
      gate when load justifies it.

## P-D · Pre-public-launch obligations (governance — design.md)

- [ ] **Trademark clearance** — USPTO class-42 search/clearance for
      "Phanes" (`@D g_name_risk`, Decision 2 — user override on record;
      clearance still owed before a public launch push).
- [ ] **Honest-scope marketing review** — audit all user-facing copy
      for over-claim (g3); the verifier-as-sole-authority and
      no-over-claim wording must stay accurate.
- [ ] **Upstream binary adoption** — when hexa-lang promotes the
      `HX_DATA_DIR` + pluggable-verifier work, rebuild phanes against
      it and drop the interim `$HOME`-jail / post-hoc-verifier shims.

## P-E · Upstream handoffs (filed — track to landed)

- [x] `phanes-aws-sigv4-signer-for-stdlib` — resolved-ssot.
- [x] `phanes-sigv4-uriencode-query-canonicalization-for-s3-list` —
      resolved-ssot (SigV4 UriEncode, 25/25; on hexa-lang origin/main).
- [x] `phanes-linux-self-host-build-driver-for-containerization` —
      resolved-ssot; `tool/ubu_bootstrap.sh` gained the verified
      `bootstrap` subcommand (hexa-lang a76637bf / fd6c0a07 / ac11281d).
- [ ] Confirm the SigV4 + ubu_bootstrap commits reach hexa-lang's
      pushed default branch (cherry-picked / merged), then bump
      `Dockerfile` `HEXALANG_SHA` to pick them up.

---

## Log

- **2026-05-19** — PLAN.md created. phanes went live this day:
  Decisions 21–24 (ALL-R2 datastore · Cloudflare Containers 2-tier ·
  R2+Queues hybrid · queue=REST), the B3 producer+consumer chain
  measured, the linux hexa self-host bootstrap solved, container images
  built, Workers Paid activated, deploy completed, `dancinlab.org`
  cut over to the `phanes` Worker (all routes 200), and
  `hello@dancinlab.org` wired into the Contact page. Remaining work
  catalogued above as P-A…P-E.
- **2026-05-20** — site-down incident + fix. `https://dancinlab.org` was
  unreachable after ~10 h overnight idle: TLS handshake fine, HTTP/2
  `GET /` sent, no bytes returned (`wrangler tail` showed the worker
  invocation hitting `Canceled` — the worker fetched the container DO
  but the response never came). Root cause: the PhanesWeb container had
  slept (sleepAfter `10m`) and the CF Containers wake-from-sleep path
  (containers#162) wedged. Two-step recovery: (1) `wrangler deploy` to
  cycle the container revision restored the site (200 in 350 ms); (2)
  one-line `src/worker.js` patch bumped PhanesWeb `sleepAfter` from
  `10m` → `1h` — 6× fewer sleep-wake cycles → 6× less exposure to the
  wedge, cost still bounded. Re-deployed + smoke-verified
  workers.dev + dancinlab.org both 200.
