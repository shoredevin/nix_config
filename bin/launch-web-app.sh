#!/usr/bin/env bash

URL="$1"
shift

# Web apps work natively in Chromium/Brave with dedicated app windows.
# If Chromium is installed, use it for app windows regardless of default browser.
if command -v chromium &>/dev/null; then
  exec chromium --app="$URL" "$@"
elif command -v brave &>/dev/null; then
  exec brave --app="$URL" "$@"
elif command -v google-chrome-stable &>/dev/null; then
  exec google-chrome-stable --app="$URL" "$@"
else
  # Fallback to default browser
  exec xdg-open "$URL"
fi
