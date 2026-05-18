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

## Status

Scaffold. **Scope = B — generic autonomous-cycle platform** (pluggable
seed + tenant verifier → `goal -> falsifier -> saturation`).
**Deployment = public demo funnel + full dashboard** on a shared job API
(public demo = preset verifiers only, `@D g_public_demo_constraint`).
Next gate: multi-tenant isolation. Decisions tracked in
[`design.md`](design.md).
