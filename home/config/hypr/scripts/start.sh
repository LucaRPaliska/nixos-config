#!/usr/bin/env bash

sleep 1

swww-daemon &
while ! swww query &>/dev/null; do sleep 0.1; done
swww img ~/.config/wallpapers/adam_final.png

nm-applet --indicator &

mako &

hypridle &
~/.config/hypr/scripts/battery_monitor.sh &
