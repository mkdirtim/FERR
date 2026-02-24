#!/usr/bin/env bun
import path from "node:path"
import { buildReport, materializeReport, openDb, runDbPath } from "../../../../lib/pentest-db"

function usage() {
  console.log(`Usage:
  bun .opencode/skills/instructions-reporting/assets/tests/build-report-db.ts build --run-id <id> [--format pdf|html|docx|all] [--by <actor>]
  bun .opencode/skills/instructions-reporting/assets/tests/build-report-db.ts materialize --run-id <id> [--by <actor>]
  bun .opencode/skills/instructions-reporting/assets/tests/build-report-db.ts validate --run-id <id> [--by <actor>]
`)
}

function arg(name: string, list: string[]) {
  const idx = list.indexOf(name)
  if (idx < 0) return undefined
  return list[idx + 1]
}

const [cmd, ...rest] = process.argv.slice(2)
if (!cmd || ["-h", "--help"].includes(cmd)) {
  usage()
  process.exit(0)
}

const runID = arg("--run-id", rest)
if (!runID) {
  console.error("Missing --run-id")
  usage()
  process.exit(1)
}

const actor = arg("--by", rest) ?? "cli"
const formatArg = arg("--format", rest) ?? "pdf"
if (!["pdf", "html", "docx", "all"].includes(formatArg)) {
  console.error(`Invalid format: ${formatArg}. Must be one of: pdf, html, docx, all`)
  process.exit(1)
}
const format = formatArg as "pdf" | "html" | "docx" | "all"

const worktree = path.resolve(import.meta.dirname, "../../../../")

try {
  if (cmd === "materialize") {
    const out = materializeReport(worktree, { run_id: runID, built_by: actor })
    console.log(JSON.stringify(out, null, 2))
    process.exit(0)
  }

  if (cmd === "validate") {
    materializeReport(worktree, { run_id: runID, built_by: actor })
    const db = openDb(runDbPath(worktree, runID))
    try {
      const row = db.query("SELECT last_status, last_error FROM report_build WHERE run_id = ?").get(runID) as
        | { last_status: string; last_error: string | null }
        | undefined
      if (!row || row.last_status !== "success") {
        throw new Error(row?.last_error ?? "Validation failed")
      }
    } finally {
      db.close()
    }
    console.log(JSON.stringify({ ok: true, run_id: runID }, null, 2))
    process.exit(0)
  }

  if (cmd === "build") {
    const out = buildReport(worktree, { run_id: runID, format, built_by: actor })
    console.log(JSON.stringify(out, null, 2))
    process.exit(0)
  }

  console.error(`Unknown command: ${cmd}`)
  usage()
  process.exit(1)
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error))
  process.exit(1)
}
