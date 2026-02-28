# Browser Automation Token Usage Experiment
## Playwright MCP (official) vs playwright-cli

**Model:** claude-sonnet-4-6
**Target:** OWASP Juice Shop @ http://localhost:3333
**Measurement:** Automated via `claude -p --output-format json` — fields: `total_cost_usd`, `duration_ms`, `num_turns`, `modelUsage.*`
**Runs:** 3 tasks × 2 approaches × 3 repetitions = **18 runs total**

---

## Session Isolation

Each `claude -p` call guarantees a clean state:

| Layer | playwright-mcp | playwright-cli |
|---|---|---|
| **Browser** | MCP server is a child process of `claude -p` — exits with it → fresh browser per run | `playwright-cli open` launches a fresh browser; `close` terminates it |
| **Cookies / localStorage** | Destroyed when browser process exits | Destroyed on `close` |
| **Juice Shop session** | JWT stored in browser localStorage only — no server-side session in Docker | Same |
| **Docker container** | Stateless (JWT-based auth, SQLite only stores accounts/orders) | Same |

No explicit teardown needed between runs.

---

## Threats to Validity

### Internal Validity
| Threat | Severity | Mitigation |
|---|---|---|
| LLM non-determinism | Medium | 3 reps per cell, report median |
| Skill prompt as fixed overhead | Medium | Accepted — reflects real-world cost of skill-based approach |
| **Prompt confounding** | Low | Both approaches use a parallel prefix: MCP → "Use the playwright MCP to:", CLI → "Use the playwright-cli skill to:". Prompts are otherwise identical. |
| Order effects | Medium | Randomized run order (see below) |
| Browser state carry-over | Low | Fresh `claude -p` process per run = fresh browser |
| Tool isolation violations | High | Fixed via `--allowedTools` + `--disallowedTools` per approach, `--disable-slash-commands` for MCP arm, `.mcp.json` hidden for CLI arm, post-run purity gate (aborts on any cross-arm tool use). **Verified: 0 violations across all 18 clean-run sessions.** (Contamination history archived in `archive/20260219-180511.zip`) |
| Image tokens vary by approach | Medium | Noted in analysis |
| Snapshot inlining vs disk | Medium | playwright-cli saves snapshots to disk; MCP inlines accessibility tree. CLI cache_read is ~4× higher than MCP in practice — see Snapshot Inlining Note below. |
| Success criterion coarseness | Low | Automated success detection uses keyword matching on the first 120 chars of the result (`result_snippet`). Subtle failures or verbose preambles could mask incorrect results. Cross-checked against full JSON logs during analysis. |

### External Validity
| Threat | Description |
|---|---|
| Single app | Only OWASP Juice Shop (Angular SPA, local) |
| Single model | Only claude-sonnet-4-6 |
| Only 3 tasks | Small sample, limited generalizability |
| Localhost | No network jitter — wall time not comparable to remote sites |

---

## Pre-Run Checklist

*Verified before clean re-run 2026-02-19.*

- [x] Juice Shop running on localhost:3333
- [x] playwright-cli installed globally (`playwright-cli --help`)
- [x] playwright-cli skill installed (`.claude/skills/playwright-cli/SKILL.md` present)
- [x] `dev-browser` plugin disabled (`settings.json: "dev-browser@dev-browser-marketplace": false`)
- [x] Run from external terminal (`unset CLAUDECODE` handled by script)

---

## Tasks

### Task A — SQL Injection Login Bypass

**Pentest relevance:** Tests classic authentication bypass via SQL injection. Validates whether the agent can execute a targeted exploit, not just navigate.

**Success criterion:** Result mentions bypass, logged in, injection, or success.

**Playwright MCP prompt:**
```
Use the playwright MCP to: Go to http://localhost:3333, navigate to the login page, and attempt to bypass authentication using SQL injection: enter the email ' OR true--' with any password. Take a screenshot showing the result and report whether the login was bypassed.
```

**playwright-cli prompt:**
```
Use the playwright-cli skill to: Go to http://localhost:3333, navigate to the login page, and attempt to bypass authentication using SQL injection: enter the email ' OR true--' with any password. Take a screenshot showing the result and report whether the login was bypassed.
```

---

### Task B — DOM XSS via Search Field

**Pentest relevance:** Cross-site scripting (OWASP A03). Juice Shop's search bar reflects unsanitized user input directly into the DOM. Verifying whether a payload executes requires a real browser — curl cannot demonstrate JavaScript execution, making this a genuinely browser-native pentest task.

**Success criterion:** Result mentions xss, iframe, reflected, executed, or alert.

**Playwright MCP prompt:**
```
Use the playwright MCP to: Go to http://localhost:3333, find the search field in the navigation bar, and enter the XSS payload: <iframe src="javascript:alert('xss')">. Take a screenshot of the result and report whether the payload was reflected or executed in the page.
```

**playwright-cli prompt:**
```
Use the playwright-cli skill to: Go to http://localhost:3333, find the search field in the navigation bar, and enter the XSS payload: <iframe src="javascript:alert('xss')">. Take a screenshot of the result and report whether the payload was reflected or executed in the page.
```

---

### Task C — JWT Token Extraction from localStorage

**Pentest relevance:** Cryptographic failures / token exposure (OWASP A02). After authentication, the JWT is stored in `localStorage`. Extracting and decoding it reveals user claims (ID, email, role) and exposes the token for session hijacking. `localStorage` is only accessible via JavaScript executed in a browser context — curl cannot reach it.

**Success criterion:** Result mentions token, jwt, role, email, or iss.

**Playwright MCP prompt:**
```
Use the playwright MCP to: Go to http://localhost:3333, log in with email admin@juice-sh.op and password admin123, then execute JavaScript to retrieve the value stored in localStorage under the key "token". Decode the JWT payload and report the claims you find (user ID, email, role).
```

**playwright-cli prompt:**
```
Use the playwright-cli skill to: Go to http://localhost:3333, log in with email admin@juice-sh.op and password admin123, then execute JavaScript to retrieve the value stored in localStorage under the key "token". Decode the JWT payload and report the claims you find (user ID, email, role).
```

---

## Randomized Run Order

To mitigate order effects, runs are shuffled across all tasks and approaches:

| # | Run ID | Approach | Task |
|---|---|---|---|
| 1 | C-PC-2 | playwright-cli | C |
| 2 | A-MCP-1 | playwright-mcp | A |
| 3 | B-PC-1 | playwright-cli | B |
| 4 | C-MCP-3 | playwright-mcp | C |
| 5 | A-PC-2 | playwright-cli | A |
| 6 | B-MCP-1 | playwright-mcp | B |
| 7 | C-PC-1 | playwright-cli | C |
| 8 | A-MCP-2 | playwright-mcp | A |
| 9 | B-PC-3 | playwright-cli | B |
| 10 | C-MCP-1 | playwright-mcp | C |
| 11 | A-PC-3 | playwright-cli | A |
| 12 | B-MCP-2 | playwright-mcp | B |
| 13 | C-PC-3 | playwright-cli | C |
| 14 | A-MCP-3 | playwright-mcp | A |
| 15 | B-PC-2 | playwright-cli | B |
| 16 | C-MCP-2 | playwright-mcp | C |
| 17 | A-PC-1 | playwright-cli | A |
| 18 | B-MCP-3 | playwright-mcp | B |

---

## How to Execute Runs

All runs are fully automated. From an external terminal:

```bash
cd /path/to/project-root
./scripts/run_experiment.sh
```

The script handles: fresh session per run, timing, JSON parsing, CSV writing, and cooldown between runs.

**Success criterion:** Evaluated manually during post-hoc analysis from `result_snippet` (first 120 chars of the result text, stored in `results.csv`) and the full result in each run's JSON log.

---

## Analysis Plan — **Completed** (see `analysis/analysis-report.md`)

| Pre-registered item | Status | Report location |
|---|---|---|
| Median token cost per cell (approach × task) | ✓ Done | §4.2, Finding 1 |
| Median output tokens per cell | ✓ Done | Finding 4 |
| Delta: playwright-mcp − playwright-cli | ✓ Done | §4.3 |
| Ratio: playwright-mcp / playwright-cli | ✓ Done | §4.3 |
| Context pressure: `cache_read_tokens / num_turns` per cell | ✓ Done | Finding 2 |
| Wall time comparison (median per cell) | ✓ Done | Finding 6 |
| Does approach advantage vary by task type? | ✓ Done | §4.3, Conclusion |

### Cache Warm-Up Note

Each `claude -p` call is an independent process — the prompt cache does not persist across
sessions. Within a session, turn 1 pays `cache_creation` cost; turns 2+ pay `cache_read`
cost.

**Observed in practice:** `cache_creation` values do not show a systematic rep=1 > rep=2+
pattern across cells. Example (Task C, playwright-mcp, clean re-run 2026-02-19):

| Rep | cache_creation | cache_read |
|---|---|---|
| 1 | 5,868 | 104,432 |
| 2 | 6,055 | 120,107 |
| 3 | 6,337 | 120,965 |

Each independent session builds its own cache from scratch, so rep order does not predict
warm-up overhead — the variation across reps is driven by non-deterministic LLM routing,
not session ordering. The primary cost metric (total_cost_usd) is therefore reported as a
median across all 3 reps per cell without cold/warm separation.

### Snapshot Inlining Note

playwright-mcp inlines the full accessibility tree after each tool call (DOM enters context).
playwright-cli saves snapshots as YAML files to `.playwright-cli/` — only the file path is
returned in Bash output.

**Actual experimental data (Task B, DOM XSS — 3 reps each, clean re-run 2026-02-19):**

| Metric | playwright-mcp | playwright-cli | Ratio |
|---|---|---|---|
| `cache_read_tokens` (median) | 107,675 | 436,664 | 4.06× more for CLI |
| `num_turns` (median) | 7 | 22 | 3.14× more for CLI |
| `cache_read / turn` | ~15,382 | ~19,848 | ~1.3× more per turn for CLI |

The per-turn context pressure is moderately higher for CLI (~20K vs ~15K tokens/turn).
The total context gap is primarily driven by turn count (3.14×), with a secondary
contribution from larger per-turn context.
Root cause: playwright-cli's SKILL.md dominates cached context, and the snapshot
read-back cycle (write → read → act) adds extra turns per browser action.

*Note: an earlier contaminated run showed CLI median 864,715 / MCP median 169,779 (5.1×
ratio). The lower values here reflect pure CLI execution after tool isolation was enforced.*
