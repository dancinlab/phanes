# Pre-launch audit — Tasks C2 + C3 (2026-05-19)

Branch `audit-prelaunch`. Auditor: Claude Opus 4.7 (1M context).
Scope: `service/http_phanes.hexa`, `service/job_runner.sh`, `service/jobctl.sh`.

## C2 — HX_DATA_DIR binary-promote probe

**Result: NOT honored.** No phanes code change made.

### How phanes invokes the engine
`jobctl.sh submit` spawns `job_runner.sh` (detached `nohup`), which runs
`$PHANES_HEXA_HOME/bin/hexa-absorbed-kick` inside a per-job `$HOME`-jail
(`HOME=$JAIL`, `HEXA_VAL_ARENA=0`). The deployed binary probed:
`~/core/hexa-lang/bin/hexa-absorbed-kick` (built 2026-05-18 23:00).

### Probe (4 runs, arm64 macOS)
Minimal kick op (`--seed "..." --rounds 1 --engine mk9`) under varied env,
checking which of 3 candidate roots received `atlas.overlay.n6`:

| run | HOME | HX_DATA_DIR | jail .hx/data pre-created | overlay landed in |
|-----|------|-------------|---------------------------|-------------------|
| 2 | jail | (unset) | yes | **HOME-jail** ✓ |
| 3 | jail | /tmp/dd (empty) | no | HOME-jail (HX_DATA_DIR ignored) |
| Y | jail | /tmp/dd pre-created | yes | **HOME-jail** — HX_DATA_DIR **ignored** |

Real `~/.hx/data/atlas.overlay.n6` mtime unchanged across all jailed runs.

**Conclusion:** the deployed `hexa-absorbed-kick` resolves its data dir
from `$HOME/.hx/data` and ignores `HX_DATA_DIR` entirely — the upstream
`hx_data_dir()` helper landed RESOLVED-SSOT but the binary phanes invokes
is pre-promote. The `$HOME`-jail (Decision 6 가) IS honored and remains
the working isolation boundary.

This independently re-confirms the existing `job_runner.sh` P2.3 comment
("running binary is pre-promote (probe: NOT honored)"). That comment is
accurate; no edit required. When hexa-lang promotes a binary that honors
`HX_DATA_DIR`, wire `HX_DATA_DIR="$JAIL/.hx/data"` into the kick env line
in `job_runner.sh` and keep the `$HOME`-jail as defense-in-depth.

## C3 — honest-scope marketing review

**Result: all rendered copy PASSES. No copy edit made.**

Audited every user-facing string in `render_*` functions: cosmogony
landing, the 4 product overview pages (phanes/demiurge/hexa-lang/anima)
— hero tags/sublines/stat strips, overview leads + p2 paragraphs,
key-feature bullets, How-It-Works steps, connected-system cards,
verified-solution closers — plus login, dashboard, footer, nav, and the
`_t()` translation table.

- **No over-claim (g_honest_scope / g3):** Phanes copy sells "verified,
  provenance-tracked discovery" and is explicit — `vf_body`: "No
  over-claim, no project-completion promise. Saturation is the only hard
  stop." `f1b` + `dintro` + `dnote` all state "the tenant verifier is
  the sole authority for objective-met" and "phanes never claims a
  result the verifier did not pass" (g_honest_scope.scope_b satisfied).
- **No third-party brand names in rendered copy:** all `Palantir` /
  `SpaceX` occurrences are `//` code comments documenting design
  provenance (permitted). A grep of the served HTML for all 6 product
  pages returned zero brand-name hits and zero over-claim phrasing.
- **Numeric claims real/checkable:**
  - Phanes `s1v=6` "stage discovery chain" — confirmed: kick prints
    "Mk.IX 6-stage chain (smash -> free -> absolute -> meta -> hyper ->
    resonance)".
  - hexa-lang `s2v=38/44` "tier-1 corpus PASS" / vf_body "38 of 44
    corpus checks pass, remaining six all outside tier-1" — confirmed
    against hexa-lang `compiler/PLAN.md` ("gate-1 38/44 ... 잔여 6
    non-MATCH 는 100% non-tier-1").
  - `0` stats are by-rule claims (over-claim / LLVM / AGI overreach), fine.

## Build + smoke

`HEXA_MAC_BUILD_OK=1 bash build.sh` (non-heavy CI bypass; macOS build
refuses `/tmp` output by default) — built OK. All 8 routes smoke-tested
on :8814: `/ /phanes /demiurge /hexa-lang /anima /login` → 200,
`/dashboard` → 303 (unauth redirect, expected), `/static/htmx.min.js` →
200.

## g3-honest summary

Both audits came back clean of any actionable defect: C2 measured
NOT-honored (matching the existing accurate code comment — no change
correct) and C3 found every rendered string within honest scope. No
phanes source was modified; this note is the deliverable.
