# Changelog

Chronological log of notable changes. One section per ship batch, date-keyed.

For the full audit trail, see `git log`.

---

## 2026-06-18

- **ARCHITECTURE.json — lossless hierarchical re-shape (commons c4)** — decomposed
  the over-long ` · `/` → `-joined cells (longest ~1128 chars; ~56 fields >250) into a
  real `children` tree: each parent keeps a short role line, every list-item / →-chain
  stage / `[ ]` checklist row / labeled measured-record becomes its own child node with
  the verbatim fragment text (leading separator preserved). Decomposed nodes: GOAL/IS
  scope-B chain, D19/D21/D22/D23/D24, P1–P5 phase records + the P-A/P-B/P-D/P-E
  follow-up checklists, the ARCHITECTURE 2-tier surfaces (web/worker/data-plane/build/
  repo-tree), the ARXIV A4 maps, and the LATTICE_POLICY sections. Coherent
  decision-rationale prose (D1–D18 etc.) left intact per c4 (don't shred sentences).
  58 → 167 nodes. Losslessness verified by non-whitespace char-multiset: 0 original
  chars dropped. Same schema (`name`/`summary`/`children`); JSON validates;
  ARCHITECTURE.html viewer renders unchanged (generic depth recursion).

- **harness 세팅** — applied the harness profile (strict by default):
  `harness.config.json` + `.harness/{enforcement,keywords,severity-map,prefs}.json`
  + `scripts/harness` wrapper + `.claude/settings.json` hooks
  (PreToolUse/PostToolUse/UserPromptSubmit) + `.git/hooks/{pre-commit,pre-push}`
  gates + protectedBranches. Pointed `docs.architecture` → `ARCHITECTURE.json`
  (single design SSOT); removed init's placeholder `ARCHITECTURE.md` to avoid a
  dual SSOT (commons c4). `.gitignore` allows `.claude/settings.json` so the
  hooks are tracked.

- **ARCHITECTURE.json tree SSOT** — retired the scattered domain `.md`/`.log.md`
  docs into a single `ARCHITECTURE.json` tree (hexa-codex/anima pattern) + the
  `ARCHITECTURE.html` viewer served by `python3 serve.py`. Folded: `DESIGN.md`/
  `DESIGN.log.md` (24 decisions incl. the 4→16, 15+18→21, 11→22 supersede chains
  and the F-D22/F-D23 falsifiers), `ROADMAP.md`/`ROADMAP.log.md` (P0–P6),
  `GOAL.md`/`GOAL.log.md`, `PHANES.md`/`PHANES.log.md`, the orphan `INBOX.log.md`
  (ARXIV A4 cross-pollination map), and the cross-project `LATTICE_POLICY.md`.
  `git rm`'d those pairs + `LATTICE_POLICY.md`; repointed live cross-links
  (CLAUDE.md design-SSOT pointer + tree, README, NEXUS.tape ssot/evidence) →
  `ARCHITECTURE.json`. Kept: README/CHANGELOG/CLAUDE/LICENSE. The chronological
  execution narratives below preserve every retired `.log.md` entry.

### Preserved log — GOAL / ROADMAP / DESIGN execution (2026-05-19, all measured)

- **Repo scaffold** — `phanes` git init (main); Decision 2 (name = Phanes)
  DECIDED with trademark-risk on record; Decision 1 (scope A/B/C) OPEN.
- **Decision 4** — pushed to `github.com/dancinlab/phanes` (**private**,
  origin/main, scaffold `38e5992`). Clearance deferred-but-owed (`@D g_name_risk`).
- **Decision 1 = B (Generic cycle platform)** (user directive over rec A).
  North-star + IS reframed for B; honest-scope tightened (`@D g_honest_scope`
  scope_b — tenant verifier = sole authority). New surface = pluggable
  seed+verifier abstraction (upstream inbox/patches candidate).
- **Decision 3 = 가+다** (public demo funnel + dashboard; job API = shared
  substrate). New governance `@D g_public_demo_constraint` (preset-only public demo).
- **Decision 6 = 다 (hybrid)** — per-job `$HOME`-jail + upstream first-class
  `HX_DATA_DIR` patch. Grounded in `compiler/drill/checkpoint.hexa:53`. Two
  upstream handoffs filed (`phanes-hx-data-dir-per-tenant-isolation` +
  `phanes-pluggable-verifier-oracle-for-drill-loop`).
- **Decision 5 = 가 Proprietary** (LICENSE committed). **ALL PRODUCT GATES
  CLOSED.** ROADMAP created (P0 DONE → P1 next).
- **P1a DONE measured** — instrument-first cheap oracle (1-round kick in
  `$HOME`-jail + `HEXA_VAL_ARENA=0` → rc=0, isolation proven, `DrillResult`
  captured). `service/{job_runner.sh,jobctl.sh,API.md}`; self-test PASS
  (init→submit→get→result, wrong-token rc=4). Decision 7 = shell substrate.
- **P1b DONE measured** — `service/http_phanes.hexa` (hexa-native HTTP over
  `stdlib/net`) builds clean (393KB arm64) + `web/index.html`. Smoke 7/7 PASS
  incl. seed-with-`=` intact end-to-end. Honest fix: form→JSON body pivot
  (`parse_query` naive `=` split → `json_parse`). Upstream win:
  `phanes-hx-data-dir-per-tenant-isolation` RESOLVED SSOT same-day (binary
  promote pending).
- **P2.1+P2.2+P2.4 DONE measured** — ms wall meter (perl Time::HiRes,
  `wall_ms=1312`); post-hoc tenant verifier hook (env -i + timeout sandbox,
  `verifier_rc=0`); concurrency N=4 (isolation HOLDS, service serialized 4.4/10
  by `http_server.hexa` accept-loop). P2.3 HX_DATA_DIR pending promote; P2.5
  fleet routing deferred to P3.
- **P2.x DONE measured (async-submit pivot)** — instrument-first
  (`concurrent_serve.hexa` docstring = single-thread serial → port wouldn't
  help) → decouple HTTP throughput from kick wall at the dispatcher layer
  (`nohup` + `disown` + atomic status transitions). baseline_submit_ms 162
  (vs 1530), 4-job end-to-end 2360ms (**~2.9× absolute throughput**), engine
  PARTIAL parallel 1.7/10. Filed 3rd upstream inbox
  `phanes-stdlib-net-os-thread-concurrency-roadmap-62`.
- **Decision 8 = 다 HTMX** — P3.thin landed: `GET /dashboard` HTML +
  `POST /dashboard/jobs` + HTMX-polled `GET /dashboard/jobs/<id>` (auto-stops
  on done/failed). Smoke 5/5 PASS. Same day: 3rd upstream RESOLVED SSOT
  (`socket_set_nonblock + socket_select`); Phanes-Demiurge brand pair LOCKED.
- **Decision 10 = cached preset demo · P4 DONE measured** — `GET /demo`
  (Palantir Titanium), 3 curated preset scenarios (σ(6)=12 · σ(28)=56 · Euclid
  2^(p-1)(2^p−1) → 496), zero live compute. All routes still 200.
- **Decisions 11–20** — host AWS EC2 (later superseded by D22) · pricing
  tier+metered (per round, Stripe) · `deploy.sh` · DynamoDB+S3 (later superseded
  by D21) · public source-available (D16 supersedes D4) · secret-CLI AWS-cred
  wrapper · single-table DynamoDB schema (later superseded) · discovery→atlas
  absorption (pinned, sub-gates open) · dancinlab.org on Cloudflare.
- **Decisions 21–24 + LIVE deploy** — ALL-R2 datastore (supersedes 15+18) ·
  Cloudflare Containers 2-tier (F-D22 PASS, worker floor std-2/≥6 GiB) ·
  R2 record + CF Queues pointer · CF Queues REST API (F-D23 PASS byte-exact).
  B3 full chain measured end-to-end on live CF (producer `q_send` `3f7f728` ·
  R2 job spec + consumer `queue_worker.sh` `96790da`). Linux self-host build
  SOLVED (4-step from-source bootstrap; resolved-ssot upstream), container
  images built, Workers Paid activated, deploy completed, `dancinlab.org` cut
  over to the `phanes` Worker (all routes 200, mail untouched).
- **HANDOFF — ARXIV A4** (filed 2026-05-26, folded into ARCHITECTURE.json):
  hexa-lang ARXIV A4 (PHANES axis) absorbed 10 autonomous-discovery papers →
  phanes 4-surface cross-pollination map; verify-able = 0 (honest, systems/SaaS
  axis). Key finding: the OUROBOROS engine (`compiler/drill/{drill,round}.hexa`)
  already implements the absorbed loops; strongest analog = AlphaEvolve
  (2511.02864). Future verify-able candidate: net-novelty-rate / saturation-round
  closed form (engine work, upstream via inbox/patches).

---

## 2026-05-22

- **project.tape SSOT** — project identity + governance consolidated into `project.tape`; interim Spec Kit scaffolding removed. `@D t_downstream_discipline` added (consume `hexa kick`, patch upstream).
- **domain doc split** — UPPERCASE domain docs + `PLAN.md` absorbed: `design.md` → `DESIGN.log.md` + `DESIGN.md` pointer; `GOAL.md` / `ROADMAP.md` `## Log` sections extracted to `.log.md` siblings; `PLAN.md` follow-ons absorbed into `ROADMAP.md` P6.

## 2026-05-21

- **web hero rework** — 5 hero images, text-above-image layout, Cloudflare Static Assets.
- **constitution v1.0.0** — hexa-lang pointer · tenant-verifier authority.

## 2026-05-20

- **deploy hardening** — 5-min keep-warm cron + `sleepAfter` widened (`10m` → `1h`, then `24h` on both tiers) to dodge the Cloudflare Containers wake-from-sleep wedge.
- **i18n** — hero blocks, demo scenarios, login & dashboard, and the remaining pages' body prose translated to 5 languages.

## 2026-05-19

- **LIVE** — phanes deployed at `https://dancinlab.org` (Cloudflare Containers 2-tier · R2 data plane · `phanes-jobs` CF Queue). Linux self-host build solved, container images built, Workers Paid activated. `hello@dancinlab.org` wired into the Contact page for early-access & enterprise.
