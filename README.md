<h1 align="center">🥚 phanes · 파네스</h1>

<p align="center"><em>seed 한 줄 → 스스로 도는 OUROBOROS 발견 루프 → 검증·이력추적된 발견 카탈로그</em></p>

<p align="center">Φάνης · "빛으로 끌어내는 첫 신" · downstream of hexa-lang · web SaaS</p>

---

`phanes` is a **hosted web product** — a **generic autonomous-cycle
platform**. A company brings a *measurable objective* + a
*verifier/oracle*; phanes drives hexa-lang's OUROBOROS engine
**`hexa kick`** (the loop `goal -> falsifier -> saturation`, rounds with a
per-round honesty/falsification gate) against it, and returns a
**verified, provenance-tracked result/catalog** (their own private
[`echoes`](https://github.com/dancinlab/echoes)).

> **Lore.** *Phanes* (Φάνης, from φαίνω "to bring to light") is the Orphic
> primordial deity of revelation, depicted **entwined by the OUROBOROS**.
> In hexa-lang the engine's codename is OUROBOROS — the serpent whose
> discoveries feed its own next round. **Ouro = the serpent (mechanism);
> Phanes = the light it reveals.** One image, inside and out.

## Install

```bash
# 1. Install hexa-lang (gives you `hexa` + `hx` package manager)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dancinlab/hexa-lang/main/install.sh)"

# 2. Install phanes
hx install phanes
```

## Position

- **Downstream of hexa-lang.** phanes consumes `hexa kick`; it does not
  fork the engine. Engine/platform gaps go upstream via
  `~/core/hexa-lang/inbox/patches/`. (hexa-lang `@I id002` · `@D g7`)
- **Web version.** Static front + control plane (auth · tenant isolation ·
  job queue · metering) + compute plane (the kick engine on a Linux
  fleet) + per-tenant catalog. Mirrors the shipped
  [`echoes-experience`](https://github.com/dancinlab/echoes-experience)
  deployment pattern.

## Honest caveat

phanes does **not** guarantee your objective is met. Under scope B the
**tenant-supplied verifier is the sole authority** for "objective met";
phanes surfaces saturation + that verifier's verdict and never claims
objective-met without the tenant verifier's PASS. The OUROBOROS honesty
gate is advisory; saturation / round-cap is the only hard stop.
Over-claim is forbidden (hexa-lang `LATTICE_POLICY.md`,
`@D g_honest_scope.scope_b`).

Brand-token note: "Phanes" has adjacent trademark collisions on record
(`@D g_name_risk`); chosen by user with that acknowledged. Formal
clearance precedes any public launch.

## Naming (on record)

- **Phanes · 파네스** — the chosen brand (design.md Decision 2). Lore as
  above. Collisions on record: Phanes Technologies (autonomous multi-agent
  AI) + Phanes Therapeutics (USPTO-registered TMs) + **phanes.app** (live
  "Economic Operating System for AI Agents" SaaS — a direct same-word,
  same-sector collision surfaced by the 2026-05-19 pre-screen).
- **Manteia · 만테이아** — Greek "the power of divination / prophecy"
  (root of *-mancy*); a discovery-oracle name the user also favors,
  recorded per request. **Also collided**: Manteia Technologies Co., Ltd.
  — active AI/software startup (adaptive radiotherapy), **registered
  trademarks in the computer/software class**.
- Open-web pre-screen ([`docs/TRADEMARK.md`](docs/TRADEMARK.md),
  2026-05-19): of the brainstormed names, **Ouro / Kythera / Haechi all
  collided** (active software/AI companies on the bare word); **Bythos**
  is the only one with no obvious software-space hit (uncertain, lower
  risk). **Mimir is NOT clean** — prior commercial software use (Mimir
  Classroom, acquired by HackerRank 2019); **Orrery** remains the single
  cleanest web result. This is a pre-screen, not a USPTO TESS search:
  a formal class-9/class-42 clearance via a trademark attorney remains
  an open pre-launch obligation (`@D g_name_risk`).
- **Sibling brand (paired cosmology)**: **`Demiurge` · 데미우르지** —
  sibling repo [`dancinlab/demiurge`](https://github.com/dancinlab/demiurge)
  (created 2026-05-18 as `hexa-arch`, renamed to `Demiurge` on
  2026-05-19). Lore pairing: **Phanes** (Orphic primordial revealer of
  Forms) ⇄ **Demiurge** (Platonic *Timaeus* shaper-to-Forms) — sibling
  cosmological figures, two `dancinlab` brands one continuous cosmology.
  `Demiurge` is the meta-conductor / universal technical-design
  architecture program (7-verb spine `명세→구조→설계→해석⟲→합성→
  검증→인계`, domain-pluggable, honesty-as-feature `g3`); `Phanes` is
  the SaaS autonomous-cycle platform side (this repo). The pairing
  was filed as a cross-session proposal at
  `demiurge/inbox/notes/brand-name-demiurge-pair-with-phanes.md` and
  locked as `demiurge/design.md` D23–D25 on 2026-05-19 (5 web-search
  rounds, collision-clean per `g3` evidence; 한글 `데미우르지` 4음절,
  파네스 3음절과 자매 리듬 정합).

## Status

Working prototype. **Scope = B — generic autonomous-cycle platform**
(pluggable seed + tenant verifier → `goal -> falsifier -> saturation`).

- **Service** — hexa-native HTTP server (`service/http_phanes.hexa`):
  a multilingual marketing site (cosmogony · Phanes · Demiurge ·
  hexa-lang · Anima · Demo · Pricing · Contact), a public preset-only
  demo, a session-authenticated HTMX dashboard, and the job API.
- **Substrate** — shell job runner + `jobctl`; per-tenant isolation =
  hybrid (`HX_DATA_DIR` per-tenant data boundary + `$HOME`-jail as
  defense-in-depth), kick binary promoted and verified.
- **Decisions** — all product + deployment gates closed in
  [`design.md`](design.md): host = AWS EC2, pricing = tier + metered
  (per OUROBOROS round, via Stripe), datastore = DynamoDB + S3,
  deploy = repo-committed `deploy.sh`.
- **Visibility** — public, **source-available**: the code is open to
  read and audit; the license is proprietary / All Rights Reserved
  (no right to run a competing service). See `design.md` Decision 16.

Remaining work is execution — provisioning the EC2 host, the DynamoDB
migration, the Stripe integration, deployment — tracked in
[`ROADMAP.md`](ROADMAP.md). Pre-public-launch obligations (formal
trademark clearance, `@D g_name_risk`) are specified in
[`docs/TRADEMARK.md`](docs/TRADEMARK.md).
