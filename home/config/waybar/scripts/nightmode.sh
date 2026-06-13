#!/usr/bin/env bash

# Hyprsunset dial for waybar — uses hyprctl IPC, no restart needed.
# Left click:  cycle through presets
# Right click: rofi menu to jump to any preset

STATE_FILE="/tmp/hyprsunset_state"

current_state() {
    cat "$STATE_FILE" 2>/dev/null || echo "off"
}

apply_state() {
    local state="$1"
    echo "$state" > "$STATE_FILE"
    if [[ "$state" == "off" ]]; then
        hyprctl hyprsunset identity
    else
        hyprctl hyprsunset temperature "$state"
    fi
}

case "$1" in
    cycle)
        case "$(current_state)" in
            "off")  apply_state "5000" ;;
            "5000") apply_state "4500" ;;
            "4500") apply_state "4000" ;;
            "4000") apply_state "3500" ;;
            "3500") apply_state "3000" ;;
            "3000") apply_state "off"  ;;
            *)      apply_state "off"  ;;
        esac
        ;;

    menu)
        choice=$(printf "Off\n5000K  Slightly warm\n4500K  Default\n4000K  Moderate\n3500K  Warm\n3000K  Very warm" \
            | rofi -dmenu -p "Night Mode" -i)
        temp=$(echo "$choice" | grep -oP '^\d+')
        if [[ "$choice" == "Off" ]]; then
            apply_state "off"
        elif [[ -n "$temp" ]]; then
            apply_state "$temp"
        fi
        ;;

    status)
        cur=$(current_state)
        if [[ "$cur" == "off" ]]; then
            echo " off"
        else
            echo " ${cur}K"
        fi
        ;;
esac
