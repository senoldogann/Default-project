#!/usr/bin/env bash
set -eu

if ! command -v git >/dev/null 2>&1; then
  printf 'validate-template: git is required\n' >&2
  exit 1
fi

root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$root" ]; then
  printf 'validate-template: run this inside a git repository\n' >&2
  exit 1
fi
cd "$root"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

required_files='AGENTS.md
CLAUDE.md
GEMINI.md
.agent/README.md
.agent/BASELINE_VERSION
.agent/HANDOFF.example.md
docs/README.md
docs/architecture/README.md
docs/decisions/README.md
docs/decisions/ADR-TEMPLATE.md
docs/plans/README.md
docs/plans/PLAN-TEMPLATE.md
docs/reliability/README.md
docs/reliability/BASELINE_CHANGELOG.md
docs/reliability/GITHUB_PROTECTIONS.md
docs/reliability/UPGRADING.md
.github/copilot-instructions.md
.github/workflows/template-integrity.yml
scripts/checkpoint.sh
scripts/validate-template.sh
scripts/apply-github-protections.sh
scripts/setup-github-repository.sh
scripts/test-github-setup.sh'

printf '%s\n' 'Checking agent-harness files...'
printf '%s\n' "$required_files" | while IFS= read -r file; do
  [ -f "$file" ] || fail "missing required harness file: $file"
done

baseline_version=$(tr -d '\r\n' < .agent/BASELINE_VERSION)
printf '%s' "$baseline_version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || fail ".agent/BASELINE_VERSION must contain semantic version x.y.z"
printf 'Baseline version: %s\n' "$baseline_version"

agents_lines=$(wc -l < AGENTS.md | tr -d ' ')
agents_bytes=$(wc -c < AGENTS.md | tr -d ' ')
[ "$agents_lines" -le 100 ] || fail "AGENTS.md has $agents_lines lines; maximum is 100"
[ "$agents_bytes" -le 9000 ] || fail "AGENTS.md has $agents_bytes bytes; maximum is 9000"
printf 'AGENTS.md budget: %s lines, %s bytes\n' "$agents_lines" "$agents_bytes"

for bridge in CLAUDE.md GEMINI.md .github/copilot-instructions.md; do
  grep -q 'AGENTS.md' "$bridge" || fail "$bridge must reference canonical AGENTS.md"
  bridge_bytes=$(wc -c < "$bridge" | tr -d ' ')
  [ "$bridge_bytes" -le 1024 ] || fail "$bridge has $bridge_bytes bytes; maximum is 1024"
done

for heading in '## Start every task' '## Evidence priority' '## Context discipline' '## Verification contract' '## Session handoff'; do
  grep -qF "$heading" AGENTS.md || fail "AGENTS.md missing required section: $heading"
done

for file in AGENTS.md CLAUDE.md GEMINI.md .github/copilot-instructions.md .agent/BASELINE_VERSION; do
  last_byte=$(tail -c 1 "$file" | od -An -t x1 | tr -d '[:space:]')
  [ "$last_byte" = '0a' ] || fail "$file must end with a newline"
done

for script in \
  scripts/checkpoint.sh \
  scripts/validate-template.sh \
  scripts/apply-github-protections.sh \
  scripts/setup-github-repository.sh \
  scripts/test-github-setup.sh; do
  bash -n "$script"
done

[ -x scripts/checkpoint.sh ] || fail 'scripts/checkpoint.sh must be executable'
[ -x scripts/validate-template.sh ] || fail 'scripts/validate-template.sh must be executable'
[ -x scripts/apply-github-protections.sh ] || fail 'scripts/apply-github-protections.sh must be executable'

printf '%s\n' 'PASS: agent-harness integrity checks succeeded'
