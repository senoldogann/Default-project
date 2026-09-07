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
.agent/HANDOFF.example.md
docs/README.md
docs/architecture/README.md
docs/decisions/README.md
docs/decisions/ADR-TEMPLATE.md
docs/plans/README.md
docs/plans/PLAN-TEMPLATE.md
docs/reliability/README.md
.github/copilot-instructions.md
.github/workflows/template-integrity.yml
scripts/checkpoint.sh
scripts/validate-template.sh'

printf '%s\n' 'Checking agent-harness files...'
printf '%s\n' "$required_files" | while IFS= read -r file; do
  [ -f "$file" ] || fail "missing required harness file: $file"
done

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

for file in AGENTS.md CLAUDE.md GEMINI.md .github/copilot-instructions.md; do
  last_byte=$(tail -c 1 "$file" | od -An -t x1 | tr -d '[:space:]')
  [ "$last_byte" = '0a' ] || fail "$file must end with a newline"
done

bash -n scripts/checkpoint.sh
bash -n scripts/validate-template.sh
[ -x scripts/checkpoint.sh ] || fail 'scripts/checkpoint.sh must be executable'
[ -x scripts/validate-template.sh ] || fail 'scripts/validate-template.sh must be executable'

printf '%s\n' 'PASS: agent-harness integrity checks succeeded'
