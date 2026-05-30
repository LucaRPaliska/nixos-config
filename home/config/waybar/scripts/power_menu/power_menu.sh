#!/usr/bin/env bash

choice=$(printf "Shutdown\0icon\x1fsystem-shutdown\nReboot\0icon\x1fsystem-reboot\nSuspend\0icon\x1fsystem-suspend\nHibernate\0icon\x1fsystem-hibernate\nLogout\0icon\x1fsystem-log-out\n" | \
    rofi -dmenu -i \
    -p "" \
    -theme-str 'window {width: 20%;} listview {lines: 5;} element-icon {size: 26px; margin: 0 8 0 16;}' | tr -d '\n\r')

case "$choice" in
    Shutdown)  systemctl poweroff ;;
    Reboot)    systemctl reboot ;;
    Suspend)   systemctl suspend ;;
    Hibernate) systemctl hibernate ;;
    Logout)    hyprctl dispatch exit ;;
esac
