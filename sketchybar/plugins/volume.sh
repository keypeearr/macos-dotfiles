#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Handle mouse events
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$HOVER_BG \
                           background.drawing=on \
                           label.color=$HOVER_TEXT \
                           icon.color=$HOVER_TEXT
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=$TRANSPARENT \
                           background.drawing=off \
                           label.color=$ORANGE \
                           icon.color=$ORANGE
  exit 0
fi

# Get current volume - optimized with single AppleScript call and timeout
VOLUME_INFO=$(timeout 1s osascript -e "set vol to get volume settings; return (output volume of vol) & \"|\" & (output muted of vol)" 2>/dev/null)
if [[ -n "$VOLUME_INFO" ]]; then
    VOLUME=$(echo "$VOLUME_INFO" | cut -d'|' -f1)
    MUTED=$(echo "$VOLUME_INFO" | cut -d'|' -f2)
else
    VOLUME=50
    MUTED=false
fi

# Create slimmer volume bar visualization
VOLUME_BAR=""
FILLED=$(($VOLUME / 14))  # Make it slimmer - 7 segments instead of 10
EMPTY=$((7 - $FILLED))

for ((i=1; i<=FILLED; i++)); do
    VOLUME_BAR+="▬"  # Slimmer bar character
done

for ((i=1; i<=EMPTY; i++)); do
    VOLUME_BAR+="▭"  # Slimmer empty character
done

# Dynamic sound icon and single sketchybar call based on volume level
if [[ $MUTED == "true" ]]; then
    sketchybar --set $NAME icon="🔇 [▭▭▭▭▭▭▭]" label="MUTE" icon.color=$ORANGE label.color=$ORANGE
elif [[ $VOLUME -eq 0 ]]; then
    sketchybar --set $NAME icon="🔇 [$VOLUME_BAR]" label="$VOLUME%" icon.color=$ORANGE label.color=$ORANGE
elif [[ $VOLUME -le 33 ]]; then
    sketchybar --set $NAME icon="🔈 [$VOLUME_BAR]" label="$VOLUME%" icon.color=$ORANGE label.color=$ORANGE
elif [[ $VOLUME -le 66 ]]; then
    sketchybar --set $NAME icon="🔉 [$VOLUME_BAR]" label="$VOLUME%" icon.color=$ORANGE label.color=$ORANGE
else
    sketchybar --set $NAME icon="🔊 [$VOLUME_BAR]" label="$VOLUME%" icon.color=$ORANGE label.color=$ORANGE
fi
