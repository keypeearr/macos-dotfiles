#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Dynamic workspace management script
# This script manages workspace visibility based on app presence

# Get list of workspaces with apps
OCCUPIED_WORKSPACES=$(aerospace list-workspaces --monitor 1 --empty no)
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Array to track which workspaces should be visible
declare -a visible_workspaces=()

# Add occupied workspaces to visible list
while IFS= read -r workspace; do
    if [[ -n "$workspace" ]]; then
        visible_workspaces+=("$workspace")
    fi
done <<< "$OCCUPIED_WORKSPACES"

# Always ensure focused workspace is visible (even if empty)
if [[ -n "$FOCUSED_WORKSPACE" ]] && [[ ! " ${visible_workspaces[@]} " =~ " ${FOCUSED_WORKSPACE} " ]]; then
    visible_workspaces+=("$FOCUSED_WORKSPACE")
fi

# Build batch commands for efficiency
COMMANDS=()

# Update all workspaces (1-9)
for sid in {1..9}; do
    if [[ " ${visible_workspaces[@]} " =~ " ${sid} " ]]; then
        # Show workspace
        COMMANDS+=(--set space.$sid drawing=on)
        
        # Set active/inactive styling
        if [[ "$sid" == "$FOCUSED_WORKSPACE" ]]; then
            COMMANDS+=(--set space.$sid 
                       label="◉"
                       background.color=$WORKSPACE_ACTIVE_BG
                       label.color=$WORKSPACE_ACTIVE_TEXT
                       icon.color=$WORKSPACE_ACTIVE_TEXT)
        else
            COMMANDS+=(--set space.$sid 
                       label="○"
                       background.color=$WORKSPACE_INACTIVE_BG
                       label.color=$WORKSPACE_INACTIVE_TEXT
                       icon.color=$WORKSPACE_INACTIVE_TEXT)
        fi
    else
        # Hide workspace
        COMMANDS+=(--set space.$sid drawing=off)
    fi
done

# Execute all commands in a single call for better performance
if [[ ${#COMMANDS[@]} -gt 0 ]]; then
    sketchybar "${COMMANDS[@]}"
fi