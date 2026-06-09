#!/usr/bin/env bash

# Hyprsunset toggle + temperature control for waybar.
# Left click:  toggle night mode on/off
# Right click: rofi menu to pick temperature preset

TEMP_FILE="/tmp/hyprsunset_temp"
DEFAULT_TEMP=4500

case "$1" in
    toggle)
        if pgrep -x hyprsunset > /dev/null; then
            pkill hyprsunset
        else
            temp=$(cat "$TEMP_FILE" 2>/dev/null || echo "$DEFAULT_TEMP")
            hyprsunset -t "$temp" &
        fi
        ;;

    menu)
        choice=$(printf "3000K  Very warm\n3500K  Warm\n4000K  Moderate\n4500K  Default\n5000K  Slightly warm\nOff" \
            | rofi -dmenu -p "Night Mode" -i)
        temp=$(echo "$choice" | grep -oP '^\d+')
        if [[ "$choice" == "Off" ]]; then
            pkill hyprsunset
        elif [[ -n "$temp" ]]; then
            echo "$temp" > "$TEMP_FILE"
            pkill hyprsunset 2>/dev/null
            hyprsunset -t "$temp" &
        fi
        ;;

    status)
        if pgrep -x hyprsunset > /dev/null; then
            temp=$(cat "$TEMP_FILE" 2>/dev/null || echo "$DEFAULT_TEMP")
            echo "{\"text\": \" ${temp}K\", \"tooltip\": \"Night mode on (${temp}K)\", \"class\": \"active\"}"
        else
            echo "{\"text\": \"\", \"tooltip\": \"Night mode off\", \"class\": \"inactive\"}"
        fi
        ;;
esac
