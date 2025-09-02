#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Optimized aerospace workspace and app management
# Single aerospace call for all data, batch updates to SketchyBar

# Cache for reducing redundant updates
CACHE_FILE="/tmp/sketchybar_aerospace_cache"

# Handle mouse events efficiently
if [[ "$SENDER" == "mouse.entered" ]] || [[ "$SENDER" == "mouse.exited" ]]; then
    SPACE_ID="${NAME#space.}"
    if [[ "$SENDER" == "mouse.entered" ]]; then
        sketchybar --set "$NAME" background.color="$WORKSPACE_HOVER_BG" \
                                 label.color="$HOVER_TEXT" \
                                 icon.color="$HOVER_TEXT"
    else
        # Check if this is the active workspace (from cache if available)
        if [[ -f "$CACHE_FILE" ]]; then
            FOCUSED=$(grep "^FOCUSED:" "$CACHE_FILE" | cut -d: -f2)
        else
            FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
        fi
        
        if [[ "$SPACE_ID" == "$FOCUSED" ]]; then
            sketchybar --set "$NAME" background.color="$WORKSPACE_ACTIVE_BG" \
                                     label.color="$WORKSPACE_ACTIVE_TEXT" \
                                     icon.color="$WORKSPACE_ACTIVE_TEXT"
        else
            sketchybar --set "$NAME" background.color="$WORKSPACE_INACTIVE_BG" \
                                     label.color="$WORKSPACE_INACTIVE_TEXT" \
                                     icon.color="$WORKSPACE_INACTIVE_TEXT"
        fi
    fi
    exit 0
fi

# Main update logic - collect all data in single aerospace call
collect_aerospace_data() {
    # Run aerospace commands in parallel for speed
    {
        echo "OCCUPIED:$(aerospace list-workspaces --monitor 1 --empty no 2>/dev/null | tr '\n' ' ')"
        echo "FOCUSED:$(aerospace list-workspaces --focused 2>/dev/null)"
        echo "APP:$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null | head -1)"
    } 2>/dev/null
}

# Get current aerospace state
AEROSPACE_DATA=$(collect_aerospace_data)

# Check if data changed from cache
if [[ -f "$CACHE_FILE" ]]; then
    PREV_DATA=$(cat "$CACHE_FILE")
    [[ "$AEROSPACE_DATA" == "$PREV_DATA" ]] && exit 0
fi

# Parse the data
OCCUPIED=$(echo "$AEROSPACE_DATA" | grep "^OCCUPIED:" | cut -d: -f2)
FOCUSED=$(echo "$AEROSPACE_DATA" | grep "^FOCUSED:" | cut -d: -f2)
APP=$(echo "$AEROSPACE_DATA" | grep "^APP:" | cut -d: -f2-)

# Build visible workspaces list
VISIBLE_SPACES="$OCCUPIED"
[[ -n "$FOCUSED" ]] && [[ ! " $VISIBLE_SPACES " =~ " $FOCUSED " ]] && VISIBLE_SPACES="$VISIBLE_SPACES $FOCUSED"

# Update all workspace indicators efficiently
for i in {1..9}; do
    if [[ " $VISIBLE_SPACES " =~ " $i " ]]; then
        if [[ "$i" == "$FOCUSED" ]]; then
            sketchybar --set "space.$i" \
                       drawing=on \
                       label="◉" \
                       background.color="$WORKSPACE_ACTIVE_BG" \
                       label.color="$WORKSPACE_ACTIVE_TEXT" \
                       icon.color="$WORKSPACE_ACTIVE_TEXT"
        else
            sketchybar --set "space.$i" \
                       drawing=on \
                       label="○" \
                       background.color="$WORKSPACE_INACTIVE_BG" \
                       label.color="$WORKSPACE_INACTIVE_TEXT" \
                       icon.color="$WORKSPACE_INACTIVE_TEXT"
        fi
    else
        sketchybar --set "space.$i" drawing=off
    fi
done

# Update front app display
if [[ -n "$APP" ]] && [[ "$APP" != " " ]]; then
    # Get app icon if icon mapper exists
    if [[ -x "$CONFIG_DIR/plugins/icon_map_fn.sh" ]]; then
        APP_ICON=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$APP" 2>/dev/null) || APP_ICON=""
    else
        APP_ICON=""
    fi
    
    if [[ -n "$APP_ICON" ]]; then
        sketchybar --set front_app \
                   drawing=on \
                   label="$APP" \
                   icon="$APP_ICON" \
                   icon.font="sketchybar-app-font:Regular:16.0"
    else
        sketchybar --set front_app \
                   drawing=on \
                   label="$APP"
    fi
else
    sketchybar --set front_app \
               drawing=on \
               label="Desktop" \
               icon=""
fi

# Update cache
echo "$AEROSPACE_DATA" > "$CACHE_FILE"