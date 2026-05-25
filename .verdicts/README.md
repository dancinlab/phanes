# .verdicts — claim 검증 결과 영구 보존소

> `t_claim_verify` — `CLAIMS.tape` 의 각 claim 을 `hexa verify` (g5) 로 돌린
> **raw stdout 을 그대로** 보존한다. LLM 자가판정·paraphrase 금지 (g3 · LATTICE_POLICY).

## 레이아웃

```
.verdicts/
  <slug>/
    <claim-id>.txt      ← hexa verify 원문 (verbatim stdout)
  <slug>.tape           ← (선택) slug 전체 verdict 매트릭스 요약
```

`<slug>` = `CLAIMS.tape` 의 paper-track group slug. 한 slug 디렉터리 = 한 논문 후보.

## 규칙

- 파일명 = `CLAIMS.tape` 의 `raw =` 포인터와 1:1 일치.
- 내용 = 검증 명령의 **표준출력 원문**. 재가공·요약·의역 금지.
- 🟠 INSUFFICIENT / DEFERRED · 🟡 citation-only · ⚪ 미검증·fenced 는 게이트 통과 불가
  (`t_paper_gate`) — 보존은 하되 논문 섹션 링크로 쓰지 않는다.
- terminal (🔵 formal / 🟢 numerical / 🔴 CLOSED-negative) 만 `PAPER/<slug>/` 섹션에 링크.
- provenance: phanes 는 discovery 플랫폼이므로, 각 verdict 는 가능하면 그것을
  생성한 `hexa kick` 라운드(seed → falsifier → saturation)와 cross-link 한다.

## 현재 보존된 slug

| slug | group | 상태 |
|------|-------|------|
| `discovery-perfect-numbers-euclid` | DISCOVERY | 🔵 ×6 (verbatim 보존) — 완전수 6·28·496 + Euclid 형식 |
| `ouroboros-saturation-stop` | OUROBOROS | stub (verdict 미생성) |
| `platform-isolation-stub` | PLATFORM | stub (verdict 미생성) |
