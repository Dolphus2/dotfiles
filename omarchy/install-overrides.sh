#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HYPR_CONFIG_DIR="$HOME/.config/hypr"
HYPRLAND_CONFIG="$HYPR_CONFIG_DIR/hyprland.lua"

if [ ! -f "$HYPRLAND_CONFIG" ]; then
    echo "Hyprland Lua config not found at $HYPRLAND_CONFIG"
    echo "Please install Omarchy 4 first"
    exit 1
fi

mkdir -p "$HYPR_CONFIG_DIR"

install_if_changed() {
    source=$1
    target=$2

    if [ -f "$target" ] && cmp -s "$source" "$target"; then
        echo "Already up to date: $target"
    else
        cp "$source" "$target"
        echo "Installed: $target"
    fi
}

install_if_changed "$SCRIPT_DIR/hypr/bindings.lua" "$HYPR_CONFIG_DIR/bindings.lua"
install_if_changed "$SCRIPT_DIR/hypr/input.lua" "$HYPR_CONFIG_DIR/input.lua"
# install_if_changed "$SCRIPT_DIR/hypr/autostart.lua" "$HYPR_CONFIG_DIR/autostart.lua"

# install_if_changed "$SCRIPT_DIR/hypr/envs.lua" "$HYPR_CONFIG_DIR/envs.lua"
# if ! grep -Fqx 'require("hypr.envs")' "$HYPRLAND_CONFIG"; then
#     printf '\nrequire("hypr.envs")\n' >> "$HYPRLAND_CONFIG"
# fi

echo "Omarchy Lua overrides installed in $HYPR_CONFIG_DIR"
hyprctl reload
hyprctl configerrors
