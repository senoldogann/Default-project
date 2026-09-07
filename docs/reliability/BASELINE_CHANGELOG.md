# Baseline changelog

This changelog tracks the reusable **agent/context/repository-governance baseline**, not the application version of repositories created from this template.

Derived repositories are snapshots. Use this file to decide which later baseline changes are worth porting; do not blindly overwrite project-specific files. See `UPGRADING.md`.

## 1.1.0 — 2026-09-07

Additive distribution and bootstrap improvements:

- `default-init` CLI can initialize the portable baseline into an absent or empty local directory with one command,
- optional `--github` mode creates a GitHub repository and applies the generic repository governance/security setup,
- GitHub repositories created by the CLI are private by default; `--public` is explicit,
- `baseline.manifest` is an explicit allowlist, so canonical-only license, CODEOWNERS, artwork, maintainer plans, and CLI source files are not copied into derived projects,
- generated projects receive a minimal project README and a fresh `main` git repository without Default Project git history,
- `default-init check` reports local vs upstream baseline versions,
- `default-init upgrade` is deliberately non-destructive and never overwrites project-specific files,
- installer support places the CLI in `~/.local/bin` by default,
- CI covers mocked CLI behavior and live bootstrap smoke validation when the distribution files are present.

## 1.0.0 — 2026-09-07

Initial stable baseline:

- short canonical `AGENTS.md` with evidence priority, progressive context loading, verification, and cross-session handoff rules,
- thin Claude, Gemini, and GitHub Copilot bridges pointing back to the canonical contract,
- on-demand architecture, ADR, execution-plan, reliability, and temporary handoff structure,
- context-budget guardrails enforced by CI,
- checkpoint and harness-integrity helpers,
- MIT license, contribution/security/code-of-conduct policies, CODEOWNERS, issue/PR templates, and Dependabot configuration,
- lightweight README artwork,
- GitHub repository setup/protection helpers for PR-gated, squash-only linear history and public-repository security defaults,
- explicit architectural boundary: framework/runtime/product starter code belongs in packages, generators, or stack-specific archetypes rather than this baseline,
- explicit snapshot upgrade policy via `.agent/BASELINE_VERSION` and `UPGRADING.md`.

### Versioning rule

- **Patch**: compatible documentation, security, validation, or agent-policy fixes that do not materially change the baseline contract.
- **Minor**: additive governance/harness capabilities that derived projects may adopt selectively.
- **Major**: intentional changes to baseline contracts, file semantics, or migration expectations that require deliberate reconciliation.
