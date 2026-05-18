<h1 align="center">🥚 phanes · 파네스</h1>

<p align="center"><em>seed 한 줄 → 스스로 도는 OUROBOROS 발견 루프 → 검증·이력추적된 발견 카탈로그</em></p>

<p align="center">Φάνης · "빛으로 끌어내는 첫 신" · downstream of hexa-lang · web SaaS</p>

---

`phanes` is a **hosted web product** that lets companies run hexa-lang's
autonomous discovery engine — **`hexa kick`** (the OUROBOROS loop:
`smash -> free -> absolute -> meta -> hyper -> resonance`, rounds until
saturation, with a per-round honesty/falsification gate) — and get back a
**verified, provenance-tracked discovery catalog** (their own private
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

phanes sells **what `hexa kick` actually produces**: verified, atlas-bound
mathematical/algorithmic *discoveries* with a falsification audit trail.
It is **not** "autonomously completes your software project" — the
OUROBOROS honesty gate is advisory; saturation is the only hard stop.
Over-claim is forbidden (hexa-lang `LATTICE_POLICY.md`, `@D g_honest_scope`).

Brand-token note: "Phanes" has adjacent trademark collisions on record
(`@D g_name_risk`); chosen by user with that acknowledged. Formal
clearance precedes any public launch.

## Status

Scaffold. Product **scope is the open decision gate** —
A Conjecture-Mine *(recommended)* / B Generic cycle platform /
C Echoes-as-a-Service. Decisions tracked in [`design.md`](design.md).
