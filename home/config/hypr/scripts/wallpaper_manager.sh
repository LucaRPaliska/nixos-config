#!/usr/bin/env bash

# Sets wallpapers based on connected monitors.
# Triggered on startup and whenever a monitor is added/removed.
# Run via exec-once in hyprland.conf.
#
# Wallpaper assignments (fixed per slot):
#   eDP-1 (internal): adam_final
#   1st external:     blackhole
#   2nd external:     brave_wallpaper
#   3rd external:     blackhole2

WALLPAPER_DIR="$HOME/.config/wallpapers"

set_wallpapers() {
    local monitors
    monitors=$(hyprctl monitors -j 2>/dev/null) || return

    # Internal monitor — always adam_final
    swww img -o eDP-1 "$WALLPAPER_DIR/adam_final.png" 2>/dev/null

    # External monitors sorted by id for stable ordering
    local external_monitors
    external_monitors=$(echo "$monitors" | jq -r '[.[] | select(.name != "eDP-1")] | sort_by(.id) | .[].name')

    local i=0
    while IFS= read -r monitor; do
        [[ -z "$monitor" ]] && continue
        case $i in
            0) swww img -o "$monitor" "$WALLPAPER_DIR/blackhole.png" 2>/dev/null ;;
            1) swww img -o "$monitor" "$WALLPAPER_DIR/brave_wallpaper.png" 2>/dev/null ;;
            2) swww img -o "$monitor" "$WALLPAPER_DIR/blackhole2.png" 2>/dev/null ;;
        esac
        ((i++))
    done <<< "$external_monitors"
}

# Set on startup
set_wallpapers

# Listen for monitor events via Hyprland IPC
socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    case "$line" in
        monitoradded*|monitorremoved*)
            sleep 0.5  # Let hyprctl update before querying
            set_wallpapers
            ;;
    esac
done
