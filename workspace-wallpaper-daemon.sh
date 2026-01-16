#!/bin/bash

# Workspace Wallpaper Daemon
# Polls for workspace changes and sets wallpapers accordingly

CONFIG_FILE="$HOME/.config/hypr/workspace-wallpapers.json"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

# Get wallpaper for workspace
get_wallpaper() {
    local workspace=$1
    jq -r ".\"$workspace\" // \"default.png\"" "$CONFIG_FILE" 2>/dev/null
}

# Set wallpaper
set_wallpaper() {
    local file="$1"
    if [ -f "$WALLPAPER_DIR/$file" ]; then
        swww img "$WALLPAPER_DIR/$file" --transition-type fade --transition-duration 0.5
    fi
}

# Get current workspace
get_current_workspace() {
    hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null
}

echo "Starting workspace wallpaper daemon (polling mode)..."

last_workspace=""
while true; do
    current=$(get_current_workspace)

    if [ -n "$current" ] && [ "$current" != "$last_workspace" ]; then
        wallpaper=$(get_wallpaper "$current")
        echo "Workspace $current -> $wallpaper"
        set_wallpaper "$wallpaper"
        last_workspace="$current"
    fi

    sleep 0.2
done
