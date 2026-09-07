# Temporary agent state

This directory is for **short-lived cross-session coordination** plus one tiny baseline-version marker. It is not a permanent transcript or a second documentation tree.

`.agent/BASELINE_VERSION` records which agent/repository-governance baseline this project was created from or last deliberately reconciled with. It is not the application version and must not be treated as an automatically synchronized dependency. See `docs/reliability/UPGRADING.md`.

Create `.agent/HANDOFF.md` only when unfinished work is likely to continue in another session or be picked up by another agent. Start from `HANDOFF.example.md`, keep it compact, and verify every claim against the repository before relying on it.

When the handoff is no longer useful, delete it. Move durable information to the proper owner instead:

- code behavior → code and tests
- architectural decisions → `docs/decisions/`
- ongoing multi-step work → `docs/plans/active/`
- finished implementation history → git commits and pull requests
- stable project guidance → maintained documentation

Do not store transcripts, chain-of-thought, secrets, credentials, or speculative notes here.
