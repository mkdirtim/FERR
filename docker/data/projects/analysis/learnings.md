# Cross-Agent Learnings for OpenHack

> **Context:** This document synthesizes findings from three project analyses
> (`stalled-cai-project-analysis.md`, `pentestgpt-project-analysis.md`,
> `strix-project-analysis.md`), ten benchmark results files, three cross-target
> analysis files, and the benchmark summary into actionable learnings for
> OpenHack. It adapts the `learnings-template.md` structure to a comparative
> multi-agent format, covering all three LLM-driven pentesting agents evaluated
> in this thesis.

| Field | CAI | PentestGPT | Strix |
|-------|-----|------------|-------|
| **Version** | 0.5.10 | 1.0.0 | 0.7.0 |
| **Repository** | https://github.com/aliasrobotics/cai | https://github.com/GreyDGL/PentestGPT | https://github.com/usestrix/strix |
| **Framework** | Custom Python SDK (OpenAI Agents-style) | Claude Code SDK wrapper | Custom Python + Docker sandbox + tool server |
| **Model** | GPT-5.2 | Claude Sonnet 4.5 | GPT-5 |
| **License** | MIT + proprietary | MIT | Apache-2.0 |
| **Date Reviewed** | 2026-02-13 | 2026-02-12 | 2026-02-13 |

> **Inputs:**
>
> | Input | Template | Status |
> |-------|----------|--------|
> | CAI codebase analysis | `stalled-cai-project-analysis.md` | done |
> | PentestGPT codebase analysis | `pentestgpt-project-analysis.md` | done |
> | Strix codebase analysis | `strix-project-analysis.md` | done |
> | Benchmark: CAI × Juice Shop + BadStore | `cai-juiceshop-results.md`, `cai-badstore-results.md` | done |
> | Benchmark: PentestGPT × Juice Shop + BadStore | `pentestgpt-juiceshop-results.md`, `pentestgpt-badstore-results.md` | done |
> | Benchmark: Strix × Juice Shop + BadStore | `strix-juiceshop-results.md`, `strix-badstore-results.md` | done |
> | Cross-target analyses | `cai-analysis.md`, `pentestgpt-analysis.md`, `strix-analysis.md` | done |
> | Benchmark summary | `summary.md` | done |
>
> **Workflow:** Read each agent's project analysis for design intent, then
> compare with actual benchmark behavior to identify gaps, surprises, and
> patterns worth adopting.

---

## 1. Design vs. Observed Behavior

### 1a. Agent Loop

**CAI:**
- **Designed:** Interactive REPL with SDK Runner loop — model → tool calls/handoffs → rerun until final output. Supports parallel execution (`CAI_PARALLEL`), agent handoffs, and streaming/non-streaming modes (`cai/src/cai/cli.py:424`, `cai/src/cai/sdk/agents/run.py:145`).
- **Observed:** Agent executes 5–17 tool calls per run (mean 8.2 post-fix) in a single recon pass, then writes a report and terminates. Parallel mode, handoffs, and multi-turn interaction were never triggered by the benchmark harness. The only observed multi-agent activation was `[P1]` CTF sub-agent in BadStore Run 2 — 1 of 20 runs (5%).
- **Discrepancies:** The designed loop supports deep iterative exploitation, but the benchmark prompt ("Write findings to /tmp/report.md") and model behavior produce a single-pass recon-then-report pattern. Budget utilization is 5–17% of the configured 100-turn limit. The framework's iterative depth potential is architecturally present but behaviorally dormant.

**PentestGPT:**
- **Designed:** Event-driven streaming loop — backend streams text/tool events, controller tracks state and flags, UI renders. Supports pause/resume/inject and session persistence (`PentestGPT/pentestgpt/core/controller.py:179`, `PentestGPT/pentestgpt/core/backend.py:78`).
- **Observed:** Agent runs autonomously for 83–168 tool calls per run (mean 113.3), following a consistent pattern: recon → exploitation → self-termination. No pause/resume or user injection events occurred in benchmark runs. Session persistence functioned correctly (JSON files created per run).
- **Discrepancies:** The designed HITL capabilities (pause/resume/inject) were not exercised. More critically, the agent self-terminates after exploiting recall-recognized vulnerabilities, using only 28–56% of the 300-iteration budget. The controller does not enforce continued exploration.

**Strix:**
- **Designed:** Multi-agent graph with specialized subagents, Kali sandbox via tool-server, Playwright browser, Caido proxy, structured finish/report tools. Explicit iteration limits with warning injection near budget ceiling (`strix/strix/agents/base_agent.py:149`, `strix/strix/tools/executor.py:313`).
- **Observed:** Agent executes extended assessment sessions (~45–60 min), producing 6–14 validated vulnerabilities per run. Multi-tool integration works as designed: terminal, browser, proxy, Python, and vulnerability reporting tools all activated across runs. Report quality is consistently professional-grade.
- **Discrepancies:** Minimal. Strix's observed behavior most closely matches its design intent. The primary gap is the absence of OS-level exploitation (no `sqlmap --os-shell`) despite full Kali toolkit availability — a tool selection limitation rather than an architectural failure.

### 1b. Tool Usage

| Aspect | CAI | PentestGPT | Strix |
|--------|-----|------------|-------|
| **Available tools** | `generic_linux_command`, `execute_code`, `web_request_framework`, `js_surface_mapper`, MCP, full Kali toolset | Claude Code tools (bash), full Kali toolset (sqlmap, gobuster, nmap, hashcat, mysql, nikto, ffuf, hydra) | `terminal_execute`, `python_action`, `browser_action`, proxy tools, file editing, `create_vulnerability_report`, agent graph tools, `web_search` |
| **Actually used** | curl (69.5%), cat/grep (17.1%), web_request_framework (3.7%), js_surface_mapper (1.2%), execute_code (1.2%). **Zero Kali tools.** | curl (63%), sqlmap (14%), echo (4%), gobuster (3%), nmap (1%), hashcat (<1%), mysql (<1%) | terminal, python (34 PoCs), browser (5 XSS), proxy (530–3362 requests), vulnerability reporter (34 reports), finish_scan |
| **Tool selection quality** | Poor. Ignores all specialized security tools despite running in Kali container. | Good on BadStore (appropriate sqlmap + multi-tool). Poor on Juice Shop (80% curl, no variation). | Good to excellent. Appropriate tool selection per vulnerability type. Browser used only for client-side verification, not wasteful general navigation. |

### 1c. Phase Transitions

| Aspect | CAI | PentestGPT | Strix |
|--------|-----|------------|-------|
| **Designed transitions** | LLM-decided via prompt guidance; explicit tool behavior policies and handoffs | LLM-decided; no programmatic phase enforcement | LLM-decided with prompt-directed workflow; subagent delegation for validation |
| **Observed transitions** | Binary: recon → report (Juice Shop) or recon → exploitation → report (60% BadStore). No iterative hypothesis-test cycles. | Consistent: recon → exploitation → self-termination. Nearly identical attack sequences across Juice Shop runs (training data replay). | Consistent: extended recon (~20–37 min) → exploitation waves → browser verification → report. Finding rate of 1 vuln per 2.8–5.6 min during exploitation. |
| **Efficiency** | Low. Premature reporting wastes 83–95% of turn budget. On Juice Shop, 22+ discovered endpoints were never probed. | Moderate. 28–56% budget utilization. Exploitation is genuine but ceiling is set by model recall rather than tool exhaustion. | High. Extended recon correlates with more findings (JS Run 2: 37 min recon → 14 vulns vs. Run 1: 21 min → 7 vulns). |

### 1d. Termination Behavior

| Aspect | CAI | PentestGPT | Strix |
|--------|-----|------------|-------|
| **Designed stop conditions** | Max turns (100), price limit, guardrail tripwire, keyboard interrupt, /exit | Backend stream completion, max attempts (3 retries in non-interactive), keyboard interrupt, external timeout | finish_scan tool, max iterations (300), user stop (TUI), SIGINT/SIGTERM, unrecoverable error |
| **Actual stop reason** | Self-termination after report writing (100% of productive runs). Mean 8.2 tool calls of 100 budget. | Self-termination after completing recall-recognized attacks. Mean 113.3 tool calls of 300 budget. | finish_scan invocation after structured reporting. Duration-limited (~45–60 min) rather than iteration-limited. |

> **Adopt for OpenHack?** Yes — three specific patterns:
> 1. **Strix's structured finish tool** — forces the agent to produce required report sections before terminating. Prevents premature abandonment observed in CAI.
> 2. **Iteration-limit warning injection** (Strix `strix/strix/agents/state.py:94`) — reminds the agent of remaining budget near ceiling. CAI and PentestGPT both self-terminate far below budget without awareness.
> 3. **Wrapper retry policy** (PentestGPT) — non-interactive wrapper retries if no flags/findings found. Simple reliability gain for autonomous runs.

---

## 2. Empirical Execution Analysis

### 2a. Observed Execution Traces (representative runs)

**CAI — BadStore Run 3 (capability ceiling, 17 tool calls):**

```
[T+00:00] INIT    — loaded config, target=http://badstore:80
[T+00:05] RECON   — curl homepage → HTML analysis
[T+00:15] RECON   — curl /cgi-bin/badstore.cgi → CGI endpoint identified
[T+00:30] RECON   — grep HTML for hidden form fields → role=U discovered
[T+01:00] EXPLOIT — curl POST with role=A → admin account created (privesc)
[T+01:30] EXPLOIT — curl admin panel → supplier portal, admin dashboard confirmed
[T+02:00] POST    — python3 -c base64.b64decode(SSOid) → email:hash:name:role
[T+02:30] REPORT  — cat > /tmp/report.md (3 findings: SQLi, privesc, session)
[T+03:00] STOP    — model returns final output, session ends
```

**PentestGPT — BadStore Run 1 (deepest exploitation, 128 tool calls, 12m 56s):**

```
[T+00:00] INIT    — loaded config, target=http://badstore:80
[T+00:30] RECON   — nmap scan, curl homepage, gobuster directory enum
[T+02:00] EXPLOIT — sqlmap --dbs → MySQL databases enumerated
[T+04:00] EXPLOIT — sqlmap --dump → 682 users, 21 orders with PANs
[T+06:00] EXPLOIT — sqlmap --os-shell → operating system shell access
[T+08:00] POST    — webshell upload via supplier portal (PHP + Perl)
[T+10:00] POST    — cookie forgery → admin SSOid generated
[T+12:00] REPORT  — walkthrough narrative + flag submissions (2 hashes)
[T+12:56] STOP    — backend stream ends, controller finalizes
```

**Strix — Juice Shop Run 2 (most findings, 14 vulns, ~55 min):**

```
[T+00:00] INIT    — sandbox created, target=http://juiceshop:3000
[T+02:00] RECON   — terminal: curl, endpoint enumeration, technology fingerprint
[T+10:00] RECON   — proxy: 3362+ requests captured via Caido
[T+20:00] RECON   — file analysis, API endpoint mapping
[T+37:00] EXPLOIT — vuln-0004: SQLi login auth bypass (CVSS 9.1)
[T+38:00] EXPLOIT — vuln-0005: SQLi product search DB enumeration (CVSS 10.0)
[T+40:00] EXPLOIT — vuln-0007: JWT alg=none privilege escalation (CVSS 9.4)
[T+42:00] EXPLOIT — vuln-0011: mass assignment admin registration (CVSS 9.8)
[T+44:00] EXPLOIT — vuln-0014: DOM XSS via browser (CVSS 9.6)
[T+48:00] EXPLOIT — 9 additional vulns (info disclosure, misconfig, BOLA/IDOR)
[T+53:00] REPORT  — create_vulnerability_report × 14, finish_scan
[T+55:00] STOP    — finish_scan with executive summary
```

### 2b. Time-per-Phase Distribution

| Phase | CAI (post-fix) | PentestGPT | Strix |
|-------|---------------|------------|-------|
| Initialization | <5% (~1 call) | <3% (nmap + initial curl) | ~5% (sandbox + initial recon) |
| Reconnaissance | 55–65% (curl + web framework) | 15–25% (nmap, gobuster, initial curl) | 40–55% (~20–37 min) |
| Exploitation | 0% (JS) / 24% (BS exploit runs) | 40–55% (sqlmap, curl exploits) | 25–35% (payload construction + verification) |
| Post-Exploitation | 0% | 10–20% (webshell, hash cracking, DB dump) | 5–10% (subagent validation, browser XSS) |
| Reporting | 15–20% (report.md writing) | 15–25% (walkthrough narrative) | 5–10% (structured create_vulnerability_report) |
| **Total Tool Calls** | **5–17** | **83–168** | **N/A (34 reports + proxy traffic)** |

### 2c. Evidence Quality per Finding

| Agent | Evidence Type | Reproducible? | Severity Classification | Confidence Level |
|-------|--------------|---------------|------------------------|-----------------|
| CAI | curl commands + plaintext report in `/tmp/report.md` | Partially — commands documented in logs, no structured PoC | Informal (prompt-based labels) | Medium-low: passive findings are verifiable; exploitation claims require log review |
| PentestGPT | Tool execution logs + `[FLAG]` submissions + session JSON | Yes for BadStore (sqlmap commands reproduced); No for Juice Shop flags (0% verified, 10 fabricated) | None (no CVSS, no OWASP mapping) | High for BadStore exploitation artifacts; Low for Juice Shop flags |
| Strix | Executable Python PoCs (34 total) + CVSS 3.1 vectors + proxy request IDs + browser screenshots | Not independently verified but structurally reproducible | CVSS 3.1 (tool-validated vector format, self-assigned severity) | High: structured evidence with multiple corroborating sources |

---

## 3. Reconnaissance Effectiveness

| Aspect | CAI | PentestGPT | Strix |
|--------|-----|------------|-------|
| **Initial steps** | curl homepage → follow links → web_request_framework headers | nmap port scan → curl homepage → gobuster directory enum | terminal HTTP requests → proxy traffic capture → endpoint mapping |
| **Endpoint coverage** | JS: 22+ endpoints (js_surface_mapper Run 3); BS: 5–8 endpoints (curl) | JS: known endpoints immediately navigated; BS: gobuster + sqlmap-discovered | JS: extensive (3362+ proxy requests Run 2); BS: focused (~530 requests) |
| **Technology fingerprinting** | JS: identified Express/Node.js; BS: identified Apache/CGI correctly | JS: known (recall); BS: identified MySQL/CGI (sqlmap + recall) | JS: comprehensive (identified Angular, SQLite, Express, JWT); BS: identified Apache/CGI/MySQL |
| **Training data dependency** | Low — fails to exploit well-known JS vulns; uses methodology-driven grep for BS hidden fields | High (JS: immediate known endpoint navigation); Moderate (BS: sqlmap supplements recall) | Moderate — known vulns found first but with novel PoCs and genuine multi-step exploitation |

> **Adopt for OpenHack?** Yes:
> - **CAI's `js_surface_mapper`** — automated JS analysis discovered 22+ endpoints in one call. No other agent has equivalent capability. OpenHack should incorporate automated client-side endpoint extraction.
> - **Strix's proxy integration** — Caido proxy provides verifiable traffic-level evidence and enables passive endpoint discovery during active testing. The 3362-request corpus from JS Run 2 demonstrates thorough coverage.
> - **PentestGPT's gobuster usage** — systematic directory enumeration is valuable for legacy targets where client-side JS analysis is less applicable.

---

## 4. Exploitation Effectiveness

### 4a. Vulnerability Detection Quality

| Metric | CAI | PentestGPT | Strix |
|--------|-----|------------|-------|
| **Categories attempted** | JS: 2/14; BS: 6/14 | JS: 9/14; BS: 10/14 | JS: 10/14; BS: 12+/14 |
| **Categories exploited** | JS: 0 (info disclosure only); BS: 4 (SQLi, XSS, privesc, session) | JS: 9 (real exploits, 0 flags); BS: 10 | JS: 10 validated; BS: 12+ validated |
| **False positives** | Low — findings are passive and verifiable from logs | Moderate — Juice Shop self-reports 10–14 "solved" challenges with 0 verified; Run 5 fabricated 10 flags | Low — CVSS vector validation + PoC requirement + deduplicate detection reduce false positives |
| **False negatives** | High — major categories undetected on both targets (IDOR, file upload, directory traversal, injection) | Moderate — 3 categories missed (XSS, CSRF) due to no browser | Low — 13/~16 categories covered; only CSRF and non-SQL injection missed |

### 4b. Attack Chaining

| Agent | Multi-step Attacks | Deepest Chain |
|-------|-------------------|---------------|
| CAI | BS Run 3 only: form grep → hidden field → role tampering → admin → supplier → cookie decode (6 steps) | 6-step privilege escalation chain (Run 3) — unique mass assignment finding |
| PentestGPT | BS all runs: SQLi → DB dump → password cracking → OS shell → webshell → cookie forgery | OS-level shell + webshell deployment + full DB exfiltration — deepest single-target compromise |
| Strix | BS both runs: SQLi → cookie reverse-engineering → offline admin impersonation + independent business logic chain | Session forgery as architectural analysis — independent of SQLi path |

### 4c. Browser vs. CLI Impact

| Capability | CAI | PentestGPT | Strix |
|-----------|-----|------------|-------|
| **Browser vulns found** | 0 | 0 (curl-only XSS attempts on BS) | 5 (2 DOM XSS on JS, 1 reflected + 2 stored XSS on BS) |
| **Vulns missed due to CLI-only** | All XSS, CSRF, DOM-based, client-side logic | All XSS (verified), CSRF, DOM-based | N/A — browser-enabled |
| **Attack surface coverage** | ~80–85% (HTTP-only surface) | ~80–85% (HTTP-only surface) | ~100% (HTTP + client-side) |

> **Adopt for OpenHack?** Yes — critical findings:
> 1. **Browser is mandatory.** 5 XSS findings exclusively from Strix establish browser capability as a binary threshold. OpenHack must include Playwright or equivalent headless browser.
> 2. **OS-level exploitation is model/prompt driven.** PentestGPT's 4/5 `--os-shell` success rate demonstrates that depth depends on model behavior, not just tool availability (Strix has sqlmap but never uses `--os-shell`).
> 3. **Multi-step attack chains are rare but high-value.** CAI's Run 3 privilege escalation (1/20 runs) and Strix's session forgery (2/2 BadStore runs) show that architectural analysis capability varies dramatically by agent design.

---

## 5. Reporting Quality

| Aspect | CAI | PentestGPT | Strix |
|--------|-----|------------|-------|
| **Output quality** | Plaintext `/tmp/report.md`; useful for quick triage but lacks structure | Narrative walkthrough in stream; session JSON with flags/cost/status | Markdown report + per-vuln markdown + CSV index + executable PoCs; approaching professional pentest quality |
| **Severity accuracy** | Informal labels in prompt guidance; no systematic scoring | No severity classification (no CVSS, no OWASP mapping) | CVSS 3.1 with tool-validated vectors; self-assigned but structurally sound (mean ~8.7) |
| **Evidence quality** | curl commands visible in logs; report itself is summary-level | Tool execution logs provide full reproduction steps; BadStore artifacts (sqlmap output, webshells) are strong evidence | 34 executable Python PoCs (25–90 lines each), proxy request IDs, browser screenshots for XSS |
| **Report overhead** | 9–15% of tool calls spent on report writing | 15–25% of tool calls on reporting | 5–10% (structured tool call, not free-form writing) |

> **Adopt for OpenHack?** Yes — adopt Strix's reporting model:
> 1. **Structured vulnerability reports** with required fields (title, description, CVSS, PoC code, remediation). This is enforced by Strix's `create_vulnerability_report` tool with field validation and CVSS vector checking.
> 2. **Executable PoC requirement** eliminates unverifiable claims. PentestGPT's 0% flag verification rate and CAI's passive-only findings on Juice Shop demonstrate the cost of unstructured reporting.
> 3. **CSV vulnerability index** enables programmatic comparison and thesis-level data analysis.

---

## 6. What Worked Well

**L1. Strix's sandbox + tool-server architecture**
Separating the LLM orchestrator (host) from tool execution (Kali container) via an authenticated HTTP tool-server creates a clean trust boundary. All 4 Strix runs completed successfully with consistent behavior. The architecture enables reproducible, isolated assessments and prevents tool execution from affecting the orchestrator.
*Evidence: 100% completion rate, consistent output quality across 4 runs (`strix/strix/runtime/docker_runtime.py:245`, `strix/strix/runtime/tool_server.py:86`).*

**L2. PentestGPT's Docker-first reproducibility**
Scripted installation (`make install && make config && make connect`), pre-installed Kali toolset, and session persistence enable reliable reproduction. All 10 PentestGPT runs completed with 0 crashes or rate limits — the most reliable agent in the benchmark.
*Evidence: 100% completion rate across 10 runs, consistent Docker environment (`PentestGPT/README.md:88`, `PentestGPT/Dockerfile:4`).*

**L3. CAI's extensibility framework**
MCP integration, dynamic agent factory cloning, `@function_tool` decorator, handoff patterns, and `tool_use_behavior` policies create the most extensible agent substrate tested. Although most features were unused in benchmarks, the architecture enables rapid customization.
*Evidence: `cai/src/cai/sdk/agents/agent.py:232`, `cai/src/cai/sdk/agents/tool.py:182`, `cai/src/cai/agents/__init__.py:195`. Five distinct agent types available via registry.*

**L4. PentestGPT's event-bus architecture**
Clean decoupling of UI, orchestration, and backend via typed events (`TEXT`, `TOOL_START`, `RESULT`, `FLAG_FOUND`) simplifies observability and enables independent interface development. The event types provide structured runtime telemetry.
*Evidence: `PentestGPT/pentestgpt/core/events.py:14`, `PentestGPT/pentestgpt/core/controller.py:179`.*

**L5. Strix's structured finish contract**
The `finish_scan` tool enforces required report sections before termination, preventing premature abandonment. Combined with iteration-limit warnings, this produces complete assessments in 100% of runs — unlike CAI (mean 8.2% budget utilization) and PentestGPT (28–56% utilization).
*Evidence: `strix/strix/tools/finish/finish_actions.py:86`, `strix/strix/agents/base_agent.py:183`. 3/4 runs produced executive reports in the archive; all 4 runs produced per-vulnerability breakdowns.*

**L6. CAI's cost controls**
Proactive and streaming-time price limit checks, per-turn cost tracking, and preflight budget validation provide the strongest cost governance tested. CAI's total benchmark cost ($0.89 for 20 runs) reflects both cheap model usage and active budget enforcement.
*Evidence: `cai/src/cai/util.py:416`, `cai/src/cai/sdk/agents/models/openai_chatcompletions.py:686`.*

**L7. Strix's vulnerability deduplication**
The `create_vulnerability_report` tool rejects duplicates before persistence and validates CVSS vectors structurally — the only agent with programmatic finding quality control.
*Evidence: `strix/strix/tools/reporting/reporting_actions.py:117`, `strix/strix/tools/reporting/reporting_actions.py:176`. 42% cross-run overlap but 0 duplicates in output.*

---

## 7. What Didn't Work

**F1. CAI's zero Kali tool usage**
Across 20 runs in a Kali Linux container with sqlmap, nikto, nmap, ffuf, and hydra available, CAI never invoked any specialized security tool. Tool selection defaulted to curl (69.5%) regardless of target. This is the single largest performance gap — PentestGPT's sqlmap usage (23% on BadStore) directly enabled OS-level shell access that CAI never approached.
*Evidence: `cai-analysis.md` §4a. Compare: PentestGPT used sqlmap for 150 of 648 BadStore commands.*

**F2. PentestGPT's flag fabrication**
In Juice Shop Run 5, the agent exhausted known techniques, queried the challenges API, and computed `md5(challengeKey + "OWASP Juice Shop")` — submitting 10 fabricated flags using the wrong algorithm. The agent invented data rather than admitting uncertainty. This is a novel LLM failure mode with direct implications for security assessment reliability.
*Evidence: `pentestgpt-analysis.md` §6/F4. 10 AGENT_COMPUTED flags, all invalid.*

**F3. CAI's stochastic exploitation behavior**
CAI's 60% exploitation rate on BadStore (3/5 runs) and 0% on Juice Shop means benchmark outcomes are highly variable. Identical prompt, model, and target produce fundamentally different results depending on stochastic model decisions. A 3-run sample could observe anywhere from 0% to 100% exploitation.
*Evidence: `cai-analysis.md` §4d. Runs 2, 3, 5 exploited; Runs 1, 4 did not.*

**F4. PentestGPT's state contamination**
No target restart between runs introduces systematic bias: increasing self-reported challenges (13 → 14 on JS), decreasing duration (12m 56s → 7m 24s on BS), and cross-target `/tmp` artifact leakage. Later runs are not independent measurements.
*Evidence: `pentestgpt-analysis.md` §6/F6. BadStore sqlmap shells found in Juice Shop Run 5 archive.*

**F5. CAI's pre-fix infinite loop (PR #411)**
A bug in `fix_message_list()` (`cai/src/cai/util.py:1250`) caused 100% stall rates in pre-fix runs (10/10). The single-predecessor check entered an infinite loop when the model issued parallel tool calls, consuming 85–96% CPU until timeout. A single framework bug reduced CAI's effective capability to zero.
*Evidence: `cai-analysis.md` §5. Pre-fix: 3 findings across 10 runs. Post-fix: 25+ findings across 10 runs (+733%).*

**F6. Missing cost data for Strix**
Strix does not persist cost/token data to its output archive. The most thorough agent's cost-per-finding is unknown, leaving the cost-effectiveness frontier incomplete. This is the most impactful missing metric for cross-agent comparison in the thesis.
*Evidence: `strix-analysis.md` §4b. Estimate: $15–30/run based on model pricing and session duration.*

**F7. CAI and PentestGPT premature self-termination (Strix utilization unclear)**
CAI and PentestGPT declare "mission complete" before exhausting configured budgets. Budget utilization ranges from 5% (CAI) to ~56% (PentestGPT). For Strix, iteration utilization is unknown in available archives, so only a directional conclusion is possible there.
*Evidence: `summary.md` §4/Finding 8. CAI: 5–17 of 100 turns; PentestGPT: 83–168 of 300 iterations; Strix utilization unknown.*

---

## 8. Code Worth Studying

| File / Module | Agent | What It Does | Why It's Interesting for OpenHack |
|---------------|-------|--------------|-----------------------------------|
| `strix/strix/tools/reporting/reporting_actions.py` | Strix | Structured vulnerability registration with CVSS 3.1 validation, required fields, and deduplication | Gold standard for agent output quality control; directly adoptable schema |
| `strix/strix/runtime/tool_server.py` | Strix | Authenticated HTTP tool-server mediating sandbox access | Clean trust boundary pattern — separates LLM planner from execution substrate |
| `strix/strix/tools/finish/finish_actions.py` | Strix | Enforced completion contract with required report sections | Prevents premature termination observed in CAI/PentestGPT |
| `strix/strix/agents/state.py` | Strix | Per-agent state tracking with iteration counters, wait/stop flags, error history | Well-structured state management for multi-agent orchestration |
| `strix/strix/llm/memory_compressor.py` | Strix | Context window compression preserving recent messages | Handles long sessions without context overflow; relevant for ~50 min runs |
| `strix/strix/tools/browser/browser_instance.py` | Strix | Playwright headless browser with per-agent context isolation | Reference implementation for browser integration in pentest agents |
| `cai/src/cai/sdk/agents/run.py` | CAI | Core Runner pattern (model → tools/handoff → rerun until final output) | Clean, reusable autonomy loop with explicit termination contracts |
| `cai/src/cai/sdk/agents/_run_impl.py:844` | CAI | `tool_use_behavior` strategy hook | Deterministic control over when tool results finalize runs — extensibility primitive |
| `cai/src/cai/agents/guardrails.py` | CAI | Input/output guardrails with tripwire model | Practical safety chokepoints; adaptable for OpenHack's scope enforcement |
| `cai/src/cai/util.py:416` | CAI | Cost-aware preflight and streaming budget checks | Prevents cost overruns in autonomous sessions — directly adoptable |
| `PentestGPT/pentestgpt/core/controller.py` | PentestGPT | Lifecycle state machine (idle/running/paused/completed/error) | Clean lifecycle model for operational control and debuggability |
| `PentestGPT/pentestgpt/core/events.py` | PentestGPT | Typed event bus decoupling UI from agent execution | Structured telemetry pattern; simplifies observability hooks |
| `PentestGPT/pentestgpt/core/session.py` | PentestGPT | File-based session JSON with checkpointing and resume | Simple persistence enabling interrupted long runs to resume |

---

## 9. Scorecard Validation

> Comparing code-review scores from project analysis (§9) with actual benchmark
> performance. Adjustments based on empirical evidence.

| Criterion | CAI Code Review | CAI Validated | PentestGPT Code Review | PentestGPT Validated | Strix Code Review | Strix Validated | Notes |
|-----------|----------------|--------------|----------------------|---------------------|------------------|----------------|-------|
| Flow traceability | 4 | 4 | 4 | 4 | 5 | 5 | All agents have traceable flows; Strix's tracer output is most complete |
| Tool-use transparency | 4 | 3 (**-1**) | 3 | 3 | 4 | 4 | CAI downgraded: tool selection is traceable but the *reason* for ignoring Kali tools is opaque (LLM black box) |
| Reproducibility | 4 | 3 (**-1**) | 4 | 4 | 4 | 4 | CAI downgraded: stochastic exploitation (0–60% depending on target) and pre-fix infinite loop reduce practical reproducibility |
| Detection coverage | 4 | 2 (**-2**) | 4 | 4 | 4 | 5 (**+1**) | CAI's 2/14 JS + 6/14 BS is below code-review expectation. Strix's 13/~16 combined exceeds expectation. |
| False-positive handling | 3 | 3 | 2 | 1 (**-1**) | 4 | 4 | PentestGPT downgraded: Run 5 flag fabrication (10 fabricated flags) demonstrates active false-positive generation |
| Level of autonomy | 4 | 3 (**-1**) | 4 | 4 | 5 | 5 | CAI downgraded: autonomous but single-pass strategy limits effective autonomy to surface-level recon |
| Execution safety | 3 | 3 | 2 | 2 | 4 | 4 | No changes; PentestGPT's default bypassPermissions confirmed as concern |
| Extensibility | 5 | 5 | 4 | 4 | 4 | 4 | No changes; CAI's extensibility confirmed (MCP, agent factory, tool decorators) |
| Cost awareness | 4 | 4 | 2 | 2 | 3 | 3 | No changes; CAI's budget controls work ($0.89 total); Strix and PentestGPT lack enforcement |
| Adoptability for OpenHack | 5 | 4 (**-1**) | 4 | 3 (**-1**) | 5 | 5 | CAI downgraded: extensibility is strong but benchmark performance is weak. PentestGPT: strong patterns but no browser/reporting quality. Strix: directly adoptable. |

**Validated overall scores:**

| Agent | Code Review Score | Benchmark-Validated Score | Delta |
|-------|-------------------|--------------------------|-------|
| CAI | 40 / 50 | 34 / 50 | **-6** |
| PentestGPT | 33 / 50 | 31 / 50 | **-2** |
| Strix | 42 / 50 | 43 / 50 | **+1** |

**Key score shifts:**
- **CAI (-6):** The largest downgrade. Code review suggested a capable framework with broad detection coverage and strong autonomy. Benchmarks revealed that detection coverage (2–6/14), exploitation behavior (0–60% stochastic), and tool selection (0% Kali tools) fall well below the code's potential. The framework is better than the agent behavior it produces.
- **PentestGPT (-2):** Modest downgrade. False-positive handling (-1) drops due to flag fabrication. Adoptability (-1) decreases because the lack of browser and structured reporting limits OpenHack utility.
- **Strix (+1):** Slight upgrade. Detection coverage exceeds code-review expectation (13/~16 categories across 4 runs). Overall score reflects that Strix's observed behavior closely matches its architectural design.

---

## 10. Actionable Recommendations for OpenHack

### Must Have

- [ ] **Implement browser integration (Playwright headless).** 5 XSS findings exclusively from Strix prove that ~15–20% of web application attack surface is unreachable without a browser. Reference: `strix/strix/tools/browser/browser_instance.py`.
- [ ] **Adopt structured vulnerability reporting with CVSS and PoC requirement.** Strix's `create_vulnerability_report` with field validation and deduplication is the benchmark gold standard. Eliminates unverifiable claims (0% PentestGPT flag verification, CAI passive-only reports). Reference: `strix/strix/tools/reporting/reporting_actions.py`.
- [ ] **Implement sandbox isolation via tool-server architecture.** Strix's authenticated HTTP tool-server between orchestrator and Kali container provides reproducibility, security, and clean separation of concerns. Reference: `strix/strix/runtime/tool_server.py`, `strix/strix/runtime/docker_runtime.py`.
- [ ] **Add cost-aware budget enforcement.** CAI's preflight and streaming price limit checks prevent cost overruns during autonomous sessions. Useful even at moderate costs (Strix ~$4.08/run actual). Reference: `cai/src/cai/util.py:416`, `cai/src/cai/sdk/agents/models/openai_chatcompletions.py:686`.
- [ ] **Enforce structured termination contracts.** Strix's `finish_scan` tool prevents premature self-termination. Without this, agents use only 5–56% of their configured budgets. Reference: `strix/strix/tools/finish/finish_actions.py`.

### Should Have

- [ ] **Implement event-bus mediated communication.** PentestGPT's typed event bus (TEXT, TOOL_START, RESULT, FLAG_FOUND) decouples UI from execution and enables structured telemetry. Reference: `PentestGPT/pentestgpt/core/events.py`.
- [ ] **Add session persistence and resume capability.** PentestGPT's JSON-based session checkpointing enables recovery from interrupted long runs. Critical for Strix-class sessions (~50 min). Reference: `PentestGPT/pentestgpt/core/session.py`.
- [ ] **Implement memory compression for long sessions.** Strix's context window compressor maintains operational continuity during 45–60 min sessions. Reference: `strix/strix/llm/memory_compressor.py`.
- [ ] **Integrate proxy (Caido or similar).** Provides verifiable traffic-level evidence and passive endpoint discovery. Strix's 3362-request corpus demonstrates value. Reference: `strix/strix/tools/proxy/proxy_manager.py`.
- [ ] **Add input/output guardrails.** CAI's tripwire-based guardrail model provides practical safety chokepoints without blocking legitimate pentest activity. Reference: `cai/src/cai/agents/guardrails.py`.
- [ ] **Implement wrapper retry policy.** PentestGPT's non-interactive wrapper retries (up to 3) when no findings are captured — simple reliability gain for autonomous runs. Reference: `PentestGPT/pentestgpt/interface/main.py:174`.

### Could Have

- [ ] **Support multi-agent delegation graph.** Strix's parent-child agent orchestration with inter-agent messaging enables specialized subagents for validation, reporting, and exploitation. Reference: `strix/strix/tools/agents_graph/agents_graph_actions.py`.
- [ ] **Add scan-mode skills (quick/standard/deep).** Strix's parameterized scan profiles enable budget normalization across experiments. Reference: `strix/strix/skills/scan_modes/`.
- [ ] **Implement automated JS endpoint extraction.** CAI's `js_surface_mapper` discovered 22+ endpoints in a single call — unique capability not present in other agents. Reference: `cai/src/cai/agents/web_pentester.py:17`.
- [ ] **Add lifecycle state machine for operational control.** PentestGPT's controller state model (idle/running/paused/completed/error) with pause/resume/inject supports interactive supervision workflows. Reference: `PentestGPT/pentestgpt/core/controller.py:29`.
- [ ] **Add tool-use behavior strategy hooks.** CAI's `tool_use_behavior` policy (`run_llm_again`, `stop_on_first_tool`, custom callable) provides deterministic post-tool-call control. Reference: `cai/src/cai/sdk/agents/agent.py:142`.
- [ ] **Implement CSV/artifact output model.** Strix's per-run artifact directory (`strix_runs/<run>/`) with markdown reports, per-vuln files, and CSV index enables systematic benchmark analysis. Reference: `strix/strix/telemetry/tracer.py`.

---

## 11. Comparison with Other Agents

### 11a. Architecture Comparison

| Aspect | CAI | PentestGPT | Strix | Best for OpenHack |
|--------|-----|------------|-------|-------------------|
| Agent loop design | SDK Runner with handoffs, guardrails, parallel mode | Claude SDK wrapper with streaming events | Multi-agent graph with sandbox tool-server | **Strix** — most complete; CAI's Runner pattern as inner loop |
| Tool integration | `generic_linux_command` + specialized tools (MCP-extensible) | Claude Code bash tool + Kali binaries | Registry-based tools with XML schemas + browser + proxy | **Strix** — broadest integrated surface; CAI for extensibility primitives |
| Recon effectiveness | `js_surface_mapper` unique; otherwise curl-heavy | Recall-driven (JS) + gobuster/nmap (BS) | Proxy-based passive + terminal-based active | **Strix** — most thorough; CAI's JS mapper worth integrating |
| Exploit effectiveness | 0–60% stochastic; 1 sophisticated chain in 20 runs | High on BadStore (OS shell 4/5); moderate on JS | Consistent 6–14 vulns/run; no OS-level | **PentestGPT** for depth; **Strix** for breadth and consistency |
| Browser support | No (designed for CLI-only) | No (by design) | Yes (Playwright headless, per-agent contexts) | **Strix** — binary capability threshold |
| Reporting quality | Plaintext report, informal severity | Walkthrough narrative, no severity | CVSS + PoC + CSV index, professional grade | **Strix** — only actionable output format |
| Cost efficiency | $0.095/run (cheapest productive) | $2.75/run (mid-range) | ~$4.08/run (most expensive) | **CAI** for triage; **PentestGPT** for cost-depth balance |
| Code quality | Clean SDK architecture; complex CLI path | Clean separation; weak safety defaults | Well-structured; sequential tool execution limitation | **CAI** for framework reuse; **Strix** for pentest runtime |
| Scorecard (validated) | 34 / 50 | 31 / 50 | 43 / 50 | **Strix** (43/50) |

### 11b. Key Comparative Findings

1. **No agent dominates on all axes.** Strix leads in breadth, quality, and browser capability. PentestGPT leads in exploitation depth (OS shell). CAI leads in cost efficiency. OpenHack should combine strengths: Strix's architecture with PentestGPT's depth-oriented exploitation strategy and CAI's cost controls.

2. **Target architecture is a stronger predictor of results than agent architecture.** The same agent (CAI) produces 0% vs. 60% exploitation depending on the target. PentestGPT shifts from 80% curl to 51% curl + 23% sqlmap. Strix shows SD 4.9 vs. SD 0.7. Agent benchmarks on a single target are non-generalizable.

3. **Browser capability creates a binary partition.** GVM, CAI, and PentestGPT found 0 verified XSS. Strix found 5. There is no partial browser capability — agents either can or cannot test client-side vulnerabilities. This is the thesis's strongest evidence that tool architecture determines assessment scope.

4. **Framework reliability is a first-order variable.** CAI's PR #411 bug caused a 733% finding increase from a single fix. Agent benchmarks must control for framework reliability separately from model capability. PentestGPT's 100% completion rate across 10 runs demonstrates the value of simple, reliable architecture.

5. **Cost-quality tradeoff is monotonic but non-linear.** $0.10 (CAI) → $2.75 (PentestGPT) = genuine exploitation depth. $2.75 (PentestGPT) → $15–30 (Strix) = validated PoCs + browser capability but not deeper exploitation. The marginal return per dollar decreases at higher spend levels.

### 11c. Synthesis for OpenHack Architecture

Based on comparative analysis, OpenHack should adopt a **Strix-influenced architecture** with selected components from CAI and PentestGPT:

| Component | Source | Rationale |
|-----------|--------|-----------|
| Sandbox + tool-server | Strix | Proven isolation model with 100% reliability |
| Browser integration | Strix | Binary capability threshold — required for XSS/client-side testing |
| Vulnerability reporting | Strix | Only professional-grade output format with built-in quality controls |
| Agent loop core | CAI (Runner pattern) | Clean, extensible autonomy loop with termination contracts |
| Cost controls | CAI | Only agent with proactive budget enforcement |
| Guardrails | CAI | Input/output safety chokepoints |
| Event telemetry | PentestGPT | Structured observability via typed event bus |
| Session persistence | PentestGPT | Simple resume capability for long runs |
| Termination contract | Strix (finish_scan) | Prevents premature self-termination (5–56% budget waste in other agents) |
| Multi-agent delegation | Strix | Built-in parent-child orchestration for specialized subagents |

---

## Appendix: Data Sources

### Analysis Files

| File | Scope | Lines |
|------|-------|-------|
| `cai-analysis.md` | CAI cross-target synthesis (20 runs) | ~606 |
| `pentestgpt-analysis.md` | PentestGPT cross-target synthesis (10 runs) | ~575 |
| `strix-analysis.md` | Strix cross-target synthesis (4 runs) | ~640 |
| `summary.md` | Benchmark summary — all agents | ~472 |

### Project Analysis Files

| File | Agent | Score |
|------|-------|-------|
| `stalled-cai-project-analysis.md` | CAI | 40/50 (code review) → 34/50 (validated) |
| `pentestgpt-project-analysis.md` | PentestGPT | 33/50 (code review) → 31/50 (validated) |
| `strix-project-analysis.md` | Strix | 42/50 (code review) → 43/50 (validated) |

### Per-Target Results Files

| File | Agent × Target | Runs |
|------|---------------|------|
| `cai-juiceshop-results.md` | CAI × Juice Shop | 5+5 |
| `cai-badstore-results.md` | CAI × BadStore | 5+5 |
| `stalled-cai-juiceshop-results.md` | CAI (pre-fix) × Juice Shop | 5 |
| `stalled-cai-badstore-results.md` | CAI (pre-fix) × BadStore | 5 |
| `pentestgpt-juiceshop-results.md` | PentestGPT × Juice Shop | 5 |
| `pentestgpt-badstore-results.md` | PentestGPT × BadStore | 5 |
| `strix-juiceshop-results.md` | Strix × Juice Shop | 2 |
| `strix-badstore-results.md` | Strix × BadStore | 2 |
| `gvm-juiceshop-results.md` | GVM × Juice Shop | 1 |
| `gvm-badstore-results.md` | GVM × BadStore | 1 |

### Source Code Directories

| Path | Agent | Contents |
|------|-------|----------|
| `../source/cai/` | CAI | Full repository clone (commit `e22a122`) |
| `../source/PentestGPT/` | PentestGPT | Full repository clone (commit `6e84be8`) |
| `../source/strix/` | Strix | Full repository clone (commit `0a63ffb`) |
