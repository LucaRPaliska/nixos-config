#!/usr/bin/env bash

# Hyprsunset dial for waybar.
# Left click:  cycle through presets (off → 5000K → 4500K → 4000K → 3500K → 3000K → off)
# Right click: rofi menu to jump to any preset

STATE_FILE="/tmp/hyprsunset_state"
STATES=("off" "5000" "4500" "4000" "3500" "3000")

current_state() {
    cat "$STATE_FILE" 2>/dev/null || echo "off"
}

apply_state() {
    local state="$1"
    echo "$state" > "$STATE_FILE"
    pkill hyprsunset 2>/dev/null
    [[ "$state" != "off" ]] && hyprsunset -t "$state" &
}

case "$1" in
    cycle)
        cur=$(current_state)
        # Find index of current state, advance to next
        next="off"
        for i in "${!STATES[@]}"; do
            if [[ "${STATES[$i]}" == "$cur" ]]; then
                next="${STATES[$(( (i + 1) % ${#STATES[@]} ))]}"
                break
            fi
        done
        apply_state "$next"
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
