#!/usr/bin/env bash

NIX_DIR="$HOME/Documents/nix_config"
hostname=$(hostname -s)
username="${SUDO_USER:-$USER}"
EDITOR="${EDITOR:-nano}"

show_help() {
  cat << EOF
Usage: $(basename "$0") [OPTION] 

Quickly edit NixOS configuration files in $NIX_DIR.

Options:
  -f, (none)    Edit main flake (flake.nix)
  -c            Edit core common module (modules/core/common.nix)
  -u            Edit current user config (users/$username/default.nix)
  -uh           Edit current user home manager confir (users/$username/home.nix)
  -h            Edit current host config (hosts/$hostname/default.nix)
  --help, -?    Show this help message
EOF
}

case "${1:-default}" in
  -c)
    file="modules/core/common.nix"
    ;;
  -f|default)
    file="flake.nix"
    ;;
  -u)
    file="users/$username/default.nix"
    ;;
  -uh)
	file="users/$username/home.nix"
	;;
  -h)
    file="hosts/$hostname/default.nix"
    ;;
  --help|-\?|\?)
    show_help
    exit 0
    ;;
  *)
    echo "Error: '$1' is not a valid argument." >&2
    echo "" >&2
    show_help >&2
    exit 1
    ;;
esac

target_path="$NIX_DIR/$file"

if [ ! -f "$target_path" ]; then
  echo "Error: Target file does not exist: $target_path" >&2
  exit 1
fi

"$EDITOR" "$target_path"
