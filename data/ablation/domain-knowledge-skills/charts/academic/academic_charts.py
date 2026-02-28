"""
Generate all 9 charts in academic LaTeX style (Computer Modern, grayscale-friendly).
"""
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm
import numpy as np
from pathlib import Path

# ── Style Setup ──────────────────────────────────────────────────────────
plt.rcParams.update({
    "text.usetex": False,
    "font.family": "serif",
    "font.serif": ["CMU Serif", "Computer Modern Roman", "DejaVu Serif"],
    "font.size": 10,
    "axes.labelsize": 11,
    "axes.titlesize": 12,
    "legend.fontsize": 9,
    "xtick.labelsize": 9,
    "ytick.labelsize": 9,
    "axes.linewidth": 0.8,
    "axes.edgecolor": "#333333",
    "axes.grid": True,
    "grid.alpha": 0.3,
    "grid.linewidth": 0.5,
    "figure.dpi": 300,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
    "savefig.pad_inches": 0.1,
})

# Academic palette: grayscale-friendly, distinguishable in B&W print
C_WITH = "#2c2c2c"       # dark gray
C_WITHOUT = "#a0a0a0"    # light gray
C_FAIL = "#d62728"        # red for failures (standard academic red)
HATCH_WITH = ""
HATCH_WITHOUT = "///"

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "charts" / "academic"
OUT.mkdir(parents=True, exist_ok=True)

# ── Data ─────────────────────────────────────────────────────────────────
df = pd.read_csv(ROOT / "data" / "results.csv")
TASKS = ["JWT", "IDOR", "BIZ"]
MODES = ["with_skill", "without_skill"]
MODE_LABELS = {"with_skill": "With Skill", "without_skill": "Without Skill (MCP only)"}

# ── Helpers ──────────────────────────────────────────────────────────────
def save(fig, name):
    fig.savefig(OUT / name, facecolor="white")
    plt.close(fig)
    print(f"  ✓ {name}")

# ════════════════════════════════════════════════════════════════════════
# CHART 1: Success Rate by Task (Stacked Bar)
# ════════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(5.5, 3.5))
x = np.arange(len(TASKS))
w = 0.35

for i, mode in enumerate(MODES):
    sub = df[df["mode"] == mode]
    successes, failures = [], []
    for task in TASKS:
        t = sub[sub["task"] == task]
        s = (t["subtype"] == "success").sum()
        f = len(t) - s
        successes.append(s)
        failures.append(f)
    color = C_WITH if mode == "with_skill" else C_WITHOUT
    hatch = HATCH_WITH if mode == "with_skill" else HATCH_WITHOUT
    offset = -w/2 + i * w
    bars_s = ax.bar(x + offset, successes, w, label=f"{MODE_LABELS[mode]} — success",
                    color=color, hatch=hatch, edgecolor="black", linewidth=0.6)
    if any(f > 0 for f in failures):
        ax.bar(x + offset, failures, w, bottom=successes,
               label=f"{MODE_LABELS[mode]} — error_max_turns",
               color="white", hatch="xx", edgecolor=C_FAIL, linewidth=0.8)

ax.set_xticks(x)
ax.set_xticklabels(TASKS)
ax.set_ylabel("Number of Runs")
ax.set_title("Chart 1: Success Rate by Task and Mode")
ax.set_ylim(0, 4)
ax.set_yticks([0, 1, 2, 3])
ax.legend(loc="upper left", fontsize=7.5, framealpha=0.9)
save(fig, "chart1_success_rate_by_task.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 2: Median Turns + Median Cost (Two-Panel)
# ════════════════════════════════════════════════════════════════════════
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(7, 3.5))

for panel_idx, (col, ylabel, ax) in enumerate([
    ("num_turns", "Median Turns", ax1),
    ("total_cost_usd", "Median Cost (USD)", ax2),
]):
    for i, mode in enumerate(MODES):
        vals = []
        for task in TASKS:
            med = df[(df["mode"] == mode) & (df["task"] == task)][col].median()
            vals.append(med)
        color = C_WITH if mode == "with_skill" else C_WITHOUT
        hatch = HATCH_WITH if mode == "with_skill" else HATCH_WITHOUT
        offset = -w/2 + i * w
        bars = ax.bar(x + offset, vals, w, label=MODE_LABELS[mode],
                      color=color, hatch=hatch, edgecolor="black", linewidth=0.6)
        for bar, v in zip(bars, vals):
            fmt = f"{v:.0f}" if col == "num_turns" else f"${v:.2f}"
            ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5,
                    fmt, ha="center", va="bottom", fontsize=7)
    ax.set_xticks(x)
    ax.set_xticklabels(TASKS)
    ax.set_ylabel(ylabel)
    ax.legend(fontsize=7, framealpha=0.9)

ax1.set_title("Panel A: Median Turns")
ax2.set_title("Panel B: Median Cost")
fig.suptitle("Chart 2: Median Turns and Cost by Task/Mode", fontsize=12, y=1.02)
fig.tight_layout()
save(fig, "chart2_median_turns_cost.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 3: Per-Run Turns Dot Plot with Median Line
# ════════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(6, 3.5))
positions = []
labels = []
pos = 0
for task in TASKS:
    for mode in MODES:
        sub = df[(df["task"] == task) & (df["mode"] == mode)]
        color = C_WITH if mode == "with_skill" else C_WITHOUT
        marker = "o" if mode == "with_skill" else "s"
        jitter = np.random.default_rng(42).uniform(-0.12, 0.12, len(sub))
        ax.scatter([pos]*len(sub) + jitter, sub["num_turns"],
                   color=color, marker=marker, s=40, zorder=5,
                   edgecolors="black", linewidth=0.5)
        med = sub["num_turns"].median()
        ax.hlines(med, pos - 0.3, pos + 0.3, colors=C_FAIL, linewidth=1.5, zorder=6)
        ax.text(pos + 0.33, med, f"{med:.0f}", fontsize=7, va="center", color=C_FAIL)
        short = "WS" if mode == "with_skill" else "WO"
        labels.append(f"{task}\n{short}")
        positions.append(pos)
        pos += 1
    pos += 0.5

ax.set_xticks(positions)
ax.set_xticklabels(labels, fontsize=8)
ax.set_ylabel("Number of Turns")
ax.set_title("Chart 3: Per-Run Turns with Median")
save(fig, "chart3_turns_dotplot.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 4: Per-Run Cost Dot Plot with Failure Marker
# ════════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(6, 3.5))
for mode in MODES:
    sub = df[df["mode"] == mode]
    color = C_WITH if mode == "with_skill" else C_WITHOUT
    succ = sub[sub["subtype"] == "success"]
    fail = sub[sub["subtype"] != "success"]
    marker = "o" if mode == "with_skill" else "s"
    jitter_s = np.random.default_rng(7).uniform(-0.1, 0.1, len(succ))
    task_pos = [TASKS.index(t) for t in succ["task"]]
    ax.scatter(np.array(task_pos) + jitter_s, succ["total_cost_usd"],
               color=color, marker=marker, s=45, edgecolors="black",
               linewidth=0.5, label=MODE_LABELS[mode], zorder=5)
    if len(fail) > 0:
        jitter_f = np.random.default_rng(7).uniform(-0.1, 0.1, len(fail))
        task_pos_f = [TASKS.index(t) for t in fail["task"]]
        ax.scatter(np.array(task_pos_f) + jitter_f, fail["total_cost_usd"],
                   color=C_FAIL, marker="X", s=70, edgecolors="black",
                   linewidth=0.8, label="error_max_turns", zorder=6)

ax.set_xticks(range(len(TASKS)))
ax.set_xticklabels(TASKS)
ax.set_ylabel("Total Cost (USD)")
ax.set_title("Chart 4: Per-Run Cost with Failure Markers")
ax.legend(fontsize=7.5, framealpha=0.9)
save(fig, "chart4_cost_dotplot_failures.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 5: MCP Calls vs Turns Scatter
# ════════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(5.5, 4))
markers_task = {"JWT": "o", "IDOR": "s", "BIZ": "D"}
for mode in MODES:
    for task in TASKS:
        sub = df[(df["mode"] == mode) & (df["task"] == task)]
        color = C_WITH if mode == "with_skill" else C_WITHOUT
        ax.scatter(sub["mcp_calls"], sub["num_turns"],
                   color=color, marker=markers_task[task], s=50,
                   edgecolors="black", linewidth=0.5,
                   label=f"{task} / {MODE_LABELS[mode]}")

ax.set_xlabel("MCP Calls")
ax.set_ylabel("Number of Turns")
ax.set_title("Chart 5: MCP Calls vs. Turns")
ax.legend(fontsize=6.5, ncol=2, framealpha=0.9)
save(fig, "chart5_mcp_calls_vs_turns.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 6: Tool Errors by Task and Mode
# ════════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(6, 3.5))
pos = 0
positions, labels2 = [], []
for task in TASKS:
    for mode in MODES:
        sub = df[(df["task"] == task) & (df["mode"] == mode)]
        color = C_WITH if mode == "with_skill" else C_WITHOUT
        marker = "o" if mode == "with_skill" else "s"
        jitter = np.random.default_rng(11).uniform(-0.12, 0.12, len(sub))
        ax.scatter([pos]*len(sub) + jitter, sub["tool_errors"],
                   color=color, marker=marker, s=40, zorder=5,
                   edgecolors="black", linewidth=0.5)
        med = sub["tool_errors"].median()
        ax.hlines(med, pos - 0.3, pos + 0.3, colors=C_FAIL, linewidth=1.5, zorder=6)
        short = "WS" if mode == "with_skill" else "WO"
        labels2.append(f"{task}\n{short}")
        positions.append(pos)
        pos += 1
    pos += 0.5

ax.set_xticks(positions)
ax.set_xticklabels(labels2, fontsize=8)
ax.set_ylabel("Tool Errors")
ax.set_title("Chart 6: Tool Errors by Task and Mode")
save(fig, "chart6_tool_errors_by_task.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 7: Skill Compliance and Purity
# ════════════════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(5.5, 3.5))
ws = df[df["mode"] == "with_skill"]
wo = df[df["mode"] == "without_skill"]
metrics = {
    "Skill compliance\n(WS: skill_calls ≥ 1)": (ws["skill_calls"] >= 1).mean(),
    "Skill purity\n(WO: skill_calls = 0)": (wo["skill_calls"] == 0).mean(),
    "MCP usage\n(all: mcp_calls ≥ 1)": (df["mcp_calls"] >= 1).mean(),
}
bars = ax.barh(list(metrics.keys()), list(metrics.values()),
               color=[C_WITH, C_WITHOUT, "#666666"],
               edgecolor="black", linewidth=0.6, height=0.5)
for bar, v in zip(bars, metrics.values()):
    ax.text(bar.get_width() + 0.02, bar.get_y() + bar.get_height()/2,
            f"{v:.0%}", va="center", fontsize=9)
ax.set_xlim(0, 1.15)
ax.set_xlabel("Fraction of Runs")
ax.set_title("Chart 7: Skill Compliance and Purity")
save(fig, "chart7_skill_compliance.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 8: Outcome vs Validity Matrix
# ════════════════════════════════════════════════════════════════════════
outcomes = df["subtype"].unique()
statuses = df["status"].unique()
matrix = pd.crosstab(df["subtype"], df["status"])
fig, ax = plt.subplots(figsize=(4.5, 3))
im = ax.imshow(matrix.values, cmap="Greys", aspect="auto")
for i in range(matrix.shape[0]):
    for j in range(matrix.shape[1]):
        val = matrix.values[i, j]
        color = "white" if val > matrix.values.max() / 2 else "black"
        ax.text(j, i, str(val), ha="center", va="center", fontsize=12,
                fontweight="bold", color=color)
ax.set_xticks(range(matrix.shape[1]))
ax.set_xticklabels(matrix.columns, fontsize=9)
ax.set_yticks(range(matrix.shape[0]))
ax.set_yticklabels(matrix.index, fontsize=9)
ax.set_xlabel("Status (Protocol Validity)")
ax.set_ylabel("Subtype (Outcome)")
ax.set_title("Chart 8: Outcome × Validity Matrix")
fig.tight_layout()
save(fig, "chart8_outcome_validity_matrix.png")

# ════════════════════════════════════════════════════════════════════════
# CHART 9: Qualitative Evidence Heatmap
# ════════════════════════════════════════════════════════════════════════
df_sorted = df.sort_values(["task", "mode", "rep"])
evidence = pd.DataFrame({
    "run_id": df_sorted["run_id"],
    "Has Remediation": df_sorted["result_excerpt"].str.contains("remediat|fix|patch", case=False, na=False).astype(int),
    "Has Root Cause": df_sorted["result_excerpt"].str.contains("root cause|vulner|CVE|CVSS", case=False, na=False).astype(int),
    "Has Report": df_sorted["result_excerpt"].str.contains("report|assessment|finding", case=False, na=False).astype(int),
    "Screenshots > 0": (df_sorted["screenshots_moved"] > 0).astype(int),
    "Success": (df_sorted["subtype"] == "success").astype(int),
})
evidence = evidence.set_index("run_id")

fig, ax = plt.subplots(figsize=(6, 5))
im = ax.imshow(evidence.values, cmap="Greys", aspect="auto", vmin=0, vmax=1)
ax.set_xticks(range(evidence.shape[1]))
ax.set_xticklabels(evidence.columns, fontsize=8, rotation=30, ha="right")
ax.set_yticks(range(evidence.shape[0]))
ax.set_yticklabels(evidence.index, fontsize=7)
for i in range(evidence.shape[0]):
    for j in range(evidence.shape[1]):
        val = evidence.values[i, j]
        color = "white" if val > 0.5 else "black"
        ax.text(j, i, "Y" if val else "-", ha="center", va="center",
                fontsize=9, color=color, fontfamily="sans-serif")
ax.set_title("Chart 9: Qualitative Evidence Heatmap")
fig.tight_layout()
save(fig, "chart9_qualitative_evidence_heatmap.png")

print("\n✅ All 9 academic charts generated.")
