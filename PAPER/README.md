# PAPER — phanes 논문 자동생성 플로우

> hexa-codex `cx_paper_*` → anima `a_paper_*` 를 phanes 로 이식한 논문 검역소.
> 거버넌스 SSOT = `project.tape` 의 `t_claim_*` + `t_paper_*` directive.

## 한 줄 요약

검증이 끝난 discovery-catalog 결과만 논문으로 자동 승격한다. 미검증·보류는 입구컷.
phanes 는 discovery 플랫폼이므로 **모든 claim 은 provenance(생성한 hexa kick 라운드)** 를 단다.

## 흐름

```
discovery 결과       검증              감사 surface         게이트            논문
hexa kick round  hexa verify (g5)  → .verdicts/        t_paper_gate   →  PAPER/<slug>/
/demo · job.json ───────────────→    <slug>/<id>.txt   (terminal +        main.tex
   │              │                     │            significance)     (≥10p + fig)
   └─ CLAIMS.tape ┘                     └─ §섹션 링크 ──┘                    │
      (claim 색인 + provenance)                              실패 → PAPER/<slug>/ 즉시 회수
```

## 게이트 기준 (`t_paper_gate`)

`/paper new <slug>` 는 **모든 섹션 claim 이 terminal** 이고 **유의성**을 만족할 때만 통과한다.

| terminal verdict | 게재 가능? |
|------------------|-----------|
| 🔵 SUPPORTED-FORMAL | ✅ |
| 🟢 SUPPORTED-NUMERICAL | ✅ |
| 🔴 CLOSED-negative (deterministic disagree) | ✅ (`t_paper_negative_ok`) |
| 🟠 INSUFFICIENT / DEFERRED | ❌ |
| 🟡 SUPPORTED-BY-CITATION | ❌ |
| ⚪ 미검증 / fenced speculation | ❌ |

**유의성** (`t_paper_significance`): 사전 등록 falsifier + 실측(hexa kick 라운드 / hexa verify) +
정량 finding (Δ vs baseline **또는** axis 를 배제하는 closed-negative). 단순 bookkeeping
closure·기지 identity·tenant verifier 없는 over-claim 은 제외 (`g_honest_scope` · GOAL NOT-list).

## 섹션 양식 (`t_paper_format`)

`§hypothesis` (falsifier 사전등록) · `§method` · `§measurement` (실측) · `§finding` (Δ 또는 ruled-out axis).
commons `g51` — 컴파일 ≥10페이지 + fal.ai figure ≥1개. 모든 섹션 주장은
`.verdicts/<slug>/<id>.txt` verdict 에 링크 (`t_paper_sections`).

## 도메인 그룹 (`t_paper_one_per_group`) — 그룹당 정식 논문 1개

phanes 의 실제 아키텍처(GOAL scope B: 엔진 ⇄ 컨트롤/컴퓨트 plane ⇄ 검증 카탈로그)에 맞춘 3 그룹.

| 그룹 | 범위 | 현 canonical slug |
|------|------|-------------------|
| **DISCOVERY** | hexa kick 가 생성한 검증된 발견 카탈로그 | `discovery-perfect-numbers-euclid` (🔵 ×6 — 완전수 6·28·496 + Euclid 형식) |
| **OUROBOROS** | 루프 엔진 거동 (goal→falsifier→saturation · 정지조건) | `ouroboros-saturation-stop` (stub) |
| **PLATFORM** | 컨트롤/컴퓨트 plane 공학 (per-job 격리 · 처리량 · metering) | `platform-isolation-stub` (stub) |

더 강한 결과가 나오면 **제자리 교체**한다 (백로그 누적·동일그룹 분기 금지). 게이트 실패 논문은
즉시 `PAPER/<slug>/` 삭제 (`t_paper_violation`).

## 작업 절차

```bash
# 1. claim 을 CLAIMS.tape 에 등재 (id · text · method · slug · group · raw · provenance)
# 2. 검증 → verdict 영구 보존 (raw stdout verbatim)
hexa verify --expr is_perfect 496 1 > .verdicts/discovery-perfect-numbers-euclid/perfect_496.txt
# 3. 모든 섹션 claim terminal + 유의성 확인 후 스캐폴드
/paper new discovery-perfect-numbers-euclid
# 4. figure
/paper fig square_hd figures/_prompts/cover.txt figures/cover.png
# 5. 컴파일 (pdflatex × 3 + bibtex)
/paper compile PAPER/discovery-perfect-numbers-euclid
```

상세 스캐폴드·figure·compile 동작은 `/paper help` 참고.
