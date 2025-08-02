#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get focused window info from AeroSpace
APP_NAME=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)
WINDOW_TITLE=$(aerospace list-windows --focused --format '%{window-title}' 2>/dev/null)

if [[ -n "$APP_NAME" && "$APP_NAME" != " " ]]; then
    # Get app icon using the icon mapping function
    APP_ICON=$($CONFIG_DIR/plugins/icon_map_fn.sh "$APP_NAME")
    
    # Combine app name with window title (simple format without icon for now)
    if [[ -n "$WINDOW_TITLE" && "$WINDOW_TITLE" != "$APP_NAME" ]]; then
        DISPLAY_TEXT="$APP_NAME: $WINDOW_TITLE"
    else
        DISPLAY_TEXT="$APP_NAME"
    fi
    
    sketchybar --set $NAME label="$DISPLAY_TEXT" \
                           icon="$APP_ICON" \
                           icon.font="sketchybar-app-font:Regular:16.0" \
                           drawing=on
else
    sketchybar --set $NAME label="Desktop" \
                           icon="" \
                           drawing=on
fi
