# Default Project

A technology-agnostic, agent-ready GitHub template for long-lived software projects. Its job is deliberately boring and important: help a fresh coding agent recover the project accurately without stuffing an entire repository or old chat history into context.

## What this template optimizes for

- **Minimal always-on context** — one short canonical `AGENTS.md`, not a giant prompt manual.
- **Repository-backed truth** — code, tests, contracts, git, ADRs, and maintained docs outrank conversation memory.
- **Progressive disclosure** — agents search first and read deeper architecture, plans, and history only when relevant.
- **Cross-session recovery** — unfinished long tasks can leave a compact, verifiable handoff.
- **Evidence before confidence** — fixes and test results are reported only after verification.
- **Provider-neutral operation** — the core contract is not tied to a language, framework, model, or vendor.

## One-minute setup for a new project

1. Enable this repository as a GitHub **Template repository**.
2. Create a new repository with **Use this template**.
3. Replace this README with the new project's human-facing README.
4. Keep root `AGENTS.md`; add only stable, high-value project rules as the codebase becomes real.
5. Put durable architecture decisions in `docs/decisions/` and non-trivial active execution plans in `docs/plans/active/` only when needed.
6. Run `bash scripts/validate-template.sh` after changing the agent harness itself.

The template intentionally does **not** guess your build system. A fresh agent discovers project-native commands from manifests, CI, scripts, and existing docs.

## Fresh-session recovery

A new agent should normally do this instead of asking for the old conversation:

```text
read AGENTS.md
      ↓
git status + recent git log
      ↓
read .agent/HANDOFF.md only if relevant and present
      ↓
inspect an active plan only if relevant and present
      ↓
search task-related code/tests/contracts/docs
      ↓
verify repository-native commands
      ↓
continue
```

The point is not to make the agent remember everything. The point is to make it cheap to find the right thing again.

## Context budget

`AGENTS.md` is the only canonical standing contract. CI enforces hard anti-bloat limits:

- `AGENTS.md`: **100 lines maximum** and **9,000 bytes maximum**.
- `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`: **1,024 bytes maximum each** and must point back to `AGENTS.md`.
- The rest of `docs/` is cold context and should be retrieved on demand.

These byte limits are guardrails, not targets. Shorter is better when the same behavior can be preserved.

## Repository map

| Path | Purpose | Load by default? |
| --- | --- | --- |
| `AGENTS.md` | Canonical agent operating contract and navigation map | Yes |
| `CLAUDE.md` | Thin Claude bootstrap | Tool-dependent |
| `GEMINI.md` | Thin Gemini bootstrap | Tool-dependent |
| `.github/copilot-instructions.md` | Thin Copilot bootstrap | Tool-dependent |
| `.agent/HANDOFF.md` | Temporary unfinished-work handoff, created only when needed | Only when relevant |
| `docs/architecture/` | Stable architecture maps and invariants | No |
| `docs/decisions/` | Durable ADRs | No |
| `docs/plans/active/` | Current non-trivial execution plans | No |
| `docs/plans/completed/` | Useful retained plan history | No |
| `docs/reliability/` | Project-specific verification/reliability guidance | No |
| `scripts/checkpoint.sh` | Read-only git recovery snapshot | On demand |
| `scripts/validate-template.sh` | Harness integrity checks | On harness changes / CI |

## Handoff lifecycle

Do **not** maintain a permanent transcript-shaped memory file. For unfinished work that genuinely needs another session, copy `.agent/HANDOFF.example.md` to `.agent/HANDOFF.md`, fill it with verified state, and keep it compact.

When the work finishes, delete the temporary handoff. Durable knowledge belongs with its owner: behavior in code/tests, decisions in ADRs, architecture in maintained docs, and implementation history in git/PRs.

## Plan and ADR rule of thumb

Use a plan when the work spans multiple meaningful steps, sessions, or agents. Use an ADR when a choice has lasting architectural consequences. A one-line bug fix needs neither. Documentation ceremony is not a substitute for engineering.

## Verification helpers

### Compact checkpoint

```bash
bash scripts/checkpoint.sh
```

Prints repository root, branch, HEAD, worktree state, staged/unstaged diff summaries, and recent commits. It does not edit or commit anything.

### Harness integrity

```bash
bash scripts/validate-template.sh
```

Checks the core agent-harness files, instruction size limits, canonical provider bridges, instruction-file newlines, and shell syntax. It deliberately does not ban application `TODO`s, active handoffs, agent-specific planning directories, or normal project customization.

Application tests are intentionally **not** guessed by this script. Each derived project should encode its real build/test/lint/typecheck commands in CI or repository scripts, then let agents discover and execute those sources of truth.

## Provider compatibility

The provider-neutral contract is root `AGENTS.md`. Tiny bootstrap files cover tools that discover provider-specific filenames without creating separate policy copies. GitHub Copilot supports repository/path-specific instructions and task-specific skills; add those only when a derived project has a genuine scoped need. Cursor currently supports root and nested `AGENTS.md` directly, so it needs no extra always-on rule file.

Other coding agents can use the same repository contract by reading `AGENTS.md` at session start. If a tool requires a different bootstrap filename, prefer a tiny pointer rather than duplicating the policy.

## Design basis

This structure is informed by current public agent-engineering guidance as of 2026-09-07:

- OpenAI: repository knowledge as system of record, short `AGENTS.md`, structured execution plans, and progressive disclosure — https://openai.com/index/harness-engineering/
- OpenAI: externalized agent state and rehydration for durable long-running work — https://openai.com/index/the-next-evolution-of-the-agents-sdk/
- Anthropic: finite-context engineering, git/progress artifacts, structured handoffs, and independent evaluation for work that needs it — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents and https://www.anthropic.com/engineering/harness-design-long-running-apps
- GitHub Copilot: repository-wide, path-specific, agent instructions, and on-demand skills as distinct customization layers — https://docs.github.com/en/copilot/concepts/agents/code-review
- Cursor: `AGENTS.md` is a first-class project instruction format and can be scoped through nested files when needed — https://cursor.com/docs/rules

The common idea is simple: preserve **high-signal durable state**, retrieve it selectively, and verify outcomes in the environment rather than trusting the model's recollection.
