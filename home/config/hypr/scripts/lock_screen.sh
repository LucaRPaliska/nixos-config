#!/usr/bin/env bash

for o in HDMI-A-1 DP-1 eDP-1
do
	grim -o "$o" "/tmp/$o.png"
	# corrupter "/tmp/$o.png" "/tmp/$o.png" &
        corrupter -mag 1.3 -boffset 20 "/tmp/$o.png" "/tmp/$o.png"
done
wait

exec hyprlock
