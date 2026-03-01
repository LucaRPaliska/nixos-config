#!/usr/bin/env bash

choice=$(echo -e "shutdown\nreboot\nsuspend\nlogout" | \
    wofi --dmenu \
    --style ~/.config/waybar/scripts/power_menu/wofi_power.css \
    --width 100 \
    --height 100 \
    --x 8 \
    --y -1 \

    --halign center \
    --content_halign center \

    --prompt ... \
    --hide_scroll true | tr -d '\n')

case "$choice" in
    shutdown) systemctl poweroff ;;
    reboot) systemctl reboot ;;
    suspend) systemctl suspend ;;
    logout) hyprctl dispatch exit ;;
esac
