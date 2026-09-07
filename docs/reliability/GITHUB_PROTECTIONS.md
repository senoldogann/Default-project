# GitHub repository protections

Files can travel with a GitHub template; repository settings generally do not. This document defines the recommended technology-neutral baseline for each repository created from this template.

## Recommended default-branch ruleset

Target: `~DEFAULT_BRANCH`

Enforce:

- require a pull request before merge,
- require status check `validate`,
- require the branch to be up to date before merge,
- require review conversations to be resolved,
- require linear history,
- allow squash merge as the canonical merge method,
- block force pushes,
- block branch deletion.

For a solo-maintainer repository, the baseline uses **0 mandatory approvals** so the maintainer can merge their own reviewed PR after CI. `CODEOWNERS` still requests the maintainer on sensitive changes.

For a team repository, strengthen the pull-request rule to:

- at least 1 approving review,
- dismiss stale approvals on new commits,
- require CODEOWNER review for owned paths,
- optionally require approval of the most recent reviewable push.

Do not add an unrestricted admin bypass merely to make automation convenient. If a bypass is necessary, scope it narrowly and document why.

## Apply the complete repository baseline

With `gh` authenticated to an account that has repository Administration write permission:

```bash
bash scripts/setup-github-repository.sh owner/repository
```

The setup helper configures merge hygiene, invokes the idempotent branch-ruleset helper, and for public repositories attempts to enable Dependabot alerts/security updates, secret scanning with push protection, and private vulnerability reporting.

For the canonical `senoldogann/Default-project` repository only:

```bash
bash scripts/setup-github-repository.sh senoldogann/Default-project --template-origin
```

That additional flag enables GitHub's Template Repository mode and installs the canonical public description/topics. The script rejects the flag for derived repositories.

## Lower-level ruleset helper

If only the branch ruleset needs to be created or reconciled:

```bash
bash scripts/apply-github-protections.sh owner/repository
```

The helper is idempotent by ruleset name: it creates the baseline ruleset when absent and updates the existing baseline when present.

## Pull-request workflow security

Treat fork PR contents as attacker-controlled until reviewed.

- Prefer `pull_request` for validation of untrusted PR code.
- Keep `GITHUB_TOKEN` permissions at the minimum needed.
- Do not expose repository secrets to fork PR code.
- Avoid `pull_request_target` unless privileged behavior is genuinely required.
- Never use a privileged workflow to check out and execute untrusted PR code.
- Pin third-party actions to immutable commit SHAs; use Dependabot to keep pins current.

The template's integrity workflow follows these rules: it uses `pull_request`, grants only `contents: read`, and pins `actions/checkout` to a full commit SHA.

## Do not confuse governance with application architecture

These settings protect repository history and contribution flow. They do not choose a framework, deployment platform, database, testing stack, or application architecture. Derived projects should add those controls only when their actual requirements justify them.
