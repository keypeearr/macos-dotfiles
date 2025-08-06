#!/bin/bash

# This script listens to AeroSpace events and triggers SketchyBar updates.

aerospace -c events subscribe workspace_change window_focus | while read -r line; do
  event_type=$(echo "$line" | cut -d' ' -f1)
  case "$event_type" in
    workspace_change)
      sketchybar --trigger aerospace_workspace_change
      ;;
    window_focus)
      sketchybar --trigger aerospace_focus_change
      ;;
  esac
done
