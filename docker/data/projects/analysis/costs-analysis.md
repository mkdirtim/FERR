# Cost Summary (Documented From Local Artifacts)

This file consolidates all **documented** costs found in benchmark artifacts under `/playground/scans` (mounted from this project workspace).

## 1) Totals Table

| Agent / Mode | Badstore (USD) | Juiceshop (USD) | Total (USD) | Scope / Caveat |
|---|---:|---:|---:|---|
| Strix (primary logs) | 3.7267 | 4.4152 | **8.1419** | Only run `2/2` costs are present in captured TUI logs |
| PentestGPT (primary `pentestgpt-run-*.log`) | 14.9845 | 12.4639 | **27.4484** | 10 run logs (5 per target) |
| CAI (primary `cai-run-*.log`) | 0.6662 | 0.2835 | **0.9497** | `juiceshop/cai-run-5.log` has no `Session:` cost line |
| PentestGPT (`archive-no-restart.tar.gz`) | 5.8699 | 9.7338 | **15.6037** | Separate benchmark mode |
| CAI (`bugstalled-cai-run-*.log`) | 0.2230 | 0.1103 | **0.3333** | Separate bugstalled set |

### Aggregates

- Primary sets total (Strix + PentestGPT + CAI primary): **36.5400 USD**
- All documented sets above: **52.4770 USD**

---

## 2) Method (Reproducible)

- Strix: used final TUI summary `Cost` values in `strix-*.txt`.
- PentestGPT: used `[DONE] ... Cost: $X.XXXX` lines in each run log.
- CAI: used the **last** `Session: $X.XXXX` line in each run log (no `[DONE] Cost` format).
- `archive-no-restart` values were extracted from log files inside the tar archives.

---

## 3) Source References (Per Value)

### 3.1 Strix (primary logs)

- `/playground/scans/badstore/strix/badstore-strix-run-2-output.log:956` -> `$3.7267`
- `/playground/scans/juiceshop/strix/juiceshop-strix-run-2-output.log:2570` -> `$4.4152`

### 3.2 PentestGPT (primary logs)

- `/playground/scans/badstore/pentestgpt/pentestgpt-run-1.log:340` -> `$3.4961`
- `/playground/scans/badstore/pentestgpt/pentestgpt-run-2.log:370` -> `$2.7928`
- `/playground/scans/badstore/pentestgpt/pentestgpt-run-3.log:370` -> `$3.3373`
- `/playground/scans/badstore/pentestgpt/pentestgpt-run-4.log:381` -> `$2.9419`
- `/playground/scans/badstore/pentestgpt/pentestgpt-run-5.log:365` -> `$2.4164`
- `/playground/scans/juiceshop/pentestgpt/pentestgpt-run-1.log:400` -> `$2.3703`
- `/playground/scans/juiceshop/pentestgpt/pentestgpt-run-2.log:408` -> `$2.5173`
- `/playground/scans/juiceshop/pentestgpt/pentestgpt-run-3.log:512` -> `$2.9805`
- `/playground/scans/juiceshop/pentestgpt/pentestgpt-run-4.log:246` -> `$2.3229`
- `/playground/scans/juiceshop/pentestgpt/pentestgpt-run-5.log:224` -> `$2.2729`

### 3.3 PentestGPT archive-no-restart (tar-contained logs)

Source archives:
- `/playground/scans/badstore/pentestgpt/archive-no-restart.tar.gz`
- `/playground/scans/juiceshop/pentestgpt/archive-no-restart.tar.gz`

Contained log references used:
- `pentestgpt-run-1.log:291` -> `$2.8901` (badstore archive)
- `pentestgpt-run-2.log:276` -> `$2.9798` (badstore archive)
- `pentestgpt-run-1.log:293` -> `$1.5122` (juiceshop archive)
- `pentestgpt-run-2.log:252` -> `$2.2869` (juiceshop archive)
- `pentestgpt-run-3.log:237` -> `$1.9613` (juiceshop archive)
- `pentestgpt-run-4.log:433` -> `$1.8202` (juiceshop archive)
- `pentestgpt-run-5.log:400` -> `$2.1532` (juiceshop archive)

### 3.4 CAI (primary logs; last `Session:` value per run)

- `/playground/scans/badstore/cai/cai-run-1.log:446` -> `$0.0839`
- `/playground/scans/badstore/cai/cai-run-2.log:587` -> `$0.1234`
- `/playground/scans/badstore/cai/cai-run-3.log:741` -> `$0.2855`
- `/playground/scans/badstore/cai/cai-run-4.log:428` -> `$0.0724`
- `/playground/scans/badstore/cai/cai-run-5.log:440` -> `$0.1010`
- `/playground/scans/juiceshop/cai/cai-run-1.log:385` -> `$0.0759`
- `/playground/scans/juiceshop/cai/cai-run-2.log:243` -> `$0.0366`
- `/playground/scans/juiceshop/cai/cai-run-3.log:325` -> `$0.0733`
- `/playground/scans/juiceshop/cai/cai-run-4.log:436` -> `$0.0977`
- `/playground/scans/juiceshop/cai/cai-run-5.log` -> **no `Session:` cost line** (rate-limit/stall)

### 3.5 CAI bugstalled logs (last `Session:` value per run)

- `/playground/scans/badstore/cai/bugstalled-cai-run-1.log:468` -> `$0.1423`
- `/playground/scans/badstore/cai/bugstalled-cai-run-2.log:362` -> `$0.0362`
- `/playground/scans/badstore/cai/bugstalled-cai-run-3.log:248` -> `$0.0192`
- `/playground/scans/badstore/cai/bugstalled-cai-run-4.log:216` -> `$0.0127`
- `/playground/scans/badstore/cai/bugstalled-cai-run-5.log:258` -> `$0.0126`
- `/playground/scans/juiceshop/cai/bugstalled-cai-run-1.log:372` -> `$0.0206`
- `/playground/scans/juiceshop/cai/bugstalled-cai-run-2.log:307` -> `$0.0204`
- `/playground/scans/juiceshop/cai/bugstalled-cai-run-3.log:270` -> `$0.0203`
- `/playground/scans/juiceshop/cai/bugstalled-cai-run-4.log:323` -> `$0.0355`
- `/playground/scans/juiceshop/cai/bugstalled-cai-run-5.log:225` -> `$0.0135`

---

## 4) Integrity Notes

- This document reports **artifact-observed** costs only.
- It is not a provider invoice replacement; dashboard billing can be higher if additional sessions/keys/projects/environments were billed outside these artifacts.

---

## 5) Reconciliation With Provider Usage CSV

CSV used:
- `/Users/mkdirtim/Downloads/completions_usage_2026-01-17_2026-02-16.csv`

### 5.1 Why Exact Run Mapping Is Not Possible

- The CSV is **daily aggregated usage**, not run/session-level accounting.
- It does not contain Strix/PentestGPT/CAI run IDs or benchmark artifact IDs.
- Therefore, mapping can only be done by day (UTC), not by individual run with strict proof.

### 5.2 CSV-Implied Cost (Token-Based Estimate)

Using GPT-5.2 pricing (`$1.75 / 1M` uncached input, `$0.175 / 1M` cached input, `$14 / 1M` output):

- 2026-02-12: **$40.7063**
- 2026-02-13: **$136.6928**
- Total: **$177.3991**

### 5.3 Artifact-Mapped Cost By Day (Best-Effort)

- 2026-02-12: PentestGPT primary + PentestGPT archive-no-restart -> **$43.0521**
- 2026-02-13: CAI (primary + bugstalled) + Strix known costs -> **$9.4249**

### 5.4 Day-Level Delta (CSV - Mapped)

| Day (UTC) | CSV-Implied (USD) | Artifact-Mapped (USD) | Delta (USD) |
|---|---:|---:|---:|
| 2026-02-12 | 40.7063 | 43.0521 | -2.3458 |
| 2026-02-13 | 136.6928 | 9.4249 | 127.2679 |
| Total | 177.3991 | 52.4770 | **124.9221** |

Interpretation:
- 2026-02-12 is reasonably close (small estimation/tier/accounting differences are plausible).
- 2026-02-13 has a large **unmapped** cost block, indicating substantial usage not represented in the archived benchmark artifacts.
