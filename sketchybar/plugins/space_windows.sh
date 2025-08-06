#!/bin/bash

# Optimized script - minimal workspace visibility management
source "$CONFIG_DIR/colors.sh"

# Only run workspace visibility updates, not styling (handled by aerospace_workspace_change.sh)
if [ "$SENDER" = "aerospace_workspace_change" ] || [ "$SENDER" = "space_windows_change" ]; then
    # Get workspaces in one call and batch updates
    COMMANDS=()
    
    # Hide empty workspaces
    for sid in $(aerospace list-workspaces --monitor 1 --empty); do
        COMMANDS+=(--set space.$sid drawing=off)
    done
    
    # Show non-empty workspaces  
    for sid in $(aerospace list-workspaces --monitor 1 --empty no); do
        COMMANDS+=(--set space.$sid drawing=on)
    done
    
    # Execute all visibility changes in one call
    if [[ ${#COMMANDS[@]} -gt 0 ]]; then
        sketchybar "${COMMANDS[@]}"
    fi
fi