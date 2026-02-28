#!/usr/bin/env python3
"""
Regenerate all 7 academic charts with a grayscale-friendly,
journal-ready style (IEEE / ACM / Springer).

Style: DejaVu Serif (CM-like), grayscale palette with hatching,
thin axes, subtle grid, 300 DPI export.
"""

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
from pathlib import Path

# ── paths (relative to script location) ────────────────────────
SCRIPT_DIR = Path(__file__).resolve().parent
DATA       = SCRIPT_DIR.parent / "data" / "results.csv"
OUTDIR     = SCRIPT_DIR / "academic"
OUTDIR.mkdir(parents=True, exist_ok=True)

# ── global style ───────────────────────────────────────────────
FONT_FAMILY = "DejaVu Serif"
C_MCP  = "#2c2c2c"   # dark gray  – solid bars
C_CLI  = "#a0a0a0"   # light gray – hatched bars
C_RED  = "#d62728"    # accent (errors / medians)
C_AXIS = "#333333"
GRID_ALPHA = 0.30
HATCH_CLI  = "///"

plt.rcParams.update({
    "font.family":       "serif",
    "font.serif":        [FONT_FAMILY],
    "font.size":         9,
    "axes.titlesize":    12,
    "axes.labelsize":    11,
    "xtick.labelsize":   9,
    "ytick.labelsize":   9,
    "legend.fontsize":   8,
    "axes.linewidth":    0.8,
    "axes.edgecolor":    C_AXIS,
    "axes.grid":         True,
    "grid.alpha":        GRID_ALPHA,
    "grid.linewidth":    0.5,
    "figure.facecolor":  "white",
    "axes.facecolor":    "white",
    "savefig.dpi":       300,
    "savefig.bbox":      "tight",
    "savefig.pad_inches": 0.1,
})

# ── load data ──────────────────────────────────────────────────
df = pd.read_csv(DATA)

# Pricing constants (per-1M tokens)
SONNET_INPUT   = 5.00 / 1_000_000
SONNET_OUTPUT  = 25.00 / 1_000_000
SONNET_CACHE_R = 0.50 / 1_000_000
SONNET_CACHE_W = 6.25 / 1_000_000
HAIKU_INPUT    = 1.00 / 1_000_000
HAIKU_OUTPUT   = 5.00 / 1_000_000

df["cache_read_cost"]  = df["sonnet_cache_read"]  * SONNET_CACHE_R
df["input_cache_cost"] = df["sonnet_input"] * SONNET_INPUT + df["sonnet_cache_creation"] * SONNET_CACHE_W
df["sonnet_out_cost"]  = df["sonnet_output"] * SONNET_OUTPUT
df["haiku_cost"]       = df["haiku_input"] * HAIKU_INPUT + df["haiku_output"] * HAIKU_OUTPUT
df["cache_per_turn"]   = df["sonnet_cache_read"] / df["num_turns"]
df["wall_sec"]         = df["duration_ms"] / 1000

TASKS = ["A", "B", "C"]
TASK_LABELS = {"A": "Task A\n(SQLi)", "B": "Task B\n(XSS)", "C": "Task C\n(JWT)"}

def approach_label(a):
    return "MCP" if "mcp" in a else "CLI"

df["mode"] = df["approach"].apply(approach_label)

# ── helpers ────────────────────────────────────────────────────
def median_table(col):
    """Return medians grouped by (task, mode)."""
    return df.groupby(["task", "mode"])[col].median().unstack("mode")

def save(fig, name):
    fig.savefig(OUTDIR / name)
    plt.close(fig)
    print(f"  ✓ {name}")

# ══════════════════════════════════════════════════════════════
# CHART 1 — Median Cost + Turns  (two-panel grouped bars)
# ══════════════════════════════════════════════════════════════
def chart1():
    fig, (ax_c, ax_t) = plt.subplots(2, 1, figsize=(5, 5.5), sharex=True)
    fig.suptitle("MCP vs CLI: Cost and Turn Efficiency", fontsize=13, fontweight="bold", y=0.97)

    med_cost  = median_table("total_cost_usd").reindex(TASKS)
    med_turns = median_table("num_turns").reindex(TASKS)

    x = np.arange(len(TASKS))
    w = 0.32

    for ax, med, ylabel, fmt in [
        (ax_c, med_cost,  "Cost (USD)", "${:.2f}"),
        (ax_t, med_turns, "Turns",      "{:.0f}"),
    ]:
        bars_mcp = ax.bar(x - w/2, med["MCP"], w, color=C_MCP, edgecolor=C_AXIS,
                          linewidth=0.6, label="MCP", zorder=3)
        bars_cli = ax.bar(x + w/2, med["CLI"], w, color=C_CLI, edgecolor=C_AXIS,
                          linewidth=0.6, hatch=HATCH_CLI, label="CLI", zorder=3)
        ax.set_ylabel(ylabel)
        ax.set_ylim(0)
        ax.legend(frameon=True, framealpha=0.9, edgecolor="#cccccc", loc="upper left", fontsize=7)
        ax.yaxis.grid(True, zorder=0)
        ax.set_axisbelow(True)

        for bars in [bars_mcp, bars_cli]:
            for bar in bars:
                h = bar.get_height()
                ax.annotate(fmt.format(h),
                            xy=(bar.get_x() + bar.get_width()/2, h),
                            xytext=(0, 4), textcoords="offset points",
                            ha="center", va="bottom", fontsize=8)

    ax_t.set_xticks(x)
    ax_t.set_xticklabels([TASK_LABELS[t] for t in TASKS])
    fig.tight_layout(rect=[0, 0, 1, 0.94])
    save(fig, "chart1_median_cost_turns.png")

# ══════════════════════════════════════════════════════════════
# CHART 2 — Dot plot with median lines  (two panels: cost, turns)
# ══════════════════════════════════════════════════════════════
def chart2():
    fig, (ax_c, ax_t) = plt.subplots(1, 2, figsize=(7.5, 3.5))
    fig.suptitle("Run-Level Variance: MCP vs CLI", fontsize=13, fontweight="bold", y=1.02)

    cells = []
    for t in TASKS:
        for m in ["MCP", "CLI"]:
            cells.append(f"{t}-{m}")

    for ax, col, ylabel in [(ax_c, "total_cost_usd", "Cost (USD)"),
                             (ax_t, "num_turns", "Turns")]:
        for i, cell in enumerate(cells):
            t, m = cell.split("-")
            sub = df[(df["task"] == t) & (df["mode"] == m)]
            vals = sub[col].values
            med  = np.median(vals)
            marker = "o" if m == "MCP" else "s"
            color  = C_MCP if m == "MCP" else C_CLI
            ax.scatter([i]*len(vals), vals, marker=marker, s=40,
                       color=color, edgecolors=C_AXIS, linewidths=0.5, zorder=4)
            ax.plot([i - 0.25, i + 0.25], [med, med], color=C_RED,
                    linewidth=1.5, zorder=5)
            fmt = f"{med:.2f}" if col == "total_cost_usd" else f"{med:.0f}"
            ax.annotate(fmt, xy=(i, med), xytext=(5, 0),
                        textcoords="offset points", fontsize=7, color=C_RED,
                        va="center", ha="left")

        ax.set_xticks(range(len(cells)))
        ax.set_xticklabels(cells, fontsize=7.5, rotation=30, ha="right")
        ax.set_ylabel(ylabel)
        ax.set_axisbelow(True)

    # Manual legend
    from matplotlib.lines import Line2D
    handles = [
        Line2D([0],[0], marker="o", color="w", markerfacecolor=C_MCP,
               markeredgecolor=C_AXIS, markersize=6, label="MCP"),
        Line2D([0],[0], marker="s", color="w", markerfacecolor=C_CLI,
               markeredgecolor=C_AXIS, markersize=6, label="CLI"),
    ]
    ax_t.legend(handles=handles, frameon=True, framealpha=0.9,
                edgecolor="#cccccc", fontsize=7, loc="upper right")

    fig.tight_layout()
    save(fig, "chart2_dotplot_variance.png")

# ══════════════════════════════════════════════════════════════
# CHART 3 — Cache-Read/Turn vs Total Cost scatter
# ══════════════════════════════════════════════════════════════
def chart3():
    fig, ax = plt.subplots(figsize=(5, 4))
    ax.set_title("Cost Is Turn-Driven, Not Context-Size-Driven",
                 fontsize=12, fontweight="bold", pad=10)

    for _, row in df.iterrows():
        m = row["mode"]
        marker = "o" if m == "MCP" else "s"
        color  = C_MCP if m == "MCP" else C_CLI
        ax.scatter(row["cache_per_turn"] / 1000, row["total_cost_usd"],
                   marker=marker, s=55, color=color, edgecolors=C_AXIS,
                   linewidths=0.5, zorder=4)
        label = f"{row['task']}{row['rep']}"
        ax.annotate(label, (row["cache_per_turn"]/1000, row["total_cost_usd"]),
                    fontsize=6, xytext=(4, 3), textcoords="offset points",
                    color="#555555")

    ax.set_xlabel("Cache Reads per Turn (thousands)")
    ax.set_ylabel("Total Cost (USD)")
    ax.set_axisbelow(True)

    from matplotlib.lines import Line2D
    handles = [
        Line2D([0],[0], marker="o", color="w", markerfacecolor=C_MCP,
               markeredgecolor=C_AXIS, markersize=6, label="MCP"),
        Line2D([0],[0], marker="s", color="w", markerfacecolor=C_CLI,
               markeredgecolor=C_AXIS, markersize=6, label="CLI"),
    ]
    ax.legend(handles=handles, frameon=True, framealpha=0.9,
              edgecolor="#cccccc", fontsize=7, loc="upper left")

    fig.tight_layout()
    save(fig, "chart3_cacheread_vs_cost.png")

# ══════════════════════════════════════════════════════════════
# CHART 4 — Cost breakdown stacked bars
# ══════════════════════════════════════════════════════════════
def chart4():
    fig, ax = plt.subplots(figsize=(6, 3.5))
    ax.set_title("Cost Breakdown by Component", fontsize=12, fontweight="bold", pad=10)

    cells = []
    for t in TASKS:
        for m in ["MCP", "CLI"]:
            cells.append(f"{t}-{m}")

    components = ["cache_read_cost", "input_cache_cost", "sonnet_out_cost", "haiku_cost"]
    comp_labels = ["Cache Read", "Input + Cache Create", "Sonnet Output", "Haiku (subagent)"]
    # Grayscale fills from dark to light + hatching for distinction
    comp_colors  = ["#2c2c2c", "#666666", "#999999", "#cccccc"]
    comp_hatches = ["",        "...",     "\\\\\\",  "xxx"]

    x = np.arange(len(cells))
    bottoms = np.zeros(len(cells))

    for comp, label, color, hatch in zip(components, comp_labels, comp_colors, comp_hatches):
        vals = []
        for cell in cells:
            t, m = cell.split("-")
            sub = df[(df["task"] == t) & (df["mode"] == m)]
            vals.append(sub[comp].median())
        vals = np.array(vals)
        ax.bar(x, vals, bottom=bottoms, width=0.55, color=color, edgecolor=C_AXIS,
               linewidth=0.5, hatch=hatch, label=label, zorder=3)
        bottoms += vals

    # Total annotations
    for i, total in enumerate(bottoms):
        ax.annotate(f"${total:.2f}", xy=(i, total), xytext=(0, 4),
                    textcoords="offset points", ha="center", va="bottom", fontsize=7)

    ax.set_xticks(x)
    ax.set_xticklabels(cells, fontsize=8)
    ax.set_ylabel("Cost (USD)")
    ax.set_ylim(0)
    ax.legend(frameon=True, framealpha=0.9, edgecolor="#cccccc", fontsize=7,
              loc="upper left", ncol=2)
    ax.set_axisbelow(True)
    fig.tight_layout()
    save(fig, "chart4_cost_breakdown.png")

# ══════════════════════════════════════════════════════════════
# CHART 5 — Haiku subagent heatmap
# ══════════════════════════════════════════════════════════════
def chart5():
    fig, ax = plt.subplots(figsize=(5, 2.5))
    ax.set_title("Haiku Subagent Usage by Run", fontsize=12, fontweight="bold", pad=10)

    cells = []
    for t in TASKS:
        for m in ["MCP", "CLI"]:
            cells.append(f"{t}-{m}")

    reps = [1, 2, 3]
    grid = np.zeros((len(reps), len(cells)))

    for j, cell in enumerate(cells):
        t, m = cell.split("-")
        for i, r in enumerate(reps):
            sub = df[(df["task"] == t) & (df["mode"] == m) & (df["rep"] == r)]
            if len(sub) > 0 and sub.iloc[0]["haiku_input"] > 0:
                grid[i, j] = 1.0

    from matplotlib.colors import ListedColormap
    cmap_heatmap = ListedColormap(["#f0f0f0", "#4a4a4a"])
    ax.imshow(grid, cmap=cmap_heatmap, aspect="auto", vmin=0, vmax=1, interpolation="nearest")

    for i in range(len(reps)):
        for j in range(len(cells)):
            txt = "Y" if grid[i, j] > 0.5 else "-"
            color = "white" if grid[i, j] > 0.5 else "#555555"
            ax.text(j, i, txt, ha="center", va="center", fontsize=9,
                    fontweight="bold", color=color)

    ax.set_xticks(range(len(cells)))
    ax.set_xticklabels(cells, fontsize=8)
    ax.set_yticks(range(len(reps)))
    ax.set_yticklabels([f"Rep {r}" for r in reps], fontsize=8)

    # Thin grid lines between cells
    for x_pos in np.arange(-0.5, len(cells), 1):
        ax.axvline(x_pos, color="white", linewidth=1)
    for y_pos in np.arange(-0.5, len(reps), 1):
        ax.axhline(y_pos, color="white", linewidth=1)

    ax.tick_params(length=0)
    ax.grid(False)
    fig.tight_layout()
    save(fig, "chart5_haiku_heatmap.png")

# ══════════════════════════════════════════════════════════════
# CHART 6 — Cost vs interaction depth (line chart)
# ══════════════════════════════════════════════════════════════
def chart6():
    fig, ax = plt.subplots(figsize=(5, 3.5))
    ax.set_title("MCP Stays Flat; CLI Costs 3× More",
                 fontsize=12, fontweight="bold", pad=10)

    med = median_table("total_cost_usd").reindex(TASKS)
    x = np.arange(len(TASKS))

    ax.plot(x, med["MCP"], marker="o", color=C_MCP, linewidth=1.8,
            markersize=7, markeredgecolor=C_AXIS, markeredgewidth=0.5,
            label="MCP", zorder=4)
    ax.plot(x, med["CLI"], marker="s", color=C_CLI, linewidth=1.8,
            markersize=7, markeredgecolor=C_AXIS, markeredgewidth=0.5,
            label="CLI", zorder=4)

    for m, col in [("MCP", C_MCP), ("CLI", C_CLI)]:
        for i, t in enumerate(TASKS):
            v = med.loc[t, m]
            offset_y = -14 if m == "MCP" else 8
            ax.annotate(f"${v:.2f}", xy=(i, v), xytext=(0, offset_y),
                        textcoords="offset points", ha="center", fontsize=8,
                        color=col)

    ax.set_xticks(x)
    ax.set_xticklabels([TASK_LABELS[t] for t in TASKS])
    ax.set_ylabel("Median Cost (USD)")
    ax.set_ylim(0, 0.48)
    ax.set_xlim(-0.3, len(TASKS) - 0.5)
    ax.legend(frameon=True, framealpha=0.9, edgecolor="#cccccc", fontsize=7,
              loc="upper right")
    ax.set_axisbelow(True)
    fig.tight_layout()
    save(fig, "chart6_cost_vs_depth.png")

# ══════════════════════════════════════════════════════════════
# CHART 7 — Wall time grouped bars
# ══════════════════════════════════════════════════════════════
def chart7():
    fig, ax = plt.subplots(figsize=(5, 3.5))
    ax.set_title("Wall Time: MCP vs CLI", fontsize=12, fontweight="bold", pad=10)

    med = median_table("wall_sec").reindex(TASKS)
    x = np.arange(len(TASKS))
    w = 0.32

    bars_mcp = ax.bar(x - w/2, med["MCP"], w, color=C_MCP, edgecolor=C_AXIS,
                      linewidth=0.6, label="MCP", zorder=3)
    bars_cli = ax.bar(x + w/2, med["CLI"], w, color=C_CLI, edgecolor=C_AXIS,
                      linewidth=0.6, hatch=HATCH_CLI, label="CLI", zorder=3)

    for bars in [bars_mcp, bars_cli]:
        for bar in bars:
            h = bar.get_height()
            ax.annotate(f"{int(h)}s", xy=(bar.get_x() + bar.get_width()/2, h),
                        xytext=(0, 4), textcoords="offset points",
                        ha="center", va="bottom", fontsize=8, fontweight="bold")

    ax.set_xticks(x)
    ax.set_xticklabels([TASK_LABELS[t] for t in TASKS])
    ax.set_ylabel("Median Wall Time (seconds)")
    ax.set_ylim(0)
    ax.legend(frameon=True, framealpha=0.9, edgecolor="#cccccc", fontsize=7,
              loc="upper right")
    ax.set_axisbelow(True)
    fig.tight_layout()
    save(fig, "chart7_wall_time.png")

# ── run all ────────────────────────────────────────────────────
if __name__ == "__main__":
    print("Generating academic charts …")
    chart1()
    chart2()
    chart3()
    chart4()
    chart5()
    chart6()
    chart7()
    print(f"\nDone — 7 charts saved to {OUTDIR}")
