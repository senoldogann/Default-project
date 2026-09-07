# Baseline changelog

This changelog tracks the reusable **agent/context/repository-governance baseline**, not the application version of repositories created from this template.

Derived repositories are snapshots. Use this file to decide which later baseline changes are worth porting; do not blindly overwrite project-specific files. See `UPGRADING.md`.

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
