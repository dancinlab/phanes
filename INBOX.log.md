# INBOX — log

Append-only history sister 핸드오프 인덱스. 한 항목 = `## <ISO timestamp> — <header>` (newest on top); 본문 = `- [x]`(done) / `- [ ]`(pending) 체크박스. 해결 시 `- [x]` + `Status: resolved`. slug 를 앵커로 유지 (dup-race precheck 스캔 대상).

## 2026-05-26 — arxiv-a4-autonomous-discovery-ingest (hexa-lang ARXIV A4 handoff · g60)

- [ ] Status: open — hexa-lang ARXIV A4(PHANES axis)가 흡수한 자율발견/OUROBOROS 논문 10편 → phanes 4표면 아키텍처 cross-link 핸드오프 (g60). owner = phanes 세션 (4표면 설계 참조 채택 + future net-novelty verify-atom seed 판단).

**출처**: hexa-lang `ARXIV` 도메인 A4 마일스톤 (PR: hexa-lang `feat(ARXIV): A4 PHANES axis`). verdict(ASCII) = `hexa-lang:ARXIV/.verdicts/arxiv-phanes-absorb/triage_a4.txt` · docs(한글) = `hexa-lang:ARXIV/docs/a4-phanes-axis.md` · `hexa-lang:CLAIMS.tape` @C slug=arxiv-phanes-absorb.

**무엇**: arXiv 8 query → 10편 흡수 (cs.AI·cs.LG·cs.MA·cs.NE; AI-Scientist 루프·self-improving agent·verifier-driven RL/RLVR·open-endedness·quality-diversity/novelty search·LLM-진화탐색·AutoML-Zero). **verify-able 0 (정직·예상대로)** — PHANES 는 systems/SaaS 축·OUROBOROS 엔진 소비자라 `hexa verify --expr` 에 폐형해 atom 부재 (hexa-lang A2 ANIMA 와 동형, A3 DEMIURGE verify-native 와 정반대). A4 가치 = citation + **phanes cross-pollination(4표면 맵)**.

**핵심 발견**: phanes OUROBOROS 엔진(`hexa-lang:compiler/drill/{drill,round}.hexa`)이 흡수 논문들의 루프를 **이미 구현**하고 있다 —

| 논문이 서술하는 메커니즘 | phanes 엔진 실제 구현 |
|---|---|
| open-endedness / novelty 소진까지 무한 탐색 | drill.hexa "saturation (round yield = 0) or max-rounds" |
| novelty search / QD 정지 기준 | round.hexa `net_novel == 0` = **C5 novelty-fixpoint signal** (그 자체) |
| verifier-driven RL / RLVR / VLM-as-judge | drill.hexa pluggable verifier + `_honesty_gate` (라운드별 verdict 감사) |
| provenance / discovery catalog | overlay 누적 (`overlay_append_lines`, 후속 라운드가 atlas overlay 봄) |
| AI-Scientist tenant-objective | phanes job 모델 `{seed, verifier_ref, rounds_cap}` |

**phanes 4표면 cross-link (10 handoff)** — `GOAL.md` / `ROADMAP.md` / `project.tape` 표면 매핑:

| phanes 표면 | 흡수 논문 → 기여 |
|---|---|
| **OUROBOROS 발견 루프** (goal→falsifier→saturation, drill_run) | 2406.04268 Open-Endedness-Essential-for-ASI (Hughes+ DeepMind; bounded-OE = 라운드 캡 framing) · 2003.03384 AutoML-Zero (Real+; search+자동eval 엔진 조상) · **2511.02864 AlphaEvolve** (Georgiev/Gómez-Serrano/Tao; LLM 생성+자동eval+propose/test/refine = phanes 직접 hosted-analog) · 2504.05108 Algorithm-Discovery-with-LLMs (Surina+; 진화탐색+RL 루프) |
| **pluggable verifier 게이트** (_honesty_gate · _verifier_run; ROADMAP P2.4/P2.6) | 2405.15568 OMNI-EPIC (Faldor/Zhang/Cully; LLM 이 task+코드 success-함수 작성 = verifier-as-code = tenant 가 obj+verifier 가져오는 모델 직결) · 2602.11549 Native-Reasoning-on-Unverifiable-Data (Wang+; RLVR 외부-verifier 의존 병목 = oracle 없을 때 tenant-verifier-as-sole-authority frontier, P2.6 pluggable-verifier upstream patch 의 이론적 동기) |
| **provenance / catalog** (overlay 누적 · DrillResult audit trail; ROADMAP P-B R2) | 2508.15126 aiXiv (Zhang+; AI-생성 제안 + 자동 peer-review + exportable 카탈로그 = per-tenant 검증 카탈로그 모델) · 2511.02864 AlphaEvolve (refine 감사 trail) |
| **tenant-objective 모델** ({seed, verifier_ref, rounds_cap}; ROADMAP P1) | 2306.01711 OMNI (Zhang/Lehman/Stanley; LLM "흥미도" 모델 = 라운드별 next-seed 선택, round.hexa) · 2502.14297 Sakana-AI-Scientist-eval (Beel/Kan+; over-claim 위험 독립평가 = `@D g_honest_scope` honest-scope 가드, verifier=sole authority 선례) · 2504.21024 WebEvolver (Fang+; 자기-샘플 trajectory self-improve 루프 소비자) |

**가장 강한 대응**: AlphaEvolve(2511.02864, Tao+)는 phanes "hosted LLM-propose + automated-verify + refine" 루프의 **직접 analog** — phanes = tenant 가 obj+verifier 를 꽂는 hosted AlphaEvolve. ROADMAP §"phanes is LIVE" 와 정확히 같은 추상화의 학술 선례 → README/마케팅 카피의 정직-범위 인용 근거로 활용 가능 (단 over-claim 금지, `@D g_honest_scope`).

**future verify-able-CANDIDATE seed (현재 🟢 아님)**:
- **net-novelty-rate / saturation-round 폐형해** — `round.hexa` 가 이미 `net_novel`(C5 novelty fixpoint)을 계산. instrumented "포화까지 기대 라운드 수" 또는 "novelty 감쇠율" 폐형해가 미래 엔진-instrumentation lane 에서 `hexa verify --expr` atom 이 될 수 있음 (metering/billing-basis 와도 연결 — ROADMAP "billed per OUROBOROS round"). 이는 엔진 작업이지 arxiv-인용 수학이 아니라 A4 verify 로 세지 않음. phanes 가 round 메트릭을 폐형해로 정량화하려면 hexa-lang `inbox/patches/` 로 upstream 제안(project.tape `@D t_downstream_discipline`).

**필링 이력 (g48 ack)**: A4 가 phanes feature 브랜치(`domain/init-phanes`, non-main)에서 핸드오프를 working-copy edit(이 파일 신규 생성)로만 기록(non-main 트리 commit 회피)했고, **hexa-lang ARXIV A6 가 격리 worktree(off origin/main)로 본 항목을 phanes main 에 커밋했다** (cross-repo handoff 메커니즘 정립 + 3 debt 정산). phanes 세션은 이 항목을 소비 + `domain/init-phanes` 브랜치를 origin/main 과 reconcile 하면 된다.

**cross-ref**: hexa-lang `ARXIV` 도메인 (A1 ingest-poc + A2 ANIMA + A3 DEMIURGE + A4 본편 + A6 핸드오프 메커니즘) · hexa-lang `compiler/drill/{drill,round}.hexa` (OUROBOROS 엔진 SSOT — upstream) · phanes `GOAL.md`/`ROADMAP.md` (OUROBOROS goal→falsifier→saturation · job {seed,verifier_ref,rounds_cap} · P2.4/P2.6 pluggable verifier) · sibling V5-IIT lane (verify_cli/stdlib, 동시 진행).
