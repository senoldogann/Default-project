# Agent-Ready Default Project Template Implementation Plan

> **For agentic workers:** Execute task-by-task with verification checkpoints and review each independently testable deliverable before continuing.

**Goal:** Build a provider-neutral GitHub template that preserves agent continuity across fresh sessions while keeping always-on context minimal and requiring repository-backed verification.

**Architecture:** Use a short canonical `AGENTS.md` as the entry point, progressively disclosed repository documentation for durable knowledge, a compact optional handoff for unfinished work, Git-native checkpointing, tiny provider bridge files, and dependency-free CI checks for template invariants.

**Tech Stack:** Markdown, Bash, Git, GitHub Actions YAML. No application runtime or package manager dependency.

**Spec:** `docs/superpowers/specs/2026-09-07-agent-project-template-design.md`

## Global Constraints

- Root `AGENTS.md` is canonical and must remain 100 lines or fewer.
- Always-on project instructions should remain below roughly 2,000 tokens.
- Do not preload the documentation tree; use progressive disclosure.
- Do not introduce an application framework, package manager, vector database, MCP dependency, or LLM provider dependency.
- Provider-specific instruction files must remain thin bridges and must not duplicate policy.
- Handoff state is temporary; durable state belongs in code, tests, git history, ADRs, and maintained docs.
- Verification must be evidence-based and must report executed checks accurately.

---

## File map

- `AGENTS.md`: canonical operating contract and navigation map for coding agents.
- `README.md`: human-facing explanation, setup flow, and template usage.
- `CLAUDE.md`: thin Claude bootstrap to canonical instructions.
- `GEMINI.md`: thin Gemini bootstrap to canonical instructions.
- `.github/copilot-instructions.md`: thin Copilot bootstrap to canonical instructions.
- `.agent/README.md`: lifecycle and rules for temporary session state.
- `.agent/HANDOFF.example.md`: compact handoff schema.
- `docs/README.md`: progressive-disclosure documentation map.
- `docs/architecture/README.md`: architecture documentation policy.
- `docs/decisions/README.md`: ADR policy and naming.
- `docs/decisions/ADR-TEMPLATE.md`: decision record template.
- `docs/plans/README.md`: execution-plan lifecycle.
- `docs/plans/PLAN-TEMPLATE.md`: execution-plan template.
- `docs/plans/active/.gitkeep`: preserves active plan directory.
- `docs/plans/completed/.gitkeep`: preserves completed plan directory.
- `docs/reliability/README.md`: repository-specific testing/reliability documentation guidance.
- `scripts/checkpoint.sh`: read-only compact git recovery snapshot.
- `scripts/validate-template.sh`: dependency-free template invariant checks.
- `.github/workflows/template-integrity.yml`: CI entry point for template validation.
- `.github/ISSUE_TEMPLATE/bug.yml`: reproducible bug issue form.
- `.github/ISSUE_TEMPLATE/feature.yml`: outcome-oriented feature issue form.
- `.github/pull_request_template.md`: evidence-oriented PR checklist.
- `.editorconfig`: minimal cross-language text defaults.
- `.gitignore`: only universal/sensitive local artifacts, not language-specific build outputs.

---

### Task 1: Canonical context contract and provider bridges

**Files:**
- Create: `AGENTS.md`
- Create: `CLAUDE.md`
- Create: `GEMINI.md`
- Create: `.github/copilot-instructions.md`

**Interfaces:**
- Consumes: design spec evidence hierarchy and context model.
- Produces: a single canonical agent contract referenced by all provider bridges.

- [ ] Write `AGENTS.md` with startup, progressive-disclosure, evidence, planning, verification, handoff, and change-discipline rules.
- [ ] Count lines and verify `AGENTS.md <= 100`.
- [ ] Create each provider bridge with only a canonical-pointer instruction and no duplicated project policy.
- [ ] Confirm each bridge explicitly names root `AGENTS.md` as canonical.
- [ ] Commit as `feat: add canonical agent context contract`.

### Task 2: Durable docs and temporary handoff schemas

**Files:**
- Create: `.agent/README.md`
- Create: `.agent/HANDOFF.example.md`
- Create: `docs/README.md`
- Create: `docs/architecture/README.md`
- Create: `docs/decisions/README.md`
- Create: `docs/decisions/ADR-TEMPLATE.md`
- Create: `docs/plans/README.md`
- Create: `docs/plans/PLAN-TEMPLATE.md`
- Create: `docs/plans/active/.gitkeep`
- Create: `docs/plans/completed/.gitkeep`
- Create: `docs/reliability/README.md`

**Interfaces:**
- Consumes: `AGENTS.md` navigation rules.
- Produces: structured sources agents can retrieve only when task-relevant.

- [ ] Add documentation map with explicit "read only what is relevant" guidance.
- [ ] Add ADR lifecycle that reserves ADRs for durable architectural consequences.
- [ ] Add plan lifecycle separating active and completed work.
- [ ] Add compact plan template with goal, scope, evidence, progress, decisions, verification, and next action.
- [ ] Add temporary handoff schema with verified HEAD, completed/current/remaining work, evidence, blockers, and next action.
- [ ] Ensure examples do not contain fake project facts.
- [ ] Commit as `feat: add durable planning and handoff structure`.

### Task 3: Git-native checkpoint and template integrity validation

**Files:**
- Create: `scripts/checkpoint.sh`
- Create: `scripts/validate-template.sh`
- Create: `.github/workflows/template-integrity.yml`

**Interfaces:**
- Consumes: git repository state and final template layout.
- Produces: compact recovery output and deterministic CI pass/fail for template invariants.

- [ ] Implement `checkpoint.sh` with `set -eu`, repository-root detection, branch, HEAD, porcelain status, diffstat, and recent commits; do not mutate repository state.
- [ ] Validate shell syntax using `bash -n scripts/checkpoint.sh`.
- [ ] Implement `validate-template.sh` with exact required-file checks, `AGENTS.md` line ceiling, bridge canonical-reference checks, placeholder scan, shell syntax checks, and final construction-doc exclusion.
- [ ] Validate shell syntax using `bash -n scripts/validate-template.sh`.
- [ ] Add GitHub Actions workflow on push and pull request using Ubuntu and `bash scripts/validate-template.sh`.
- [ ] Commit as `ci: add template integrity and checkpoint validation`.

### Task 4: Collaboration templates and human-facing documentation

**Files:**
- Modify: `README.md`
- Create: `.github/ISSUE_TEMPLATE/bug.yml`
- Create: `.github/ISSUE_TEMPLATE/feature.yml`
- Create: `.github/pull_request_template.md`
- Create: `.editorconfig`
- Create: `.gitignore`

**Interfaces:**
- Consumes: completed template contract and helpers.
- Produces: usable GitHub Template Repository onboarding and evidence-oriented issue/PR workflow.

- [ ] Rewrite README with purpose, one-minute startup, fresh-session recovery flow, context-budget rationale, lifecycle, compatibility notes, and customization guidance.
- [ ] Add bug issue form requiring reproduction, expected/actual result, and verification evidence without prescribing technology.
- [ ] Add feature issue form centered on outcome and acceptance criteria.
- [ ] Add PR template requiring scope, tests/checks executed, evidence, docs/ADR impact, and unresolved risks.
- [ ] Add minimal `.editorconfig` without language policy.
- [ ] Add minimal `.gitignore` for OS noise, logs, and local secrets while preserving `.env.example`.
- [ ] Commit as `docs: complete reusable project template`.

### Task 5: Final verification, cleanup, and review

**Files:**
- Delete before merge: `docs/superpowers/specs/2026-09-07-agent-project-template-design.md`
- Delete before merge: `docs/superpowers/plans/2026-09-07-agent-project-template.md`

**Interfaces:**
- Consumes: all previous tasks.
- Produces: a clean derived-project template with construction history retained only in git history/PR.

- [ ] Run `bash scripts/validate-template.sh` and require exit code 0.
- [ ] Run `bash scripts/checkpoint.sh` and inspect output for compactness and correctness.
- [ ] Run `bash -n scripts/checkpoint.sh scripts/validate-template.sh`.
- [ ] Verify root `AGENTS.md` line count is <= 100.
- [ ] Search final tracked files for `TBD`, `TODO`, construction-only instructions, and stale template-development artifacts.
- [ ] Review the complete diff with a fresh reviewer mindset: correctness, context bloat, provider drift, false claims, hidden runtime assumptions, and maintainability.
- [ ] Remove construction-only spec and plan.
- [ ] Re-run `bash scripts/validate-template.sh` after cleanup.
- [ ] Open a PR against `main` containing research basis, exact validation evidence, and remaining limitations.
