import { describe, expect, test } from "bun:test"
import { mkdirSync, writeFileSync } from "node:fs"
import path from "node:path"
import { SessionPrompt } from "../../src/session/prompt"
import { tmpdir } from "../fixture/fixture"

function setupRun(worktree: string, runID: string) {
  const runDir = path.join(worktree, "data", "pentest", "running", runID)
  const evidenceDir = path.join(runDir, "evidence")
  mkdirSync(evidenceDir, { recursive: true })
  writeFileSync(path.join(runDir, "run.db"), "")
  return { runDir, evidenceDir }
}

describe("session.prompt playwright artifact guard", () => {
  test("allows pentest screenshot file path under run evidence dir", async () => {
    await using tmp = await tmpdir()
    const runID = crypto.randomUUID()
    const { evidenceDir } = setupRun(tmp.path, runID)
    const filename = path.join(evidenceDir, "screenshot-1.png")

    expect(() =>
      SessionPrompt.validatePentestPlaywrightFilePath({
        tool: "playwright_browser_take_screenshot",
        args: { filename },
        worktree: tmp.path,
        permission: [{ permission: "pentest_get_run", pattern: "*", action: "allow" }],
      }),
    ).not.toThrow()
  })

  test("rejects pentest screenshot when filename is missing", async () => {
    await using tmp = await tmpdir()
    expect(() =>
      SessionPrompt.validatePentestPlaywrightFilePath({
        tool: "playwright_browser_take_screenshot",
        args: {},
        worktree: tmp.path,
        permission: [{ permission: "pentest_get_run", pattern: "*", action: "allow" }],
      }),
    ).toThrow("filename is required")
  })

  test("rejects non-absolute or non-run-evidence filename for pentest agent", async () => {
    await using tmp = await tmpdir()
    const runID = crypto.randomUUID()
    setupRun(tmp.path, runID)

    expect(() =>
      SessionPrompt.validatePentestPlaywrightFilePath({
        tool: "playwright_browser_network_requests",
        args: { filename: "network.json" },
        worktree: tmp.path,
        permission: [{ permission: "pentest_get_run", pattern: "*", action: "allow" }],
      }),
    ).toThrow("must be an absolute path under data/pentest/running/<run_id>/evidence")
  })

  test("does not enforce guard for non-pentest agent permissions", async () => {
    await using tmp = await tmpdir()
    expect(() =>
      SessionPrompt.validatePentestPlaywrightFilePath({
        tool: "playwright_browser_take_screenshot",
        args: {},
        worktree: tmp.path,
        permission: [{ permission: "read", pattern: "*", action: "allow" }],
      }),
    ).not.toThrow()
  })
})
