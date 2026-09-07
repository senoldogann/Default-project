# Upgrading the agent/repository baseline

Repositories initialized from Default Project are snapshots, not live children of the canonical repository. That is intentional: project-specific rules and architecture must be free to diverge without an upstream baseline overwriting them.

## What the baseline version means

`.agent/BASELINE_VERSION` records the agent/repository-governance baseline that existed when the project was created or last deliberately reconciled.

It is **not** an application version and it is **not** a package dependency. Baseline changes are summarized in `BASELINE_CHANGELOG.md`.

## Check for drift

If `default-init` is installed, run this from a derived project:

```bash
default-init check
```

It reports the local baseline and the current upstream baseline without changing files.

`default-init upgrade` is also deliberately non-destructive in v1.1.0. It reports the same version gap and upgrade guidance, but it never overwrites project-specific `AGENTS.md`, CI, docs, scripts, or application code.

## Upgrade policy

When a newer Default Project baseline exists:

1. Run `default-init check` or inspect the current upstream `.agent/BASELINE_VERSION`.
2. Read `BASELINE_CHANGELOG.md` for the newer baseline and compare relevant harness files when necessary.
3. Classify each change as security/reliability, agent-operating policy, GitHub governance, or optional documentation.
4. Port only changes that are useful to the derived repository.
5. Preserve project-specific `AGENTS.md`, CI, architecture, and workflow decisions unless the new baseline intentionally supersedes them.
6. Run the derived project's real validation commands plus `bash scripts/validate-template.sh` when the harness itself changed.
7. Update `.agent/BASELINE_VERSION` only after the selected changes are merged and verified.

Never blindly merge or overwrite a derived project from the canonical repository. A baseline should provide reusable governance, not become a remote-controlled application architecture.

## What belongs in the baseline

Good baseline material is technology-neutral and has low churn:

- agent context/recovery rules,
- evidence and verification discipline,
- handoff/ADR/plan conventions,
- repository security and contribution policy,
- generic GitHub governance helpers.

Do **not** move framework or product architecture into this baseline. Shared runtime/configuration code should be delivered as versioned packages; conditional stack setup belongs in a generator or stack-specific archetype.
