#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Handle mouse events only
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$WORKSPACE_HOVER_BG \
                           label.color=$HOVER_TEXT \
                           icon.color=$HOVER_TEXT
elif [ "$SENDER" = "mouse.exited" ]; then
  # Determine current state and restore
  CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
  if [ "$1" = "$CURRENT_WORKSPACE" ]; then
    sketchybar --set $NAME background.color=$WORKSPACE_ACTIVE_BG \
                             label.color=$WORKSPACE_ACTIVE_TEXT \
                             icon.color=$WORKSPACE_ACTIVE_TEXT
  else
    sketchybar --set $NAME background.color=$WORKSPACE_INACTIVE_BG \
                             label.color=$WORKSPACE_INACTIVE_TEXT \
                             icon.color=$WORKSPACE_INACTIVE_TEXT
  fi
fi