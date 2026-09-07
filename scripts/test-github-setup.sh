#!/usr/bin/env bash
set -euo pipefail

root=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "$root" ]; then
  printf 'test-github-setup: run inside a git repository\n' >&2
  exit 1
fi
cd "$root"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  file=$1
  pattern=$2
  grep -qF -- "$pattern" "$file" || fail "expected log to contain: $pattern"
}

assert_not_contains() {
  file=$1
  pattern=$2
  if grep -qF -- "$pattern" "$file"; then
    fail "expected log not to contain: $pattern"
  fi
}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin"

cat >"$work/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
: "${GH_MOCK_LOG:?}"
printf 'gh' >>"$GH_MOCK_LOG"
for arg in "$@"; do
  printf ' %q' "$arg" >>"$GH_MOCK_LOG"
done
printf '\n' >>"$GH_MOCK_LOG"

if [ "${1:-}" = 'repo' ] && [ "${2:-}" = 'view' ]; then
  printf '%s\n' 'acme/inferred'
  exit 0
fi

if [ "${1:-}" != 'api' ]; then
  exit 0
fi

method='GET'
input=''
url=''
jq_expr=''
shift
while [ "$#" -gt 0 ]; do
  case "$1" in
    --method) method=$2; shift 2 ;;
    --input) input=$2; shift 2 ;;
    --jq) jq_expr=$2; shift 2 ;;
    -H) shift 2 ;;
    *) url=$1; shift ;;
  esac
done

printf 'api method=%s url=%s jq=%s\n' "$method" "$url" "$jq_expr" >>"$GH_MOCK_LOG"
if [ -n "$input" ] && [ -f "$input" ]; then
  printf '%s\n' '--- input ---' >>"$GH_MOCK_LOG"
  cat "$input" >>"$GH_MOCK_LOG"
  printf '\n%s\n' '--- end input ---' >>"$GH_MOCK_LOG"
fi

case "$url|$jq_expr" in
  */rulesets*'|.[] | select('* ) exit 0 ;;
  repos/*'|.visibility') printf '%s\n' 'public'; exit 0 ;;
  repos/*'|{full_name,'*) printf '%s\n' '{"full_name":"mock/repo","visibility":"public","is_template":false}'; exit 0 ;;
  */rulesets*'|[.[] | {name, enforcement, target}]') printf '%s\n' '[]'; exit 0 ;;
esac

exit 0
MOCK
chmod +x "$work/bin/gh"

run_setup() {
  log=$1
  shift
  : >"$log"
  GH_MOCK_LOG="$log" PATH="$work/bin:$PATH" bash scripts/setup-github-repository.sh "$@" >/dev/null
}

derived_log="$work/derived.log"
run_setup "$derived_log" acme/service
assert_contains "$derived_log" 'api method=PATCH url=repos/acme/service'
assert_contains "$derived_log" 'api method=POST url=repos/acme/service/rulesets'
assert_contains "$derived_log" 'api method=PUT url=repos/acme/service/private-vulnerability-reporting'
assert_not_contains "$derived_log" 'repos/acme/service/topics'
assert_not_contains "$derived_log" '"is_template": true'

origin_log="$work/origin.log"
run_setup "$origin_log" senoldogann/Default-project --template-origin
assert_contains "$origin_log" 'api method=PUT url=repos/senoldogann/Default-project/topics'
assert_contains "$origin_log" '"is_template": true'
assert_contains "$origin_log" 'repository-governance'

invalid_log="$work/invalid.log"
: >"$invalid_log"
if GH_MOCK_LOG="$invalid_log" PATH="$work/bin:$PATH" bash scripts/setup-github-repository.sh acme/service --template-origin >/dev/null 2>&1; then
  fail '--template-origin must fail outside the canonical template repository'
fi

printf '%s\n' 'PASS: GitHub setup helper behavior checks succeeded'
