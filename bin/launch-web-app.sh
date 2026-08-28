#!/usr/bin/env bash

URL="$1"
shift

browser=$(xdg-settings get default-web-browser 2>/dev/null)

if [[ $browser == firefox* ]]; then
  # Opens an isolated window, hiding default workspace state
  exec firefox --new-window "$URL" "$@"
else
  # Chromium-based browsers (Brave, Chrome, Vivaldi, etc.)
  exec_line=$(sed -n 's/^Exec=\([^ ]*\).*/\1/p' \
    {"$HOME/.local","$HOME/.nix-profile",/run/current-system/sw}/share/applications/$browser 2>/dev/null | head -1)

  exec "${exec_line:-xdg-open}" --app="$URL" "$@"
fi
