# Execution plans

Use a durable plan only when work benefits from coordination across multiple meaningful steps, sessions, or agents. Small and local changes should stay small; bureaucracy does not become intelligence merely because Markdown is involved.

## Lifecycle

1. Create a plan in `active/` using `PLAN-TEMPLATE.md`.
2. Keep progress, decisions, verification evidence, blockers, and the exact next action current while work is active.
3. On completion, extract durable architectural knowledge into ADRs or normal docs when warranted.
4. Move the plan to `completed/` only if its history remains useful; otherwise delete it and rely on git/PR history.

Plans are coordination artifacts, not source code specifications frozen forever. Verify their claims against current repository evidence after long gaps.
