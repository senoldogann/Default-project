# Security Policy

## Reporting a vulnerability

Please do **not** disclose suspected vulnerabilities, credentials, tokens, private keys, or exploit details in a public issue, discussion, pull request, screenshot, log, or agent prompt.

Use GitHub's private vulnerability reporting / security advisory flow for this repository when available:

`Security` → `Advisories` → `Report a vulnerability`

If private vulnerability reporting is unavailable, open a public issue containing **no vulnerability details** and ask the maintainer for a private reporting channel.

## What to include privately

Provide only what is needed to reproduce and evaluate the report:

- affected file, commit, version, or configuration,
- minimal reproduction steps,
- expected vs. observed security boundary,
- impact and prerequisites,
- suggested mitigation if known.

Never include real production credentials. Use redacted or disposable test values.

## Supported version

This template is maintained on the latest `main` branch. Security fixes are not guaranteed to be backported to old template snapshots or repositories previously created from the template.

## Pull-request security model

Untrusted fork pull requests must be treated as untrusted code. Repository workflows should use least-privilege `GITHUB_TOKEN` permissions and should not combine privileged triggers or secrets with execution of untrusted PR code.

In particular, do not introduce `pull_request_target` workflows that check out and execute pull-request code unless the security implications are fully understood and independently reviewed.
