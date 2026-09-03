#!/usr/bin/env bash

name=""
url=""

# Directories
icon_dir="$HOME/.local/share/icons/hicolor/256x256/apps"
desktop_dir="$HOME/.local/share/applications"

mkdir -p "$icon_dir" "$desktop_dir"

# Source shared YAD UI library if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/lib/yad-ui.sh" ]]; then
  # shellcheck source=/dev/null
  source "$SCRIPT_DIR/lib/yad-ui.sh"
fi

while true; do
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
    --field="Application Name:" "$name" \
    --field="Target URL:" "$url" \
    --button="Cancel:1" \
    --button="Create App:0" 2>/dev/null) || exit 0

  # Parse fields atomically
  IFS='|' read -r name url <<<"$data"

  # name=$(echo "$data" | cut -d'|' -f1 | xargs)
  # url=$(echo "$data" | cut -d'|' -f2 | xargs)

  # 2. Validation
  if [[ -z "$name" || -z "$url" ]]; then
    notify-send "Application Name and URL cannot be empty!" -u critical
    continue
    # show_error -s "Application Name and URL cannot be empty!"
    # make-webapp
    # exit 1
  fi

  if [[ $name == */* ]]; then
    notify-send "App name cannot contain '/': $name"
    continue
    # show_error -s "App name cannot contain '/': $name"
    # exit 1
  fi

  break
done

# 3. Process Slugs & Filenames
slug=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9]/-/g' -e 's/-\+/checksum/g' -e 's/^-//' -e 's/-$//')
icon_path="$icon_dir/$slug.png"
desktop_path="$desktop_dir/$slug.desktop"

# 4. Fetch Favicon via Google's Favicon Service
domain=$(echo "$url" | awk -F/ '{print $3}')
curl -sL "https://www.google.com/s2/favicons?domain=$domain&sz=256" -o "$icon_path"

# Fallback icon if curl fails or returns an empty file
if [[ ! -s "$icon_path" ]]; then
  icon_name="globe"
else
  icon_name="$icon_path"
fi

# 5. Generate .desktop Launcher File
cat <<EOF >"$desktop_path"
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Comment=Web app for $name
Exec=launch-webapp $url
Icon=$icon_name
Terminal=false
StartupWMClass=$domain
Categories=Network;WebBrowser;
EOF

chmod +x "$desktop_path"

# 6. Update Desktop Database & Icon Cache
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$desktop_dir" 2>/dev/null
fi

if command -v gtk-update-icon-cache &>/dev/null; then
  gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null
fi

# 7. Success Dialog
notify-send "You can now find $name using the app launcher (SUPER + A)\n"
