#!/bin/bash

# This script is triggered on aerospace_workspace_change to update all workspace indicators.

case "$SENDER" in
  "aerospace_workspace_change")
    # Get a list of all occupied workspace IDs
    OCCUPIED_WORKSPACES=$(aerospace -c workspace-info | grep -E 'id|windows' | grep -B 1 '"windows":\[\]' | grep -v 'windows' | grep -oP '"id":\s*\K[0-9]+')
    
    # Get the ID of the currently focused workspace
    FOCUSED_WORKSPACE=$(aerospace -c workspace-info | grep -B 1 '"focused":true' | grep -oP '"id":\s*\K[0-9]+')

    for i in {1..10}; do
      # Check if the current workspace 'i' is occupied
      if echo "$OCCUPIED_WORKSPACES" | grep -q "^$i$"; then
        # Check if the current workspace 'i' is focused
        if [ "$i" = "$FOCUSED_WORKSPACE" ]; then
          sketchybar --set "workspace.$i" drawing=on label.drawing=on icon.color=$ACCENT_COLOR
        else
          sketchybar --set "workspace.$i" drawing=on label.drawing=off icon.color=$ORANGE
        fi
      else
        # If the workspace is not occupied, hide it
        sketchybar --set "workspace.$i" drawing=off
      fi
    done
    ;;
esac
