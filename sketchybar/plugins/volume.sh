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

# Get current volume
VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

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

# Dynamic sound icon based on volume level
if [[ $MUTED == "true" ]]; then
    SOUND_ICON="🔇"
    sketchybar --set $NAME icon="$SOUND_ICON [▭▭▭▭▭▭▭]" label="MUTE"
elif [[ $VOLUME -eq 0 ]]; then
    SOUND_ICON="🔇"
    sketchybar --set $NAME icon="$SOUND_ICON [$VOLUME_BAR]" label="$VOLUME%"
elif [[ $VOLUME -le 33 ]]; then
    SOUND_ICON="🔈"
    sketchybar --set $NAME icon="$SOUND_ICON [$VOLUME_BAR]" label="$VOLUME%"
elif [[ $VOLUME -le 66 ]]; then
    SOUND_ICON="🔉"
    sketchybar --set $NAME icon="$SOUND_ICON [$VOLUME_BAR]" label="$VOLUME%"
else
    SOUND_ICON="🔊"
    sketchybar --set $NAME icon="$SOUND_ICON [$VOLUME_BAR]" label="$VOLUME%"
fi
