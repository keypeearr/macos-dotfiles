#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get current focused workspace
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

# Hide all empty workspaces
for sid in $(aerospace list-workspaces --monitor 1 --empty ); do
    sketchybar --set space.$sid label="" drawing=off
done

# Show workspaces with applications and update their styling
for sid in $(aerospace list-workspaces --monitor 1 --empty no); do
    apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
    sketchybar --set space.$sid drawing=on

    # Apply styling based on whether this is the focused workspace
    if [ "$sid" = "$CURRENT_WORKSPACE" ]; then
        # Active workspace - workspace number + dotted circle
        sketchybar --set space.$sid icon="$sid" \
                                    label="◉" \
                                    background.color=$WORKSPACE_ACTIVE_BG \
                                    background.drawing=on \
                                    label.color=$WORKSPACE_ACTIVE_TEXT \
                                    icon.color=$WORKSPACE_ACTIVE_TEXT
    else
        # Inactive workspace - workspace number + empty circle
        sketchybar --set space.$sid icon="$sid" \
                                    label="○" \
                                    background.color=$WORKSPACE_INACTIVE_BG \
                                    background.drawing=on \
                                    label.color=$WORKSPACE_INACTIVE_TEXT \
                                    icon.color=$WORKSPACE_INACTIVE_TEXT
    fi
done

# Ensure focused workspace is always visible
if [ "$SENDER" == "aerospace_workspace_change" ]; then
  sketchybar --set space.$CURRENT_WORKSPACE drawing=on
fi