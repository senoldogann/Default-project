# Agent-Ready Default Project Template Design

Date: 2026-09-07
Status: Approved for implementation

## Goal

Create a technology-agnostic GitHub template that lets a coding agent recover project state in a fresh session, find only the context relevant to the current task, and verify claims against repository evidence instead of conversation memory.

## Design principles

1. **Repository is the system of record.** Conversation history and model memory are hints, not authority.
2. **Map, not manual.** `AGENTS.md` is a short navigation and operating contract, not a repository encyclopedia.
3. **Progressive disclosure.** Agents start with a small stable instruction set and retrieve deeper docs, plans, decisions, code, and test evidence only when relevant.
4. **Verification over confidence.** Agents must not claim files, APIs, behavior, fixes, or passing tests without checking them.
5. **Durable handoff.** Long tasks leave a compact structured handoff that a fresh agent can consume.
6. **Git-native recovery.** Branch, HEAD, recent commits, status, diff, active plans, and test results are preferred recovery evidence.
7. **Provider-neutral core.** `AGENTS.md` is canonical. Provider-specific files are tiny bridges, not duplicate manuals.
8. **No mandatory runtime stack.** The template must work for Node, Python, Rust, Go, Swift, Java, .NET, frontend, backend, mobile, agent, or mixed repositories.
9. **Complexity is earned.** Planner/evaluator/multi-agent patterns are optional and used only when task risk warrants them.
10. **Template self-checks.** The template validates its own invariants in CI without adding application dependencies.

## Research basis

The design intentionally follows current public guidance as of 2026-09-07:

- OpenAI, "Harness engineering: leveraging Codex in an agent-first world" (2026-02-11): repository knowledge as system of record; short roughly 100-line `AGENTS.md`; structured docs; active/completed execution plans; progressive disclosure; mechanical documentation checks. https://openai.com/index/harness-engineering/
- OpenAI, "The next evolution of the Agents SDK" (2026-04-15): externalized state, snapshotting, rehydration, and separation of durable agent state from transient compute. https://openai.com/index/the-next-evolution-of-the-agents-sdk/
- OpenAI, "From model to agent: Equipping the Responses API with a computer environment" (2026): compaction plus progressively loaded skills and durable artifacts for long-running work. https://openai.com/index/equip-responses-api-computer-environment/
- Anthropic, "Effective context engineering for AI agents" (2025-09-29): context is finite; maximize high-signal tokens and retrieve context just in time. https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Anthropic, "Effective harnesses for long-running agents" (2025-11-26): progress artifacts, git commits, reproducible startup, and explicit end-to-end verification across fresh sessions. https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
- Anthropic, "Harness design for long-running application development" (2026-03-24): structured handoffs, evaluator separation for harder tasks, and removal of harness complexity when stronger models no longer need it. https://www.anthropic.com/engineering/harness-design-long-running-apps
- GitHub Copilot documentation (current 2026-09-07): repository-wide, path-specific, and agent instructions; `AGENTS.md` for shared standing rules and skills/prompts for task-specific workflows. https://docs.github.com/en/copilot/concepts/agents/code-review

## Context model

### Always-on target

The canonical `AGENTS.md` should remain approximately 50-100 lines and below 2,000 tokens. Provider bridge files should contain only a pointer plus essential bootstrap wording.

### Initial bootstrap

A fresh agent should normally need only:

1. `AGENTS.md`
2. `git status`
3. recent `git log`
4. one active plan or handoff when present
5. repository search for the current task

The agent must not preload the documentation tree.

### Evidence priority

When sources disagree, prefer:

1. current runtime behavior and executable evidence
2. tests and validation output
3. current source code, schemas, and contracts
4. accepted architecture decision records
5. maintained repository documentation
6. active plan/handoff notes
7. conversation history or model memory
8. unsupported model assumptions

## Repository structure

```text
AGENTS.md
CLAUDE.md
GEMINI.md
README.md
.editorconfig
.gitignore
.agent/
  README.md
  HANDOFF.example.md
docs/
  README.md
  architecture/
    README.md
  decisions/
    README.md
    ADR-TEMPLATE.md
  plans/
    README.md
    PLAN-TEMPLATE.md
    active/.gitkeep
    completed/.gitkeep
  reliability/
    README.md
.github/
  copilot-instructions.md
  ISSUE_TEMPLATE/
    bug.yml
    feature.yml
  pull_request_template.md
  workflows/
    template-integrity.yml
scripts/
  checkpoint.sh
  validate-template.sh
```

Construction-only specification and plan documents under `docs/superpowers/` are removed before merge so derived projects do not inherit template-development history.

## Canonical agent contract

`AGENTS.md` must tell agents to:

- inspect before editing;
- discover project-native build/test/lint/typecheck commands rather than inventing them;
- search first and read relevant ranges instead of loading large files wholesale;
- distinguish facts, assumptions, and decisions;
- create an active plan only for work that benefits from durable coordination;
- maintain `.agent/HANDOFF.md` only for unfinished long-running work;
- run focused validation before broad validation;
- report exact commands and outcomes;
- avoid unrelated refactors;
- use fresh review/evaluation for risky, broad, or difficult work when useful;
- keep durable documentation concise and update or remove stale material.

## Provider bridges

`CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` must not independently define project policy. Each tells the tool to use root `AGENTS.md` as canonical. This reduces drift and duplicate context while covering tools that discover different instruction filenames.

## Handoff protocol

A handoff is created only when work is unfinished and likely to cross sessions. It records:

- status and task/issue
- branch and verified HEAD
- goal
- completed work
- current state
- verification commands/results
- changed or important files
- decisions/assumptions
- blockers/failed approaches
- exact next action

It must remain compact and should be deleted when no longer useful; durable decisions move to ADRs, completed work to git history, and project behavior to normal documentation.

## Plans and ADRs

Plans are first-class only for non-trivial work. Active plans move to `completed/` or are deleted after durable knowledge is extracted. ADRs capture decisions with long-lived architectural consequences; they do not record routine implementation details.

## Checkpoint helper

`scripts/checkpoint.sh` prints a compact, read-only recovery snapshot from git: repository root, branch, HEAD, status, diff summary, and recent commits. It must not silently mutate documentation or commit changes.

## Validation

`scripts/validate-template.sh` verifies template invariants with standard POSIX/Git tooling only:

- required files exist;
- `AGENTS.md` stays within the agreed line ceiling;
- provider bridges name `AGENTS.md` as canonical;
- executable shell scripts pass `bash -n`;
- template documentation contains no placeholder tokens such as `TBD` or `TODO`;
- construction-only `docs/superpowers/` is forbidden in the final merged template.

GitHub Actions runs the validator on pushes and pull requests.

## Non-goals

- No universal application build script.
- No universal dependency manager.
- No mandatory vector database, MCP server, memory service, or LLM provider.
- No automatic execution of guessed package scripts.
- No large generated repository map committed by default.
- No permanent transcript archive.
- No forced multi-agent orchestration for ordinary work.

## Success criteria

A fresh agent with no conversation history can enter a project created from this template and, using repository artifacts plus normal code search, determine what the project is, what rules matter, how to discover validation commands, whether unfinished work exists, and what evidence is required before claiming success. The always-on instruction footprint remains small and the template adds no application runtime dependency.
