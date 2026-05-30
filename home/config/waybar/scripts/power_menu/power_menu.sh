#!/usr/bin/env bash

choice=$(printf "Shutdown\0icon\x1fsystem-shutdown\nReboot\0icon\x1fsystem-reboot\nSuspend\0icon\x1fsystem-suspend\nLogout\0icon\x1fsystem-log-out\n" | \
    rofi -dmenu \
    -p "" \
    -theme-str 'window {width: 20%;} listview {lines: 4;} element-icon {size: 26px; margin: 0 8 0 16;}' | tr -d '\n')

case "$choice" in
    Shutdown|shutdown) systemctl poweroff ;;
    Reboot|reboot)     systemctl reboot ;;
    Suspend|suspend)   systemctl suspend ;;
    Logout|logout)     hyprctl dispatch exit ;;
esac
