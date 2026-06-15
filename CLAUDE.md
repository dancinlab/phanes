# phanes

Hosted autonomous-discovery platform (OUROBOROS loop · `hexa kick` engine). Tenants bring an objective + verifier; phanes drives the loop and returns a verified, provenance-tracked catalog.

> 📍 **거버넌스 SSOT** — 이 문서는 `project.tape` 를 마크다운으로 재설계·단일화한 것이다 (`.tape` 은퇴).
> parent: `dancinlab` · ssot: `github.com/dancinlab/phanes` (`hx install phanes`) · siblings: `hexa-lang`

## 거버넌스 (governance)

### downstream discipline — consume `hexa kick`, patch upstream
- ✅ engine / multi-tenant gap → `hexa-lang/inbox/patches/<slug>.md` (one concept each) → upstream review
- ⛔ fork the hexa kick engine · inline downstream workaround · mix multiple concepts in one patch file

## 워크플로우 (workflow — CLAIMS · VERIFY · PAPER · DISCOVERY)

### CLAIMS.tape — single audit index of verifiable claims
- ✅ every verifiable claim in root `CLAIMS.tape` — id · text · method · slug · verdict pointer
- ⛔ scatter claims across docs / job.json without a `CLAIMS.tape` index — no audit surface

### claim verify — every claim runs through `hexa verify`, verdict persisted verbatim
- ✅ each `CLAIMS.tape` entry → `hexa verify` (g5) → `.verdicts/<slug>/<id>.txt` raw stdout
- ⛔ LLM self-judge correctness (g3) · paraphrase verdicts · hide red / unfenced speculation

### claim provenance — every claim links its generating `hexa kick` round
- ✅ claim carries provenance — seed · falsifier · saturation round (DrillResult / /demo scenario)
- ✅ tenant verifier rc is the sole authority for "objective met" — never an LLM judgement
- ⛔ claim with no provenance trail · over-claim a result without a tenant verifier PASS

### /paper gate — gated on terminal verdict AND significance
- ✅ `/paper new <slug>` only when every section claim is terminal AND significance satisfied
- ✅ terminal = 🔵 formal / 🟢 numerical / 🔴 CLOSED-negative — not 🟠 deferred / 🟡 citation
- ⛔ scaffold w/ any 🟠 deferred · 🟡 citation-only · ⚪ unfenced speculation · trivial recheck

### paper significance — falsifiable hypothesis + real measurement + a finding
- ✅ trigger only on pre-registered falsifier + real measurement (hexa kick / verify) + finding
- ✅ finding = Δ vs baseline OR a closed-negative ruling out an axis
- ⛔ paper for a bookkeeping closure · known identity · unverified prediction · 🟠 residual

### closed-negative findings are publishable
- ✅ a 🔴 FALSIFIED result that deterministically rules out a path is a valid paper
- ✅ frame as a negative result — the falsifier + the ruled-out space
- ⛔ treat a closed-negative as a non-finding · bury a falsification · publish 🟠 as if closed

### paper format — hypothesis · method · measurement · finding
- ✅ §hypothesis (falsifier) · §method · §measurement (real run) · §finding (Δ OR ruled-out axis)
- ✅ commons g51 — compile ≥10 pages + ≥1 fal.ai figure
- ⛔ narrative-only · measurement substitute for hypothesis · skip §finding · vague claims

### paper sections — every section claim links to its verdict
- ✅ every section claim links to its `.verdicts/<slug>/<id>.txt` verdict (verbatim stdout)
- ⛔ ship paper with any unresolved residual section · treat the verdict matrix as optional

### violating paper immediately revoked
- ✅ violating paper (gate / significance fail) revoked immediately — `PAPER/<slug>/` removed
- ⛔ keep a violating paper as draft · mark WIP · defer revocation · allow a residual

### any verified discovery becomes a paper — free slug, no fixed domain
- ✅ every terminal discovery → its own paper slug (named by the finding, not a fixed bucket)
- ✅ replace/supersede in place when a stronger finding lands on the same slug
- ⛔ pre-assign papers to fixed domain buckets · cap the paper set · force a finding into wrong slug

### discovery runs continuously, not only at cycle tail
- ✅ interleave `/kick` · `/gap` discovery every batch — a discovery lane runs alongside verify
- ⛔ defer discovery to the end · single tail-only round · stop discovering once a paper ships

### discoveries persist at `.discoveries/<slug>.tape`
- ✅ log every kick/gap discovery to `.discoveries/<slug>.tape` — id · seed · verdict-tier-target
- ⛔ discard discovery output · paraphrase findings · skip linking discovery → next-cycle claim

## 구조 (tree)

```
phanes/
├─ src/            — OUROBOROS loop engine / hexa kick driver (core)
├─ service/        — hosted multi-tenant service layer
├─ web/            — tenant-facing web surface
├─ docs/           — design & operations docs
├─ PAPER/          — generated papers (gated; one slug per terminal discovery)
├─ archive/        — superseded material
├─ CLAIMS.tape     — single audit index of verifiable claims
├─ NEXUS.tape      — cross-domain link registry
├─ DESIGN.md       — architecture design (+ DESIGN.log.md history)
├─ GOAL.md         — objectives (+ GOAL.log.md history)
├─ PHANES.md       — platform domain doc (+ PHANES.log.md history)
├─ ROADMAP.md      — roadmap (+ ROADMAP.log.md history)
├─ CHANGELOG.md    — change history (append-only)
└─ deploy.sh · cutover-domain.sh · Dockerfile · wrangler.jsonc · package.json — deploy/runtime + Node/TS app
```
