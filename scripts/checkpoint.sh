#!/usr/bin/env bash
set -eu

if ! command -v git >/dev/null 2>&1; then
  printf 'checkpoint: git is required\n' >&2
  exit 1
fi

root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$root" ]; then
  printf 'checkpoint: run this inside a git repository\n' >&2
  exit 1
fi

cd "$root"
branch=$(git symbolic-ref --short -q HEAD || printf 'DETACHED')
head=$(git rev-parse HEAD)

printf '%s\n' '=== repository checkpoint ==='
printf 'root: %s\n' "$root"
printf 'branch: %s\n' "$branch"
printf 'head: %s\n' "$head"

printf '\n%s\n' '--- worktree ---'
status=$(git status --short)
if [ -n "$status" ]; then
  printf '%s\n' "$status"
else
  printf '%s\n' 'clean'
fi

printf '\n%s\n' '--- unstaged diffstat ---'
unstaged=$(git diff --stat -- .)
if [ -n "$unstaged" ]; then
  printf '%s\n' "$unstaged"
else
  printf '%s\n' 'none'
fi

printf '\n%s\n' '--- staged diffstat ---'
staged=$(git diff --cached --stat -- .)
if [ -n "$staged" ]; then
  printf '%s\n' "$staged"
else
  printf '%s\n' 'none'
fi

printf '\n%s\n' '--- recent commits ---'
git log -5 --oneline --decorate=no
