#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Optimized hover handler - reduces redundant sketchybar calls
# Usage: Called by individual scripts with $NAME and $SENDER

if [[ "$SENDER" == "mouse.entered" ]]; then
    sketchybar --set "$NAME" \
               background.color="$HOVER_BG" \
               background.drawing=on \
               label.color="$HOVER_TEXT" \
               icon.color="$HOVER_TEXT"
elif [[ "$SENDER" == "mouse.exited" ]]; then
    sketchybar --set "$NAME" \
               background.color="$TRANSPARENT" \
               background.drawing=off \
               label.color="$ORANGE" \
               icon.color="$ORANGE"
fi