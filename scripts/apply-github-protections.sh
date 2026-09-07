#!/usr/bin/env bash
set -euo pipefail

RULESET_NAME='Default Project: main protection'
API_VERSION='2026-03-10'

if ! command -v gh >/dev/null 2>&1; then
  printf 'apply-github-protections: GitHub CLI (gh) is required\n' >&2
  exit 1
fi

repo=${1:-}
if [ -z "$repo" ]; then
  repo=$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null || true)
fi

if [ -z "$repo" ] || [[ "$repo" != */* ]]; then
  printf 'usage: %s owner/repository\n' "$0" >&2
  exit 1
fi

payload=$(mktemp)
trap 'rm -f "$payload"' EXIT

cat >"$payload" <<JSON
{
  "name": "$RULESET_NAME",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["~DEFAULT_BRANCH"],
      "exclude": []
    }
  },
  "rules": [
    {"type": "deletion"},
    {"type": "non_fast_forward"},
    {
      "type": "pull_request",
      "parameters": {
        "allowed_merge_methods": ["merge", "squash", "rebase"],
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_approving_review_count": 0,
        "required_review_thread_resolution": true
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "do_not_enforce_on_create": true,
        "required_status_checks": [
          {"context": "validate"}
        ],
        "strict_required_status_checks_policy": true
      }
    }
  ]
}
JSON

ruleset_id=$(gh api \
  -H "X-GitHub-Api-Version: $API_VERSION" \
  "repos/$repo/rulesets" \
  --jq ".[] | select(.name == \"$RULESET_NAME\") | .id" | head -n 1)

if [ -n "$ruleset_id" ]; then
  printf 'Updating ruleset %s (%s) on %s...\n' "$RULESET_NAME" "$ruleset_id" "$repo"
  gh api \
    --method PUT \
    -H "X-GitHub-Api-Version: $API_VERSION" \
    "repos/$repo/rulesets/$ruleset_id" \
    --input "$payload" >/dev/null
else
  printf 'Creating ruleset %s on %s...\n' "$RULESET_NAME" "$repo"
  gh api \
    --method POST \
    -H "X-GitHub-Api-Version: $API_VERSION" \
    "repos/$repo/rulesets" \
    --input "$payload" >/dev/null
fi

printf 'Protection ruleset is active for the default branch.\n'
