#!/usr/bin/env bash

# Reset local OPTIND for getopts
OPTIND=1 2>/dev/null || OPTIND=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/lib/yad-ui.sh" ]]; then
    # shellcheck source=/dev/null
    source "$SCRIPT_DIR/lib/yad-ui.sh"
fi

VARS=()

while getopts "v:" opt; do
    case "$opt" in
        v) read -ra VARS <<< "$OPTARG" ;;
        *) echo "Usage: $0 [-v VARS]" >&2; exit 1 ;;
    esac
done

shift $((OPTIND - 1))

# 1. Collect Input
data=$(yad --form \
    --title="Make Web App" \
    --class="Yad" \
    --geometry=400x250 \
    --fixed \
    --undecorated \
    --center \
    --borders=24 \
    --separator="|" \
    --css="$BASE_CSS" \
    --field="question 1:" \
    --field="question 2:" \
    --field="question 3:" \
    "${VARS[0]:-}" "${VARS[1]:-}" "${VARS[2]:-}" \
    --button="Cancel:1" \
    --button="Create App:0" 2>/dev/null) || exit 0

a=$(echo "$data" | cut -d'|' -f1 | xargs)
b=$(echo "$data" | cut -d'|' -f2 | xargs)
c=$(echo "$data" | cut -d'|' -f3 | xargs)

s=("$a" "$b" "$c")

# 2. Validation
if [[ -z "$a" || -z "$b" ]]; then
    show_error -s "Application Name and URL cannot be empty!" -v "${s[*]}" 
fi

if [[ $a == "a" ]]; then
    show_error -s "App name cannot contain '/': $a" -v "${s[*]}" 
fi

show_success "$a, $b, $c is all good\n"