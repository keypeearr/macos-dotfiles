#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Consolidated aerospace data gathering - single aerospace call for better performance
AEROSPACE_DATA=$(aerospace list-workspaces --monitor 1 --empty no; echo "---FOCUSED---"; aerospace list-workspaces --focused; echo "---FRONT_APP---"; aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)

# Parse the consolidated data
OCCUPIED_WORKSPACES=$(echo "$AEROSPACE_DATA" | sed '/^---FOCUSED---$/q' | head -n -1)
FOCUSED_WORKSPACE=$(echo "$AEROSPACE_DATA" | sed -n '/^---FOCUSED---$/,/^---FRONT_APP---$/p' | sed '1d;$d')
FRONT_APP=$(echo "$AEROSPACE_DATA" | sed -n '/^---FRONT_APP---$/,$p' | tail -n +2)

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

# Build batch commands for efficiency - all workspace updates in one call
COMMANDS=()

# Update all workspaces (1-9)
for sid in {1..9}; do
    if [[ " ${visible_workspaces[@]} " =~ " ${sid} " ]]; then
        # Show workspace and set styling
        if [[ "$sid" == "$FOCUSED_WORKSPACE" ]]; then
            COMMANDS+=(--set space.$sid 
                       drawing=on
                       label="◉"
                       background.color=$WORKSPACE_ACTIVE_BG
                       label.color=$WORKSPACE_ACTIVE_TEXT
                       icon.color=$WORKSPACE_ACTIVE_TEXT)
        else
            COMMANDS+=(--set space.$sid 
                       drawing=on
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

# Update front app
if [[ -n "$FRONT_APP" && "$FRONT_APP" != " " ]]; then
    APP_ICON=$($CONFIG_DIR/plugins/icon_map_fn.sh "$FRONT_APP" 2>/dev/null || echo "")
    COMMANDS+=(--set front_app 
               label="$FRONT_APP"
               icon="$APP_ICON"
               icon.font="sketchybar-app-font:Regular:16.0"
               drawing=on)
else
    COMMANDS+=(--set front_app 
               label="Desktop"
               icon=""
               drawing=on)
fi

# Execute all commands in a single call for maximum performance
if [[ ${#COMMANDS[@]} -gt 0 ]]; then
    sketchybar "${COMMANDS[@]}"
fi