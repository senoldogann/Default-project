# Temporary agent state

This directory is for **short-lived cross-session coordination**, not permanent project knowledge.

Create `.agent/HANDOFF.md` only when unfinished work is likely to continue in another session or be picked up by another agent. Start from `HANDOFF.example.md`, keep it compact, and verify every claim against the repository before relying on it.

When the handoff is no longer useful, delete it. Move durable information to the proper owner instead:

- code behavior → code and tests
- architectural decisions → `docs/decisions/`
- ongoing multi-step work → `docs/plans/active/`
- finished implementation history → git commits and pull requests
- stable project guidance → maintained documentation

Do not store transcripts, chain-of-thought, secrets, credentials, or speculative notes here.
