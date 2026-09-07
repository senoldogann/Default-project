#!/usr/bin/env bash
set -euo pipefail

API_VERSION='2026-03-10'
TEMPLATE_ORIGIN='senoldogann/Default-project'
TEMPLATE_DESCRIPTION='A repository governance and context-recovery baseline for reliable AI-assisted software development.'

usage() {
  cat <<'EOF'
usage: scripts/setup-github-repository.sh [owner/repository] [--template-origin]

Configures technology-neutral GitHub repository governance:
- squash merge as the canonical merge method,
- delete branches after merge,
- allow PR branches to be updated,
- recommended default-branch protection ruleset,
- private vulnerability reporting when supported for a public repository.

--template-origin additionally configures senoldogann/Default-project as the
GitHub Template Repository and installs its public description/topics. The flag
is intentionally rejected for derived repositories.
EOF
}

if ! command -v gh >/dev/null 2>&1; then
  printf 'setup-github-repository: GitHub CLI (gh) is required\n' >&2
  exit 1
fi

repo=''
template_origin=false
for arg in "$@"; do
  case "$arg" in
    --template-origin) template_origin=true ;;
    -h|--help) usage; exit 0 ;;
    -*) printf 'unknown option: %s\n' "$arg" >&2; usage >&2; exit 1 ;;
    *)
      if [ -n "$repo" ]; then
        printf 'unexpected argument: %s\n' "$arg" >&2
        usage >&2
        exit 1
      fi
      repo=$arg
      ;;
  esac
done

if [ -z "$repo" ]; then
  repo=$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null || true)
fi

if [ -z "$repo" ] || [[ "$repo" != */* ]]; then
  printf 'setup-github-repository: repository must be owner/name\n' >&2
  usage >&2
  exit 1
fi

if $template_origin && [ "$repo" != "$TEMPLATE_ORIGIN" ]; then
  printf '%s\n' "setup-github-repository: --template-origin is only valid for $TEMPLATE_ORIGIN" >&2
  exit 1
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

cat >"$tmp" <<'JSON'
{
  "allow_squash_merge": true,
  "allow_merge_commit": false,
  "allow_rebase_merge": false,
  "delete_branch_on_merge": true,
  "allow_update_branch": true
}
JSON

printf 'Configuring merge hygiene for %s...\n' "$repo"
gh api \
  --method PATCH \
  -H "X-GitHub-Api-Version: $API_VERSION" \
  "repos/$repo" \
  --input "$tmp" >/dev/null

if $template_origin; then
  cat >"$tmp" <<JSON
{
  "description": "$TEMPLATE_DESCRIPTION",
  "is_template": true
}
JSON
  printf 'Configuring template-origin metadata...\n'
  gh api \
    --method PATCH \
    -H "X-GitHub-Api-Version: $API_VERSION" \
    "repos/$repo" \
    --input "$tmp" >/dev/null

  cat >"$tmp" <<'JSON'
{
  "names": [
    "ai-agents",
    "agentic-development",
    "context-engineering",
    "developer-tools",
    "github-template",
    "llm",
    "open-source",
    "project-template",
    "repository-governance",
    "software-engineering"
  ]
}
JSON
  gh api \
    --method PUT \
    -H "X-GitHub-Api-Version: $API_VERSION" \
    "repos/$repo/topics" \
    --input "$tmp" >/dev/null
fi

bash "$(dirname "$0")/apply-github-protections.sh" "$repo"

visibility=$(gh api \
  -H "X-GitHub-Api-Version: $API_VERSION" \
  "repos/$repo" \
  --jq '.visibility')
if [ "$visibility" = 'public' ]; then
  if gh api \
    --method PUT \
    -H "X-GitHub-Api-Version: $API_VERSION" \
    "repos/$repo/private-vulnerability-reporting" >/dev/null 2>&1; then
    printf 'Private vulnerability reporting is enabled.\n'
  else
    printf 'WARN: private vulnerability reporting could not be enabled; check repository security settings.\n' >&2
  fi
fi

printf '\nVerified repository settings:\n'
gh api \
  -H "X-GitHub-Api-Version: $API_VERSION" \
  "repos/$repo" \
  --jq '{full_name, visibility, is_template, allow_squash_merge, allow_merge_commit, allow_rebase_merge, delete_branch_on_merge, allow_update_branch}'

printf '\nActive repository rulesets:\n'
gh api \
  -H "X-GitHub-Api-Version: $API_VERSION" \
  "repos/$repo/rulesets" \
  --jq '[.[] | {name, enforcement, target}]'
