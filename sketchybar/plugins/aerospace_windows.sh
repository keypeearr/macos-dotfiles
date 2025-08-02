#!/bin/bash

# This script gets the active window's title and sets it for SketchyBar.

case "$SENDER" in
  aerospace_workspace_change|aerospace_focus_change)
    WINDOW_TITLE=$(aerospace -c window-info | grep -oP "title:\s*\K.*")
    sketchybar --set "$NAME" label="$WINDOW_TITLE"
    ;;
esac
