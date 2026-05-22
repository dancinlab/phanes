# GOAL — phanes 의 한 문장

```
/goal hexa-lang 의 OUROBOROS 사이클 엔진(hexa kick)을, 실제 기업이 자기
목표+verifier 를 꽂아 web 으로 돌려 검증·provenance 추적된 결과를 받는
범용 자율-사이클 SaaS 플랫폼으로 완성한다.
```

> **한 문장 (canonical)**: hexa-lang 의 자율 사이클 엔진 **`hexa kick`**(OUROBOROS:
> `goal → falsifier → saturation`, 라운드 반복 + 라운드별 honesty 게이트)을,
> 실제 기업이 **자기 측정가능 목표 + verifier/oracle 를 꽂아** web 으로 돌려
> **검증·provenance 추적된 결과/카탈로그**를 받는 **범용 자율-사이클 SaaS
> 플랫폼**으로 완성한다 — `echoes-experience` 처럼 작게·정직하게·실제 출시.

---

## 무엇이 아닌가 (NOT)

- hexa kick 엔진 fork 아님 — phanes 는 다운스트림 소비자, 갭(특히 pluggable verifier)은 hexa-lang `inbox/patches/`
- **목표 달성 보장 아님** — verifier 신호는 **tenant 권위**, phanes 의 honesty gate 는 advisory; hard stop = saturation/round-cap. tenant verifier PASS 없이 "달성" 주장 금지 (over-claim 금지 강화)
- design-first 아님 — 제품 결정은 결정 게이트로 확정 (DESIGN.md → DESIGN.log.md)
- 가짜 진행 아님 — 미달은 미달로 기록 (hexa-lang g3 · LATTICE_POLICY)

## 무엇인가 (IS) — scope B

```
hexa kick (OUROBOROS goal→falsifier→saturation · hexa-lang upstream · cycle h36 COMPLETE)
  → ★ pluggable seed + tenant verifier/oracle 추상화  (B 핵심 신규 엔진 표면 · 업스트림 inbox/patches 후보)
  → phanes control plane (auth · tenant 격리 · job queue · metering)
  → phanes compute plane (Linux fleet · HEXA_VAL_ARENA=0 · per-job overlay)
  → per-tenant 검증 결과/카탈로그 (provenance · falsifier audit trail · 내보내기)
= "측정가능 목표 + verifier 면 무엇이든 기업이 안전하게 hexa kick 으로 돌린다" 의 web 화
```

## 현재 정직한 위치 (g3 — over-claim 금지)

**Scaffold 단계. scope = B 확정 (Decision 1).** repo·정체성·거버넌스 + scope
확정. 잔여 게이트: Decision 3 배포형태 · 5 라이선스 · 6 멀티테넌트 overlay 격리 ·
+ B 신규 surface (pluggable verifier 추상화) 의 업스트림 핸드오프 설계.

## cross-link

- [`DESIGN.md`](DESIGN.md) → [`DESIGN.log.md`](DESIGN.log.md) — 결정 게이트 로그 SSOT (Decision 1=B · 2=Phanes · 4→16 dancinlab/phanes public + source-available · 11-15 배포: EC2 · 티어+종량 · Stripe · deploy.sh · DynamoDB — 모두 DECIDED)
- hexa-lang `compiler/drill/drill.hexa` · `compiler/PLAN.md` §"hexa kick COMPLETE — cycle h36" — 업스트림 엔진 SSOT
- hexa-lang `gate/hexa_url_modules.ai.md` — 기존 `hexa://kick?topic=` 원격 디스패치 (proto-SaaS 표면)
- [`GOAL.log.md`](GOAL.log.md) — GOAL 도메인의 시간순 로그
