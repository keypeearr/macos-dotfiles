#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get workspaces from environment variables
CURRENT_WORKSPACE=${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}
PREV_WORKSPACE=${PREV_WORKSPACE}

# Build batch update commands
COMMANDS=()

# Update current workspace to active (filled circle)
if [[ -n "$CURRENT_WORKSPACE" ]]; then
    COMMANDS+=(--set space.$CURRENT_WORKSPACE 
               label="◉"
               background.color=$WORKSPACE_ACTIVE_BG
               label.color=$WORKSPACE_ACTIVE_TEXT
               icon.color=$WORKSPACE_ACTIVE_TEXT)
fi

# Update previous workspace to inactive (empty circle)  
if [[ -n "$PREV_WORKSPACE" && "$PREV_WORKSPACE" != "$CURRENT_WORKSPACE" ]]; then
    COMMANDS+=(--set space.$PREV_WORKSPACE
               label="○"
               background.color=$WORKSPACE_INACTIVE_BG
               label.color=$WORKSPACE_INACTIVE_TEXT
               icon.color=$WORKSPACE_INACTIVE_TEXT)
fi

# Execute in single call
if [[ ${#COMMANDS[@]} -gt 0 ]]; then
    sketchybar "${COMMANDS[@]}"
fi