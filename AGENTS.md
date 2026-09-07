# Agent Operating Contract

This repository treats its files and executable evidence as the source of truth. Use this file as a map, not as a substitute for inspecting the project.

## Start every task

1. Read this file before making changes.
2. Restate the requested outcome internally and separate known facts from assumptions.
3. Inspect `git status` and the current branch before editing.
4. Inspect recent commits when prior work may affect the task.
5. If `.agent/HANDOFF.md` exists and overlaps the task, read it and verify its claims against git and code.
6. Inspect `docs/plans/active/` only when the task is non-trivial or already has an active plan.
7. Search for relevant code, tests, contracts, and docs before opening broad file ranges.
8. Do not preload the documentation tree.

## Evidence priority

When sources disagree, prefer this order:

1. Current runtime behavior and executable evidence.
2. Tests and validation output.
3. Current source code, schemas, and contracts.
4. Accepted architecture decision records.
5. Maintained repository documentation.
6. Active plan or handoff notes.
7. Conversation history or model memory.
8. Unsupported assumptions.

Memory may suggest where to look. Repository evidence decides what is true.

## Context discipline

- Keep always-on instructions small; retrieve deeper context only when the task needs it.
- Search first, then read the smallest useful file ranges.
- Prefer summaries, symbols, diffs, and targeted test output over dumping large files or logs.
- Read only the architecture, ADRs, plans, and reliability notes relevant to the current change.
- Treat generated, historical, and completed-plan content as cold context unless the task explicitly needs history.
- Do not copy transient chat history into durable docs.

## Discover the project instead of guessing

- Inspect manifests, lockfiles, CI, scripts, and existing docs to discover the stack and repository-native commands.
- Follow established local conventions before introducing new ones.
- Never invent a build, test, lint, typecheck, migration, or release command and present it as repository fact.
- Confirm external APIs against current primary documentation when behavior or versioning can change.

## Change discipline

- Make the smallest coherent change that satisfies the requested outcome.
- Avoid unrelated refactors, speculative abstractions, and new dependencies without demonstrated need.
- Preserve public contracts unless the task explicitly changes them.
- Keep this reusable baseline limited to agent/context/repository governance; do not add framework, runtime, product architecture, auth, database, UI, or other application-starter assumptions.
- Put reusable runtime/configuration code in versioned packages and conditional starter code in generators or stack-specific archetypes instead of copying it into this baseline.
- State material assumptions in the active plan, ADR, or final report when they cannot be verified directly.
- Do not record speculation as durable project knowledge.

## Plans and decisions

- Small, local changes do not need durable planning artifacts.
- Use `docs/plans/active/` for work that spans multiple meaningful steps, sessions, or agents.
- Keep active plans current: progress, decisions, verification evidence, blockers, and exact next action.
- Move useful completed plans to `docs/plans/completed/` or remove them after durable knowledge is captured elsewhere.
- Use `docs/decisions/` only for decisions with lasting architectural consequences.

## Verification contract

- Never claim a file, symbol, API, behavior, fix, test result, or deployment state without checking it.
- Run focused validation first, then the broader repository checks appropriate to the change.
- Report the exact checks executed and distinguish passing evidence from checks that were not run.
- Test behavior at the highest practical level for the risk: unit, integration, end-to-end, or real workflow.
- For broad or high-risk work, use a fresh reviewer/evaluator when it adds meaningful independent scrutiny.
- A model reviewing its own work is not a substitute for executable evidence.

## Session handoff

For unfinished work likely to cross sessions, create `.agent/HANDOFF.md` from `.agent/HANDOFF.example.md` and keep it compact. Record the task, branch, verified HEAD, completed work, current state, checks/results, important files, blockers or failed approaches, and the exact next action.

At the next session, verify the handoff against the repository before trusting it. When the handoff is no longer useful, delete it; git history, ADRs, tests, and maintained docs own durable truth.

## Safety and repository hygiene

- Do not expose, commit, or reproduce secrets, credentials, private keys, or sensitive local data.
- Do not weaken tests, validation, security controls, or access boundaries merely to make a check pass.
- Do not overwrite user work or discard unrelated uncommitted changes.
- Keep documentation concise, linked, and current; update or remove stale claims encountered in the scope of the task.

## Definition of done

Work is done only when the requested outcome is implemented, relevant verification has been executed, results are reported accurately, and any durable documentation or temporary handoff state affected by the change is consistent with the repository.
