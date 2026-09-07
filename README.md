# Default Project

[![Template integrity](https://github.com/senoldogann/Default-project/actions/workflows/template-integrity.yml/badge.svg)](https://github.com/senoldogann/Default-project/actions/workflows/template-integrity.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Agent ready](https://img.shields.io/badge/agent--ready-yes-blueviolet.svg)](AGENTS.md)

A technology-agnostic **repository governance and context-recovery baseline** for long-lived, AI-assisted software projects.

**This is not an application starter kit.** It intentionally contains no framework, runtime, database, auth, UI, state-management, cloud, or product-architecture assumptions.

<p align="center">
  <img src="docs/assets/default-project-hero.svg" alt="Cartoon illustration of Default Project as an open-source, AI-agent-ready development workspace" width="900">
</p>

> **One governance baseline. Any stack. Fresh agents recover project state from repository evidence instead of guessing from conversation history.**

## Quick start

### 1. Install `default-init` once

From a cloned copy of this repository:

```bash
bash scripts/install-default-init.sh
```

For a fresh machine, download the installer first so you can inspect it before executing it:

```bash
curl -fsSLo /tmp/install-default-init.sh \
  https://raw.githubusercontent.com/senoldogann/Default-project/main/scripts/install-default-init.sh
bash /tmp/install-default-init.sh
```

The installer places `default-init` in `~/.local/bin` by default and prints the exact PATH line if that directory is not already available in your shell.

### 2. Create a project with one command

```bash
default-init ~/Desktop/MyProject
```

That command:

- creates the directory when needed,
- refuses to overwrite a non-empty directory,
- downloads the current portable baseline,
- copies only the paths approved by `baseline.manifest`,
- creates a minimal project README,
- initializes a fresh git repository on `main`,
- runs the baseline integrity validator,
- does **not** copy Default Project git history.

Canonical-only files such as this repository's `LICENSE`, `CODEOWNERS`, artwork, maintainer plans, and CLI source are deliberately not copied. Your new project chooses its own license, ownership, product documentation, and architecture.

### Optional: create and secure the GitHub repository too

Private by default:

```bash
default-init ~/Desktop/MyProject --github
```

Explicitly public:

```bash
default-init ~/Desktop/MyOpenSourceProject --github --public
```

`--github` requires an authenticated GitHub CLI (`gh auth login`) and configured git `user.name` / `user.email`. It creates the initial commit, creates and pushes the GitHub repository, then applies the generic repository governance/security setup. It never applies the canonical `--template-origin` mode to derived projects.

### Baseline status

Inside a generated project:

```bash
default-init check
default-init upgrade
default-init version
```

`check` compares the local `.agent/BASELINE_VERSION` with the current upstream baseline. `upgrade` is intentionally **non-destructive** in v1.1.0: it reports drift and points to the upgrade policy, but never overwrites project-specific files.

## Why this exists

Long-running AI-assisted development usually fails in boring ways: stale chat context, invented project facts, forgotten decisions, gigantic instruction files, and agents confidently announcing tests they never ran. This baseline makes those failure modes harder by moving durable state into the repository and keeping always-on context deliberately small.

### What it optimizes for

- **Minimal always-on context** — one short canonical `AGENTS.md`, not a giant prompt manual.
- **Repository-backed truth** — code, tests, contracts, git, ADRs, and maintained docs outrank conversation memory.
- **Progressive disclosure** — agents search first and read deeper architecture, plans, and history only when relevant.
- **Cross-session recovery** — unfinished long tasks can leave a compact, verifiable handoff.
- **Evidence before confidence** — fixes and test results are reported only after verification.
- **Provider-neutral operation** — the core contract is not tied to a language, framework, model, or vendor.
- **Open-source friendly defaults** — contribution/security policies, issue/PR templates, dependency updates, and reusable repository-governance helpers.
- **Safe distribution** — a portable allowlist prevents canonical maintainer metadata from leaking into every generated project.

## Architectural boundary

This repository deliberately stops at **agent/context/repository governance**.

Belongs here:

- agent operating and context rules,
- handoff, ADR, and execution-plan conventions,
- repository security and contribution policy,
- generic GitHub governance helpers,
- harness integrity and distribution checks.

Does **not** belong here:

- React, Next.js, Expo, FastAPI, Go service layouts, or other framework scaffolds,
- auth, databases, ORMs, state management, UI kits, cloud/provider assumptions,
- shared runtime code copied into every project,
- product-specific architecture.

Reusable runtime/configuration code should become a **versioned package**. Conditional stack-specific setup should become a **generator** or narrowly named **archetype**. This baseline should remain small and boring enough to fit almost anywhere.

## GitHub Template Repository fallback

This repository is also a GitHub Template Repository, so **Use this template** remains available. It creates a normal independent GitHub snapshot.

For most new projects, `default-init` is the recommended path because it copies only the portable baseline. GitHub's native template mechanism copies the complete repository snapshot, including canonical open-source metadata and maintainer/distribution files, which you must then review and customize for the new project.

## Fresh-session recovery

A new agent should normally recover state like this instead of asking for the old conversation:

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

<p align="center">
  <img src="docs/assets/default-project-workflow.svg" alt="Cartoon workflow showing how a developer uses the template, works with AI agents, stays organized, and ships" width="900">
</p>

## Context budget

`AGENTS.md` is the canonical standing contract. CI enforces hard anti-bloat limits:

- `AGENTS.md`: **100 lines maximum** and **9,000 bytes maximum**.
- `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`: **1,024 bytes maximum each** and must point back to `AGENTS.md`.
- The rest of `docs/` is cold context and should be retrieved on demand.

These limits are guardrails, not targets. Shorter is better when the same behavior can be preserved.

## Repository map

| Path | Purpose | Portable? |
| --- | --- | --- |
| `AGENTS.md` | Canonical agent operating contract and navigation map | Yes |
| `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md` | Thin provider bootstraps | Yes |
| `.agent/BASELINE_VERSION` | Snapshot version of the governance baseline | Yes |
| `.agent/HANDOFF.md` | Temporary unfinished-work handoff, created only when needed | Runtime only |
| `docs/architecture/` | Stable architecture maps and invariants | Baseline templates only |
| `docs/decisions/` | Durable ADR conventions/templates | Baseline templates only |
| `docs/plans/` | Active/completed execution-plan conventions/templates | Baseline templates only |
| `docs/reliability/` | Verification, GitHub protection, and upgrade guidance | Selected files |
| `scripts/checkpoint.sh` | Read-only git recovery snapshot | Yes |
| `scripts/validate-template.sh` | Harness integrity checks | Yes |
| `scripts/setup-github-repository.sh` | Generic GitHub governance/security setup | Yes |
| `baseline.manifest` | Explicit portable-file allowlist | Canonical only |
| `bin/default-init` | Local project bootstrap CLI | Canonical only |
| `scripts/install-default-init.sh` | CLI installer | Canonical only |
| `scripts/test-default-init.sh` | CLI distribution tests | Canonical only |

## Baseline version and upgrades

The current baseline is recorded in `.agent/BASELINE_VERSION` and changes are documented in [`docs/reliability/BASELINE_CHANGELOG.md`](docs/reliability/BASELINE_CHANGELOG.md).

Generated repositories are **snapshots**, not live children of this repository. That is intentional. Project-specific `AGENTS.md`, CI, architecture, and workflow decisions must be allowed to diverge.

Never blindly overwrite a derived repository with a newer baseline. Review the changelog, port useful security/governance improvements deliberately, run the project's real verification, and update `.agent/BASELINE_VERSION` only after reconciliation. See [`docs/reliability/UPGRADING.md`](docs/reliability/UPGRADING.md).

## Handoff lifecycle

Do **not** maintain a permanent transcript-shaped memory file. For unfinished work that genuinely needs another session, copy `.agent/HANDOFF.example.md` to `.agent/HANDOFF.md`, fill it with verified state, and keep it compact.

When the work finishes, delete the temporary handoff. Durable knowledge belongs with its owner: behavior in code/tests, decisions in ADRs, architecture in maintained docs, and implementation history in git/PRs.

## Plan and ADR rule of thumb

Use a plan when work spans multiple meaningful steps, sessions, or agents. Use an ADR when a choice has lasting architectural consequences. A one-line bug fix needs neither. Markdown quantity remains a surprisingly poor proxy for engineering quality.

## Verification

Canonical CI verifies:

```bash
bash scripts/validate-template.sh
bash scripts/test-github-setup.sh
bash scripts/test-default-init.sh
```

It also performs a live bootstrap smoke test against the current branch archive. Generated projects retain the technology-neutral harness checks but do not receive the canonical CLI/distribution sources.

Application tests are intentionally **not** guessed by this baseline. Each project should encode its real build/test/lint/typecheck commands in CI or repository scripts, then let agents discover and execute those sources of truth.

## Repository setup and protection

For a repository initialized without `--github`, an authenticated repository admin can later apply the generic GitHub defaults with:

```bash
bash scripts/setup-github-repository.sh owner/repository
```

The setup installs or updates the recommended default-branch ruleset and configures squash-only merge hygiene. For public repositories, it also attempts to enable Dependabot alerts/security updates, secret scanning and push protection, and private vulnerability reporting when GitHub supports them.

The canonical `senoldogann/Default-project` repository alone may use:

```bash
bash scripts/setup-github-repository.sh senoldogann/Default-project --template-origin
```

`--template-origin` is rejected for derived repositories.

## Open source and security

This canonical repository is released under the [MIT License](LICENSE). Contributions are welcome; start with [CONTRIBUTING.md](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md).

Security-sensitive reports should follow [SECURITY.md](SECURITY.md). Please do not put vulnerability details or credentials into public issues, pull requests, screenshots, logs, or agent prompts.

The repository protection baseline requires PR-gated changes, the `validate` status check on an up-to-date branch, resolved review conversations, linear squash-only history, and blocks force pushes/deletion. Solo-maintainer defaults require no separate approval; teams can raise the review threshold and require CODEOWNER approval.

## Provider compatibility

The provider-neutral contract is root `AGENTS.md`. Tiny bootstrap files cover tools that discover provider-specific filenames without creating separate policy copies. Other coding agents can use the same repository contract by reading `AGENTS.md` at session start. If a tool requires a different bootstrap filename, prefer a tiny pointer rather than duplicating policy.

## Design basis

This structure is informed by public agent-engineering and repository-security guidance available on **2026-09-07**:

- OpenAI: repository knowledge as system of record, short `AGENTS.md`, structured execution plans, and progressive disclosure — https://openai.com/index/harness-engineering/
- OpenAI: externalized agent state and rehydration for durable long-running work — https://openai.com/index/the-next-evolution-of-the-agents-sdk/
- Anthropic: finite-context engineering, git/progress artifacts, structured handoffs, and independent evaluation — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents and https://www.anthropic.com/engineering/harness-design-long-running-apps
- GitHub: template repositories are independent snapshots; rulesets provide PR/status-check/linear-history/force-push controls — https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template and https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets
- Cursor: `AGENTS.md` as a project instruction format — https://cursor.com/docs/rules

The common idea is simple: preserve **high-signal durable state**, retrieve it selectively, verify outcomes in the environment, and keep reusable application code out of a generic governance baseline.

## License

MIT © 2026 Senol Dogan. See [LICENSE](LICENSE).
