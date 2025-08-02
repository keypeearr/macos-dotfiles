#!/bin/bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh
source "$CONFIG_DIR/colors.sh"

# Handle mouse events
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$WORKSPACE_HOVER_BG \
                           label.color=$HOVER_TEXT \
                           icon.color=$HOVER_TEXT
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  # Restore normal state - run the normal logic below
  :
fi

# Get the current focused workspace
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

if [ "$1" = "$CURRENT_WORKSPACE" ]; then
  # Active workspace - workspace number + dotted circle
  sketchybar --set $NAME icon="$1" \
                           label="◉" \
                           background.color=$WORKSPACE_ACTIVE_BG \
                           background.drawing=on \
                           label.color=$WORKSPACE_ACTIVE_TEXT \
                           icon.color=$WORKSPACE_ACTIVE_TEXT
else
  # Inactive workspace - workspace number + empty circle
  sketchybar --set $NAME icon="$1" \
                           label="○" \
                           background.color=$WORKSPACE_INACTIVE_BG \
                           background.drawing=on \
                           label.color=$WORKSPACE_INACTIVE_TEXT \
                           icon.color=$WORKSPACE_INACTIVE_TEXT
fi