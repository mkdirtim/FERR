# Charts Reference (Skills Experiment)

Dataset: `data/results.csv`  
Design: 3 tasks × 2 modes × 3 reps = 18 runs  
Modes: `with_skill` vs `without_skill` (MCP-only)

---

## Tier 1 — Core Figures

### Chart 1: Success Rate by Task and Mode (Stacked Bar)
**File:** `chart1_success_rate_by_task.png`

- Bars per task (`JWT`, `IDOR`, `BIZ`) split by mode.
- Stack: `success` vs `error_max_turns`.
- Main capability figure: only BIZ shows a gap (`with_skill` 3/3 vs `without_skill` 2/3).

### Chart 2: Median Turns + Median Cost (Two-Panel Grouped Bar)
**File:** `chart2_median_turns_cost.png`

- Panel A: median `num_turns` per task/mode.
- Panel B: median `total_cost_usd` per task/mode.
- Core efficiency comparison.

### Chart 3: Per-Run Turns Dot Plot with Median Line
**File:** `chart3_turns_dotplot.png`

- One dot per run in each task/mode cell.
- Horizontal median line.
- Shows instability and tail behavior (especially BIZ `without_skill`).

---

## Tier 2 — Mechanistic Figures

### Chart 4: Per-Run Cost Dot Plot with Failure Marker
**File:** `chart4_cost_dotplot_failures.png`

- One dot per run, colored by mode.
- Distinct marker for `subtype=error_max_turns`.
- Makes expensive non-completions visually explicit.

### Chart 5: MCP Calls vs Turns Scatter
**File:** `chart5_mcp_calls_vs_turns.png`

- X: `mcp_calls`, Y: `num_turns`.
- Color by mode, shape by task.
- Useful for diagnosing interaction-depth/loop behavior.

### Chart 6: Tool Errors by Task and Mode
**File:** `chart6_tool_errors_by_task.png`

- Dot+median (or boxplot) of `tool_errors` per cell.
- Supports operational-friction interpretation.

---

## Tier 3 — Quality / Qualitative Figures

### Chart 7: Skill Compliance and Purity
**File:** `chart7_skill_compliance.png`

- `with_skill`: fraction of runs with `skill_calls >= 1`.
- `without_skill`: fraction of runs with `skill_calls = 0`.
- Optionally include `mcp_calls >= 1` and screenshot coverage.

### Chart 8: Outcome vs Validity Matrix
**File:** `chart8_outcome_validity_matrix.png`

- 2D matrix over runs:
  - Outcome axis: `subtype` (`success`, `error_max_turns`)
  - Validity axis: `status` (`ok`, `invalid_*`)
- Clarifies the distinction between task success and protocol validity.

### Chart 9: Qualitative Evidence Heatmap (Optional)
**File:** `chart9_qualitative_evidence_heatmap.png`

- Rows: run IDs.
- Columns: extracted binary markers from logs/results (e.g., remediation present, root cause present, final report present, screenshot count > 0).
- Good appendix figure to support qualitative findings.

---

## Suggested Main-Paper Set

Use these in the main text:

1. `chart1_success_rate_by_task.png`
2. `chart2_median_turns_cost.png`
3. `chart3_turns_dotplot.png`
4. `chart4_cost_dotplot_failures.png`

Put `chart5`–`chart9` in appendix/extended analysis.

---

## Current Data Snapshot (for caption sanity checks)

- JWT: success 3/3 in both modes; median turns `28` (with) vs `37` (without)
- IDOR: success 3/3 in both modes; median turns `36` (with) vs `30` (without)
- BIZ: success `3/3` (with) vs `2/3` (without)
- Failed run: `BIZ-WO-3` (`subtype=error_max_turns`)

---

## Notes for Plotting

- Treat `subtype=success` as task success.
- Keep `status` separate as protocol validity signal.
- Use medians (n=3 per cell), and always show per-run points.
- Keep failed runs visible (do not drop them from scatter/dot plots).
