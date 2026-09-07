#!/usr/bin/env bash
set -euo pipefail

root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$root" ]; then
  printf 'test-default-init: run inside a git repository\n' >&2
  exit 1
fi
cd "$root"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  haystack=$1
  needle=$2
  printf '%s' "$haystack" | grep -qF -- "$needle" || fail "expected output to contain: $needle"
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fixture="$work/fixture/Default-project-main"
mkdir -p "$fixture/.agent" "$fixture/.github" "$fixture/docs/assets" "$fixture/scripts"

cat >"$fixture/AGENTS.md" <<'EOF'
# Test Agent Contract
EOF
printf '%s\n' '1.1.0' >"$fixture/.agent/BASELINE_VERSION"
printf '%s\n' 'canonical-only-license' >"$fixture/LICENSE"
printf '%s\n' '* @template-owner' >"$fixture/.github/CODEOWNERS"
printf '%s\n' 'canonical-art' >"$fixture/docs/assets/hero.svg"

cat >"$fixture/scripts/validate-template.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
[ -f AGENTS.md ]
[ -f .agent/BASELINE_VERSION ]
[ -f scripts/setup-github-repository.sh ]
[ ! -e LICENSE ]
[ ! -e .github/CODEOWNERS ]
[ ! -e docs/assets/hero.svg ]
EOF
chmod +x "$fixture/scripts/validate-template.sh"

cat >"$fixture/scripts/setup-github-repository.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
: "${DEFAULT_INIT_SETUP_LOG:?}"
printf '%s\n' "$1" >>"$DEFAULT_INIT_SETUP_LOG"
EOF
chmod +x "$fixture/scripts/setup-github-repository.sh"

cat >"$fixture/baseline.manifest" <<'EOF'
AGENTS.md
.agent/BASELINE_VERSION
scripts/validate-template.sh
scripts/setup-github-repository.sh
EOF

tar -C "$work/fixture" -czf "$work/baseline.tar.gz" Default-project-main

mkdir -p "$work/mockbin" "$work/home"
cat >"$work/mockbin/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
: "${DEFAULT_INIT_FIXTURE_ARCHIVE:?}"
out=''
url=''
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o|--output) out=$2; shift 2 ;;
    -*) shift ;;
    *) url=$1; shift ;;
  esac
done
if [[ "$url" == *'/BASELINE_VERSION' ]]; then
  latest=${DEFAULT_INIT_LATEST_VERSION:-1.1.0}
  if [ -n "$out" ]; then
    printf '%s\n' "$latest" >"$out"
  else
    printf '%s\n' "$latest"
  fi
else
  [ -n "$out" ] || { printf 'mock curl requires -o for archive\n' >&2; exit 1; }
  cp "$DEFAULT_INIT_FIXTURE_ARCHIVE" "$out"
fi
EOF
chmod +x "$work/mockbin/curl"

cat >"$work/mockbin/gh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
: "${DEFAULT_INIT_GH_LOG:?}"
printf 'gh' >>"$DEFAULT_INIT_GH_LOG"
for arg in "$@"; do printf ' %q' "$arg" >>"$DEFAULT_INIT_GH_LOG"; done
printf '\n' >>"$DEFAULT_INIT_GH_LOG"
if [ "${1:-}" = 'auth' ] && [ "${2:-}" = 'status' ]; then exit 0; fi
if [ "${1:-}" = 'repo' ] && [ "${2:-}" = 'view' ]; then
  printf '%s\n' "acme/${DEFAULT_INIT_EXPECTED_REPO:-project}"
  exit 0
fi
exit 0
EOF
chmod +x "$work/mockbin/gh"

cat >"$work/home/.gitconfig" <<'EOF'
[user]
  name = Default Init Test
  email = default-init@example.invalid
EOF

export DEFAULT_INIT_FIXTURE_ARCHIVE="$work/baseline.tar.gz"
export DEFAULT_INIT_GH_LOG="$work/gh.log"
export DEFAULT_INIT_SETUP_LOG="$work/setup.log"
: >"$DEFAULT_INIT_GH_LOG"
: >"$DEFAULT_INIT_SETUP_LOG"

version_output=$(PATH="$work/mockbin:$PATH" bash bin/default-init version)
[ "$version_output" = 'default-init 1.1.0' ] || fail "unexpected version output: $version_output"

local_target="$work/Local Project"
PATH="$work/mockbin:$PATH" bash bin/default-init "$local_target" >/dev/null
[ -d "$local_target/.git" ] || fail 'new project must initialize git'
[ "$(git -C "$local_target" branch --show-current)" = 'main' ] || fail 'new project branch must be main'
[ "$(cat "$local_target/.agent/BASELINE_VERSION")" = '1.1.0' ] || fail 'baseline version must be copied'
[ -f "$local_target/AGENTS.md" ] || fail 'AGENTS.md must be copied'
[ -x "$local_target/scripts/validate-template.sh" ] || fail 'script executable mode must be preserved'
[ ! -e "$local_target/LICENSE" ] || fail 'canonical template LICENSE must not be copied into derived projects'
[ ! -e "$local_target/.github/CODEOWNERS" ] || fail 'canonical CODEOWNERS must not be copied into derived projects'
[ ! -e "$local_target/docs/assets/hero.svg" ] || fail 'canonical README artwork must not be copied into derived projects'
assert_contains "$(cat "$local_target/README.md")" '# Local Project'

# The common `mkdir && cd && default-init .` flow must use the directory name.
current_target="$work/CurrentProject"
mkdir -p "$current_target"
(
  cd "$current_target"
  PATH="$work/mockbin:$PATH" bash "$root/bin/default-init" . >/dev/null
)
[ -d "$current_target/.git" ] || fail 'current-directory mode must initialize git'
assert_contains "$(cat "$current_target/README.md")" '# CurrentProject'

# Finder noise alone must not make a prepared Desktop folder unusable.
ds_target="$work/DSStoreProject"
mkdir -p "$ds_target"
printf 'finder-noise' >"$ds_target/.DS_Store"
PATH="$work/mockbin:$PATH" bash bin/default-init "$ds_target" >/dev/null
[ -f "$ds_target/AGENTS.md" ] || fail '.DS_Store-only target should be accepted'
[ ! -e "$ds_target/.DS_Store" ] || fail '.DS_Store should be removed during initialization'

bad_target="$work/non-empty"
mkdir -p "$bad_target"
printf '%s\n' 'keep-me' >"$bad_target/existing.txt"
if PATH="$work/mockbin:$PATH" bash bin/default-init "$bad_target" >/dev/null 2>&1; then
  fail 'non-empty target must be rejected'
fi
[ "$(cat "$bad_target/existing.txt")" = 'keep-me' ] || fail 'existing target contents must remain untouched'

if PATH="$work/mockbin:$PATH" bash bin/default-init "$work/no-github" --public >/dev/null 2>&1; then
  fail '--public without --github must be rejected'
fi

# GitHub mode validates the basename before downloading or creating files.
unsafe_github="$work/Github Project"
: >"$DEFAULT_INIT_GH_LOG"
if HOME="$work/home" PATH="$work/mockbin:$PATH" bash bin/default-init "$unsafe_github" --github >/dev/null 2>"$work/unsafe.err"; then
  fail 'GitHub mode must reject an unsafe repository basename'
fi
assert_contains "$(cat "$work/unsafe.err")" 'GitHub mode requires a repository name using only letters, numbers, ., _, or -'
[ ! -e "$unsafe_github" ] || fail 'unsafe GitHub repository name must fail before creating target files'
[ ! -s "$DEFAULT_INIT_GH_LOG" ] || fail 'unsafe GitHub repository name must fail before invoking gh'

check_output=$(cd "$local_target" && PATH="$work/mockbin:$PATH" bash "$root/bin/default-init" check)
assert_contains "$check_output" 'Local baseline:  1.1.0'
assert_contains "$check_output" 'Latest baseline: 1.1.0'
assert_contains "$check_output" 'Baseline is up to date.'

agents_before=$(cat "$local_target/AGENTS.md")
export DEFAULT_INIT_LATEST_VERSION='1.2.0'
upgrade_output=$(cd "$local_target" && PATH="$work/mockbin:$PATH" bash "$root/bin/default-init" upgrade)
assert_contains "$upgrade_output" 'Latest baseline: 1.2.0'
assert_contains "$upgrade_output" 'Baseline differs from the current upstream baseline.'
assert_contains "$upgrade_output" 'No project files were changed.'
[ "$(cat "$local_target/AGENTS.md")" = "$agents_before" ] || fail 'upgrade must not overwrite project files'
unset DEFAULT_INIT_LATEST_VERSION

# GitHub mode must default to private.
: >"$DEFAULT_INIT_GH_LOG"
: >"$DEFAULT_INIT_SETUP_LOG"
export DEFAULT_INIT_EXPECTED_REPO='PrivateProject'
private_target="$work/PrivateProject"
HOME="$work/home" PATH="$work/mockbin:$PATH" bash bin/default-init "$private_target" --github >/dev/null
assert_contains "$(cat "$DEFAULT_INIT_GH_LOG")" 'gh repo create PrivateProject'
assert_contains "$(cat "$DEFAULT_INIT_GH_LOG")" '--private'
assert_contains "$(cat "$DEFAULT_INIT_SETUP_LOG")" 'acme/PrivateProject'

# Public GitHub mode is explicit and creates one initial commit.
: >"$DEFAULT_INIT_GH_LOG"
: >"$DEFAULT_INIT_SETUP_LOG"
export DEFAULT_INIT_EXPECTED_REPO='GithubProject'
github_target="$work/GithubProject"
HOME="$work/home" PATH="$work/mockbin:$PATH" bash bin/default-init "$github_target" --github --public >/dev/null
[ -f "$github_target/.git/HEAD" ] || fail 'GitHub mode must keep a local git repository'
[ "$(git -C "$github_target" rev-list --count HEAD)" = '1' ] || fail 'GitHub mode must create exactly one initial commit'
assert_contains "$(cat "$DEFAULT_INIT_GH_LOG")" 'gh auth status'
assert_contains "$(cat "$DEFAULT_INIT_GH_LOG")" 'gh repo create GithubProject'
assert_contains "$(cat "$DEFAULT_INIT_GH_LOG")" '--public'
assert_contains "$(cat "$DEFAULT_INIT_SETUP_LOG")" 'acme/GithubProject'

install_dir="$work/install-bin"
DEFAULT_INIT_INSTALL_DIR="$install_dir" bash scripts/install-default-init.sh >/dev/null
[ -x "$install_dir/default-init" ] || fail 'installer must install an executable default-init'
[ "$($install_dir/default-init version)" = 'default-init 1.1.0' ] || fail 'installed CLI must report expected version'

printf '%s\n' 'PASS: default-init CLI behavior checks succeeded'
