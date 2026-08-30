#!/usr/bin/env bash

# Directories
icon_dir="$HOME/.local/share/icons/hicolor/256x256/apps"
desktop_dir="$HOME/.local/share/applications"

mkdir -p "$icon_dir" "$desktop_dir"

# Base GTK CSS with Catppuccin Mocha Color Palette Definitions
BASE_CSS="
@define-color base #1e1e2e;
@define-color crust #11111b;
@define-color mantle #181825;
@define-color text #cdd6f4;
@define-color subtext0 #a6adc8;
@define-color surface0 #313244;
@define-color surface1 #45475a;
@define-color mauve #cba6f7;
@define-color pink #f5c2e7;
@define-color red #f38ba8;
@define-color green #a6e3a1;
@define-color teal #94e2d5;

#yad-dialog-window {
    background-color: @base;
    padding: 20px;
}
#yad-dialog-window label {
    font-size: 13px;
    font-weight: bold;
    color: @subtext0;
}

entry {
    background-color: @mantle;
    color: @text;
    border: 1px solid @surface0;
    border-radius: 8px;
    padding: 8px 12px;
    box-shadow: none;
}
entry:focus,
entry:active {
    border-color: @pink;
    box-shadow: 0 0 0 1px @pink;
    outline: none;
}

button,
button:active,
button:checked,
#yad-dialog-window button {
    background-image: none;
    box-shadow: none;
    text-shadow: none;
    border-radius: 8px;
    padding: 8px 16px;
    font-weight: bold;
    border: 1px solid @surface1;
    outline: none;
}

button label,
#yad-dialog-window button label {
    box-shadow: none;
    outline: none;
    background-color: transparent;
}

button:hover,
button:focus,
button:active,
#yad-dialog-window button:hover,
#yad-dialog-window button:focus,
#yad-dialog-window button:active {
    border-color: @pink;
    outline: none;
    box-shadow: none;
}

button#yad-b-cancel,
button#yad-b-cancel label,
#yad-dialog-window button#yad-b-cancel,
#yad-dialog-window button#yad-b-cancel label {
    background-color: @surface0;
    color: @red;
}
button#yad-b-cancel:hover,
button#yad-b-cancel:hover label,
button#yad-b-cancel:focus,
button#yad-b-cancel:focus label,
button#yad-b-cancel:active,
button#yad-b-cancel:active label {
    background-color: @red;
    color: @crust;
}

button#yad-b-ok,
button#yad-b-ok label,
#yad-dialog-window button#yad-b-ok,
#yad-dialog-window button#yad-b-ok label {
    background-color: @mauve;
    color: @crust;
}
button#yad-b-ok:hover,
button#yad-b-ok:hover label,
button#yad-b-ok:focus,
button#yad-b-ok:focus label,
button#yad-b-ok:active,
button#yad-b-ok:active label {
    background-color: @pink;
    color: @crust;
}
"

show_error() {
    local message="$1"
    
    # Inherit base styling and only override error accent colors
    local error_css="${BASE_CSS}
    #yad-dialog-window label { color: @red; }
    
    button, #yad-dialog-window button, #yad-dialog-window button#yad-b-ok {
        background-color: @red;
        border-color: @red;
    }
    button label, #yad-dialog-window button label, #yad-dialog-window button#yad-b-ok label {
        color: @mantle;
    }
    button:hover, button:focus, button:active,
    #yad-dialog-window button:hover, #yad-dialog-window button:focus, #yad-dialog-window button:active {
        background-color: @pink;
        border-color: @pink;
    }
    "

    yad --text="$message" \
        --title="Error" \
        --class="Yad" \
        --geometry=350x150 \
        --fixed \
        --undecorated \
        --center \
        --borders=16 \
        --window-icon="dialog-error" \
        --image="dialog-error" \
        --button="OK:0" \
        --css="$error_css" 2>/dev/null
}

show_success() {
    local message="$1"
    
    # Inherit base styling and only override success accent colors
    local success_css="${BASE_CSS}
    #yad-dialog-window label { color: @green; }
    
    button, #yad-dialog-window button, #yad-dialog-window button#yad-b-ok {
        background-color: @green;
        border-color: @green;
    }
    button label, #yad-dialog-window button label, #yad-dialog-window button#yad-b-ok label {
        color: @mantle;
    }
    button:hover, button:focus, button:active,
    #yad-dialog-window button:hover, #yad-dialog-window button:focus, #yad-dialog-window button:active {
        background-color: @teal;
        border-color: @pink;
    }
    "

    yad --text="$message" \
        --title="Success" \
        --class="Yad" \
        --geometry=380x150 \
        --fixed \
        --undecorated \
        --center \
        --borders=16 \
        --window-icon="dialog-information" \
        --image="dialog-information" \
        --button="OK:0" \
        --css="$success_css" 2>/dev/null
}

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
    --field="Application Name:" \
    --field="Target URL:" \
    --button="Cancel:1" \
    --button="Create App:0" 2>/dev/null) || exit 0

name=$(echo "$data" | cut -d'|' -f1 | xargs)
url=$(echo "$data" | cut -d'|' -f2 | xargs)

# 2. Validation
if [[ -z "$name" || -z "$url" ]]; then
    show_error "Application Name and URL cannot be empty!"
    bash-gui
    exit 1
fi

if [[ $name == */* ]]; then
    show_error "App name cannot contain '/': $name"
    exit 1
fi

# Ensure URL has a protocol
if [[ ! "$url" =~ ^https?:// ]]; then
    url="https://$url"
fi

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
cat <<EOF > "$desktop_path"
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
show_success "You can now find $name using the app launcher (SUPER + A)\n"