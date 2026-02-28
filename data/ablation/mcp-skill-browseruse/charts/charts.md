# Charts Reference

Two themed versions of each chart. All 18 runs valid; n=3 per cell.

| Version | Folder | Style |
|---|---|---|
| Academic | `academic/` | Serif fonts, blue/dark-red, white background, 300 DPI |
| Anthropic | `anthropic/` | Poppins headings + Lora body, brand blue (#6a9bcc) / orange (#d97757), warm #faf9f5 background, 300 DPI |

---

## Tier 1 — Core Findings

### Chart 1: Median Cost + Turns Grouped Bar Chart
**File:** `chart1_median_cost_turns.png`

Side-by-side bars per task, MCP vs CLI. Two panels: cost on top, turns on bottom. MCP costs $0.11–$0.13 vs CLI $0.36–$0.41 — a consistent 2.7–3.6× gap. Turns tell the same story: MCP 7–8 vs CLI 17–23.

### Chart 2: Individual Runs Dot Plot with Median Line
**File:** `chart2_dotplot_variance.png`

One dot per rep, per cell, with horizontal median line. Shows MCP's tight clustering (all tasks 7–8 turns, relative range 5–16%) vs CLI's wider spread (C-CLI relative range 68.5%, driven by the 28-turn C-PC-2 outlier). The variance story bar charts alone cannot tell.

### Chart 3: Cache Read/Turn vs Total Cost Scatter
**File:** `chart3_cacheread_vs_cost.png`

X = cache_read per turn (thousands), Y = total cost. MCP clusters at ~15K/turn, CLI at ~20K/turn — a modest 33% per-turn difference. But total cost spreads 3× apart on Y. Visual proof that cost is turn-count-driven, not context-size-driven.

---

## Tier 2 — Mechanistic Depth

### Chart 4: Cost Breakdown Stacked Bar
**File:** `chart4_cost_breakdown.png`

Per cell: stacked cache_read cost, input + cache_creation cost, Sonnet output cost, and Haiku subagent cost. CLI bars are dominated by cache_read (proportional to turns × context). MCP bars are uniformly tiny. Haiku (purple) appears only in CLI cells.

### Chart 5: Haiku Subagent Usage Heatmap
**File:** `chart5_haiku_heatmap.png`

18-cell grid (reps as rows, task+approach as columns). Every CLI run triggered Haiku; no MCP run did. Clean binary pattern that makes the systematic subagent overhead immediately visible.

---

## Tier 3 — Presentation / Bonus

### Chart 6: Cost vs Interaction Depth Line Chart
**File:** `chart6_cost_vs_depth.png`

Tasks A → B → C on X axis. MCP line stays nearly flat ($0.11 → $0.11 → $0.13). CLI line descends from $0.41 → $0.36 → $0.37 but remains 3× above MCP throughout. No crossover — MCP wins across all task types.

### Chart 7: Wall Time Comparison
**File:** `chart7_wall_time.png`

Grouped bars for median wall time. MCP: 38s / 35s / 50s. CLI: 89s / 87s / 87s. Duration ratios (1.7–2.5×) are lower than cost ratios (2.7–3.6×) because wall time is dominated by API round-trip latency rather than token volume.

---

## Generation

| Script | Source | Note |
|---|---|---|
| `gen_charts.py` | `data/results.csv` | Generates both themes in one pass |

Data: clean re-run, 18 runs, all passed tool-purity gate, 100% task success.

Cost breakdown uses token pricing consistent with CLI total_cost_usd for this run set (Sonnet 5/25, cache read/write 0.50/6.25, Haiku 1/5 per 1M tokens).
