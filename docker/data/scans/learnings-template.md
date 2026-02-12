# {AGENT_NAME} — Learnings for OpenHack

| Field | Value |
|-------|-------|
| **Agent** | {AGENT_NAME} {AGENT_VERSION} |
| **Repository** | {REPO_URL} |
| **Framework** | {AGENT_FRAMEWORK} |
| **License** | {LICENSE} |
| **Date Reviewed** | {DATE} |

---

## 1. Architecture

### 1a. Agent Design

How is the agent structured?

- **Agent loop:** {e.g., ReAct loop, plan-and-execute, tree of thought}
- **State management:** {How does it track progress, solved challenges, explored paths?}
- **Termination logic:** {How does it decide when to stop? Max iterations, self-assessment, coverage-based?}
- **Session persistence:** {Can it resume? How are sessions stored?}

### 1b. Tool Integration

How does the agent interact with external tools?

- **Tool calling mechanism:** {e.g., function calling API, shell exec, MCP}
- **Available tools:** {What tools can the agent invoke?}
- **Tool selection strategy:** {Does it choose tools dynamically or follow a fixed sequence?}
- **Custom tool support:** {Can users add their own tools?}

### 1c. LLM Integration

- **Supported models/providers:** {Anthropic, OpenAI, local, etc.}
- **Prompt structure:** {System prompt, few-shot examples, chain-of-thought?}
- **Context management:** {How does it handle long conversations/context limits?}
- **Cost controls:** {Max budget, token limits, iteration caps?}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 2. Reconnaissance Approach

How does the agent discover the target's attack surface?

- **Initial steps:** {What does it do first? Homepage fetch, port scan, robots.txt?}
- **Endpoint discovery:** {Active scanning, crawling, known paths from training data?}
- **Technology fingerprinting:** {How does it identify frameworks, versions, tech stack?}
- **Dependency on training data:** {Does it rely on memorized knowledge of the target?}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 3. Exploitation Strategy

### 3a. Vulnerability Detection

- **Detection methods:** {Pattern matching, fuzzing, payload injection, static analysis?}
- **Vulnerability categories covered:** {SQLi, XSS, CSRF, IDOR, etc.}
- **Payload generation:** {Hardcoded payloads, dynamic generation, payload libraries?}
- **False positive handling:** {Does it verify findings before reporting?}

### 3b. Attack Chaining

- **Multi-step attacks:** {Can it chain vulnerabilities? e.g., SQLi → credential dump → admin login}
- **Privilege escalation:** {Does it attempt to escalate after initial access?}
- **Lateral movement:** {Does it pivot to other services/endpoints?}

### 3c. Browser vs. CLI

- **Browser capabilities:** {Can it execute JS, interact with DOM, handle CSRF tokens?}
- **Headless browser integration:** {Playwright, Puppeteer, Selenium?}
- **CLI-only limitations:** {What vulnerability categories are unreachable without a browser?}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 4. Reporting & Output

- **Output format:** {Markdown, JSON, HTML, structured data?}
- **Severity classification:** {CVSS, custom severity, OWASP categories?}
- **Remediation advice:** {Does it suggest fixes?}
- **Evidence/PoC:** {Does it include proof-of-concept commands or screenshots?}
- **Report overhead:** {What % of agent time/budget is spent on reporting vs. attacking?}

> **Adopt for OpenHack?** {Yes/No — what specifically and why}

---

## 5. What Worked Well

List specific techniques, patterns, or design decisions that produced good results.
Cite evidence from benchmark runs where possible.

**L1. {TITLE}**
{Description. Why it worked. Evidence from runs.}

**L2. {TITLE}**
{Description.}

**L3. {TITLE}**
{Description.}

---

## 6. What Didn't Work

List specific failures, limitations, or anti-patterns observed.
Cite evidence from benchmark runs where possible.

**F1. {TITLE}**
{Description. Why it failed. Evidence from runs.}

**F2. {TITLE}**
{Description.}

**F3. {TITLE}**
{Description.}

---

## 7. Code Worth Studying

Reference specific files, functions, or modules from the agent's codebase
that contain patterns worth adopting or learning from.

| File/Module | What It Does | Why It's Interesting |
|-------------|--------------|----------------------|
| `{path}` | {description} | {why OpenHack should look at this} |
| `{path}` | {description} | {why} |

---

## 8. Actionable Recommendations for OpenHack

Prioritized list of concrete changes or features to adopt in OpenHack
based on this agent's strengths and weaknesses.

### Must Have

- [ ] {Recommendation — high impact, directly addresses a gap}
- [ ] {Recommendation}

### Should Have

- [ ] {Recommendation — moderate impact}
- [ ] {Recommendation}

### Could Have

- [ ] {Recommendation — nice to have, lower priority}
- [ ] {Recommendation}

---

## 9. Comparison with Other Agents

*Fill in after reviewing multiple agents.*

| Aspect | {AGENT_1} | {AGENT_2} | {AGENT_3} | Best for OpenHack |
|--------|-----------|-----------|-----------|-------------------|
| Agent loop design | | | | |
| Tool integration | | | | |
| Recon approach | | | | |
| Exploit strategy | | | | |
| Browser support | | | | |
| Reporting | | | | |
| Cost efficiency | | | | |
| Code quality | | | | |
