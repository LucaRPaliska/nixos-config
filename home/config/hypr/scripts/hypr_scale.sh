#!/usr/bin/env bash
MONITOR="eDP-1"
SCALES=(1.0 1.2 1.33334 1.5 1.6)

# 3. GET CURRENT SCALE (Default to 1.0 if jq fails)
CURRENT=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MONITOR\") | .scale")
CURRENT=${CURRENT:-1.0}

# 4. FIND CURRENT INDEX (or closest match)
INDEX=0
for i in "${!SCALES[@]}"; do
    if (( $(echo "${SCALES[$i]} == $CURRENT" | bc -l) )); then
        INDEX=$i
        break
    fi
done

# 5. MOVE UP OR DOWN
if [ "$1" == "up" ]; then
    if [ $INDEX -lt $((${#SCALES[@]} - 1)) ]; then
        ((INDEX++))
    fi
elif [ "$1" == "down" ]; then
    if [ $INDEX -gt 0 ]; then
        ((INDEX--))
    fi
fi

# 6. APPLY THE SPECIFIC VALUE
NEW_SCALE=${SCALES[$INDEX]}
hyprctl keyword monitor "$MONITOR, preferred, auto, $NEW_SCALE"
