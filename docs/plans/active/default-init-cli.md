# Default Init CLI Implementation Plan

**Goal:** Add a dependency-free `default-init` CLI that bootstraps the current Default Project baseline into a local directory with one command, without copying template git history or overwriting user files.

**Architecture:** Keep `senoldogann/Default-project` as the canonical snapshot baseline. Ship a small Bash CLI in `bin/default-init`, an installer in `scripts/install-default-init.sh`, and black-box shell tests using mocked network/GitHub commands. The CLI downloads the public template archive into a temporary directory, copies only baseline files into an empty target, initializes git, validates the harness, and optionally creates/configures a GitHub repository.

**Tech stack:** Bash, git, curl, tar, GitHub CLI (`gh`) only for optional `--github` behavior.

## Constraints

- No npm/Homebrew/runtime dependency.
- `default-init PATH` is an alias for `default-init new PATH`.
- Refuse non-empty target directories unless they contain only `.DS_Store`.
- Never copy `.git` history from Default Project.
- Default branch is `main`.
- Run `scripts/validate-template.sh` in the generated repository.
- `--github` is optional and requires authenticated `gh`; it creates the remote, pushes `main`, then runs generic repository setup without `--template-origin`.
- `check` compares local `.agent/BASELINE_VERSION` with the latest public baseline and makes no changes.
- `version` reports CLI and baseline versions.
- `upgrade` in v1.1.0 is intentionally non-destructive: it reports the version gap and points to `docs/reliability/UPGRADING.md`; it never overwrites project-specific files.

## Tasks

- [ ] Add black-box tests for help/version, empty-directory bootstrap, non-empty refusal, check behavior, and guarded GitHub mode.
- [ ] Implement `bin/default-init` minimally until tests pass.
- [ ] Add one-command installer to `~/.local/bin/default-init`, with PATH guidance when needed.
- [ ] Extend `validate-template.sh` and CI to validate/test the CLI and installer.
- [ ] Bump baseline to `1.1.0` and record the CLI in `BASELINE_CHANGELOG.md`.
- [ ] Update README with installation and everyday usage.
- [ ] Run PR CI, fresh-review the diff, remove this active plan after durable documentation is complete, squash-merge, and verify `main` CI.
