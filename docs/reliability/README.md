# Reliability and verification

Store repository-specific guidance here only when it cannot be discovered reliably from manifests, CI, scripts, or normal project documentation.

Baseline-level references in this template:

- `GITHUB_PROTECTIONS.md` — default-branch, PR, merge, and public-repository security setup.
- `UPGRADING.md` — safe upgrade policy for repositories created from a snapshot of this baseline.
- `BASELINE_CHANGELOG.md` — versioned changes to the reusable agent/context/repository-governance baseline.

Good project-specific candidates include:

- how to run the canonical validation suite,
- required end-to-end or smoke-test workflows,
- environment assumptions needed for reproducible tests,
- known reliability invariants,
- release or deployment verification steps,
- observability expectations for high-risk changes.

Prefer executable checks over prose. If a command can be encoded in CI or a repository script, do that and keep this directory as a short map to the executable source of truth.
