#!/usr/bin/env bash

options="Shutdown\0icon\x1fsystem-shutdown\n"
options+="Reboot\0icon\x1fsystem-reboot\n"
options+="Suspend\0icon\x1fsystem-suspend\n"
options+="Hibernate\0icon\x1fsystem-hibernate\n"
options+="Logout\0icon\x1fsystem-log-out\n"

choice=$(printf "$options" | rofi -dmenu -i -p "" \
    -theme-str 'window {width: 20%;} listview {lines: 5;} element-icon {size: 26px; margin: 0 8 0 16;}' \
    | tr -d '\n\r')

case "$choice" in
    Shutdown)  systemctl poweroff ;;
    Reboot)    systemctl reboot ;;
    Suspend)   systemctl suspend ;;
    Hibernate) systemctl hibernate ;;
    Logout)    hyprctl dispatch exit ;;
esac
