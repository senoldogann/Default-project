# Project knowledge map

This directory stores durable project knowledge that should survive chat resets and agent changes. It is intentionally split so agents can retrieve only what a task needs.

**Do not read this entire tree by default.** Start from `AGENTS.md`, search for the current task, and open only relevant documents.

## Areas

- `architecture/` — stable system boundaries, data flow, components, and invariants when the project needs architecture documentation.
- `decisions/` — accepted architecture decision records for choices with lasting consequences.
- `plans/active/` — execution plans for ongoing non-trivial work.
- `plans/completed/` — retained plans whose history remains useful.
- `reliability/` — project-specific validation guidance plus baseline GitHub-protection and upgrade policy.

The baseline itself is versioned in `.agent/BASELINE_VERSION`. Repositories created from the template are independent snapshots; use `reliability/UPGRADING.md` when selectively adopting later baseline improvements.

Add documentation only when it reduces future ambiguity or recovery cost. Prefer deleting stale material over preserving it for nostalgia, a pastime git history already handles perfectly well.
