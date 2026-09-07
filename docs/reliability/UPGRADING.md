# Upgrading the agent/repository baseline

Repositories created from a GitHub template are snapshots, not live children of the template. That is intentional: project-specific rules and architecture must be free to diverge without an upstream template overwriting them.

## What the baseline version means

`.agent/BASELINE_VERSION` records the agent/repository-governance baseline that existed when the project was created or last deliberately reconciled.

It is **not** an application version and it is **not** a package dependency. Baseline changes are summarized in `BASELINE_CHANGELOG.md`.

## Upgrade policy

When a newer Default Project baseline exists:

1. Read `BASELINE_CHANGELOG.md` for the newer baseline and compare relevant harness files when necessary.
2. Classify each change as security/reliability, agent-operating policy, GitHub governance, or optional documentation.
3. Port only changes that are useful to the derived repository.
4. Preserve project-specific `AGENTS.md`, CI, architecture, and workflow decisions unless the new baseline intentionally supersedes them.
5. Run the derived project's real validation commands plus `bash scripts/validate-template.sh` when the harness itself changed.
6. Update `.agent/BASELINE_VERSION` only after the selected changes are merged and verified.

Never blindly merge or overwrite a derived project from the template repository. A template baseline should provide reusable governance, not become a remote-controlled application architecture.

## What belongs in the baseline

Good baseline material is technology-neutral and has low churn:

- agent context/recovery rules,
- evidence and verification discipline,
- handoff/ADR/plan conventions,
- repository security and contribution policy,
- generic GitHub governance helpers.

Do **not** move framework or product architecture into this baseline. Shared runtime/configuration code should be delivered as versioned packages; conditional stack setup belongs in a generator or stack-specific archetype.
