#!/usr/bin/env bash

tmpbg="/tmp/screen.png"
grim "$tmpbg"
corrupter -mag 1.3 -boffset 20 "$tmpbg" "$tmpbg"

# for o in HDMI-A-2 DP-1 eDP-1
# do
# 	grim -o "$o" "/tmp/$o.png"
# 	corrupter "/tmp/$o.png" "/tmp/$o.png" &
# done
# wait

exec hyprlock -c hyprlock_theme.conf
