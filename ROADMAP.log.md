# ROADMAP.log — phanes

Chronological log of ROADMAP-domain events (phase landings, measured
milestones, post-launch operations history). Current ROADMAP spec =
[`ROADMAP.md`](ROADMAP.md).

---

- **2026-05-19** — ROADMAP created at P0 DONE. All product gates closed
  same day (decision-gate cycle, `DESIGN.log.md`). Next executable = P1 (job
  API substrate). No code yet — P1 begins on user go.
- **2026-05-19** — "P1 go". Instrument-first: cheap oracle measured FIRST
  (1-round kick in `$HOME`-jail + `HEXA_VAL_ARENA=0` → rc=0, isolation
  proven, JSON `DrillResult` captured). Built `service/{job_runner.sh,
  jobctl.sh,API.md}`; full substrate self-test PASS (init→submit→get→
  result, wrong-token rc=4). **P1a DONE, measured.** Decision 7 (service
  language) logged in DESIGN.log.md.
- **2026-05-19** — "go" → P1b. Probe: stdlib/net HTTP server stack exists
  + builds from outside hexa-lang (HEXA_HOME env), 370KB arm64 binary.
  Built `service/http_phanes.hexa` (hexa-native HTTP), `service/build.sh`,
  `web/index.html` (echoes-experience template). Measured smoke 7/7
  PASS incl. seed-with-`=` intact through HTTP → jobctl → kick → result.
  Honest fix on record: form-encoded body truncated seeds containing
  `=`; pivoted to JSON body via `json_parse`. **P1b DONE, measured.**
  Upstream win: `phanes-hx-data-dir-per-tenant-isolation` handoff
  RESOLVED SSOT same-day in hexa-lang (binary promote pending).
- **2026-05-19** — "P2 go". Probe HX_DATA_DIR honor (NOT honored — old
  binary, pending promote, no new inbox). Measured: P2.1 ms wall meter
  (perl Time::HiRes, `wall_ms=1312` 1-round) · P2.4 post-hoc tenant
  verifier hook in `$HOME`-jail sandbox (env -i + timeout, auto-attach
  per-tenant verifier.sh, `verifier_rc=0` PASS) · P2.2 concurrency
  (`service/concurrency_test.sh` N=4, **isolation HOLDS** but service
  serialized 4.4/10 — `stdlib/net/http_server.hexa` sequential
  accept-loop; concurrent_serve port deferred as P2.x). P2.3 documented
  pending. P2.5 fleet routing documented deferred (P3-coupled).
  **P2.1+P2.2+P2.4 DONE measured.** No new upstream inbox items found.
- **2026-05-19** — PLAN.md created. phanes went live this day:
  Decisions 21–24 (ALL-R2 datastore · Cloudflare Containers 2-tier ·
  R2+Queues hybrid · queue=REST), the B3 producer+consumer chain
  measured, the linux hexa self-host bootstrap solved, container images
  built, Workers Paid activated, deploy completed, `dancinlab.org`
  cut over to the `phanes` Worker (all routes 200), and
  `hello@dancinlab.org` wired into the Contact page. Remaining work
  catalogued in ROADMAP §"P6 — Post-launch operations follow-ons".
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
