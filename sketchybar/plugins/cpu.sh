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

# Get CPU usage
CPU_USAGE=$(top -l 1 | awk '/CPU usage/ {print int($3)}')

# Don't override the icon set in config, just update the label
sketchybar --set $NAME label="$CPU_USAGE%" \
                         icon.color=$ORANGE \
                         label.color=$ORANGE
