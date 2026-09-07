# Contributing

Thanks for helping improve Default Project. The repository is intentionally small, so contributions should preserve that property rather than rewarding complexity for its own sake.

## Before opening a pull request

1. Open or reference an issue when the change is non-trivial or changes public behavior.
2. Create a focused branch from the latest `main`.
3. Read `AGENTS.md` before changing agent-facing behavior.
4. Inspect existing patterns before introducing new files, dependencies, or conventions.
5. Keep the change narrowly scoped. Unrelated cleanup belongs in a separate pull request.
6. Run the checks relevant to your change and report the exact commands/results in the PR.

For changes to the template harness, run:

```bash
bash scripts/validate-template.sh
bash scripts/checkpoint.sh
```

## Pull requests

A useful pull request explains:

- the outcome and why it matters,
- what is intentionally out of scope,
- verification evidence,
- compatibility or security risk,
- documentation/ADR impact,
- unresolved assumptions.

The PR template already asks for these details. Please do not replace evidence with statements such as "works for me" when a reproducible command or workflow is available.

## AI-assisted contributions

AI-assisted work is welcome. The contributor remains responsible for the submitted change.

- Review generated code and text before submitting it.
- Do not claim tests or research were performed unless they actually were.
- Do not paste secrets, private data, proprietary source, or confidential conversations into prompts or PRs.
- Prefer repository evidence over a model's memory or confident guess.
- Keep generated documentation concise and current.

## Security-sensitive changes

Do not disclose suspected vulnerabilities in public issues or pull requests. Follow `SECURITY.md`.

Changes under `.github/workflows/`, `scripts/`, `AGENTS.md`, and security policy files receive explicit owner attention through `CODEOWNERS`.

## Style

Follow the existing repository style and `.editorconfig`. Derived projects should follow their own stack-native formatter/linter rather than importing a global style policy from this template.

## License

By contributing, you agree that your contribution is distributed under the repository's MIT License.
