#!/usr/bin/env bash
set -euo pipefail

install_dir=${DEFAULT_INIT_INSTALL_DIR:-$HOME/.local/bin}
target="$install_dir/default-init"
raw_url=${DEFAULT_INIT_CLI_URL:-https://raw.githubusercontent.com/senoldogann/Default-project/main/bin/default-init}

mkdir -p "$install_dir"

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd -P || true)
local_cli=''
if [ -n "$script_dir" ]; then
  candidate="$script_dir/../bin/default-init"
  if [ -f "$candidate" ]; then
    local_cli=$candidate
  fi
fi

if [ -n "$local_cli" ]; then
  cp "$local_cli" "$target"
else
  command -v curl >/dev/null 2>&1 || {
    printf 'install-default-init: curl is required when installing outside a repository checkout\n' >&2
    exit 1
  }
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT
  curl -fsSL "$raw_url" -o "$tmp"
  cp "$tmp" "$target"
fi

chmod +x "$target"
version_output=$($target version)
printf 'Installed %s at %s\n' "$version_output" "$target"

case ":$PATH:" in
  *":$install_dir:"*) ;;
  *)
    printf '\n%s\n' "Add this directory to PATH if default-init is not found:"
    printf '  export PATH="%s:$PATH"\n' "$install_dir"
    printf '%s\n' 'For zsh, add that line to ~/.zshrc and open a new terminal.'
    ;;
esac
