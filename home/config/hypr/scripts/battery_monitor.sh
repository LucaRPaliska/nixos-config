#!/usr/bin/env bash

# Sends increasingly urgent notifications as battery drains.
# Runs in the background from start.sh.

NOTIFIED_CRITICAL=false
NOTIFIED_WARNING=false

while true; do
    level=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

    if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
        NOTIFIED_CRITICAL=false
        NOTIFIED_WARNING=false
    elif [[ "$level" -le 5 ]] && [[ "$NOTIFIED_CRITICAL" == false ]]; then
        notify-send -u critical "⚠ BATTERY CRITICAL" "${level}% — Plug in immediately!"
        NOTIFIED_CRITICAL=true
    elif [[ "$level" -le 15 ]] && [[ "$NOTIFIED_WARNING" == false ]]; then
        notify-send -u critical "Battery Low" "${level}% remaining — plug in soon."
        NOTIFIED_WARNING=true
    fi

    sleep 60
done
