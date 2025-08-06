#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get focused window app name from AeroSpace
APP_NAME=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)

if [[ -n "$APP_NAME" && "$APP_NAME" != " " ]]; then
    APP_ICON=$($CONFIG_DIR/plugins/icon_map_fn.sh "$APP_NAME")
    sketchybar --set $NAME label="$APP_NAME" \
                           icon="$APP_ICON" \
                           icon.font="sketchybar-app-font:Regular:16.0" \
                           drawing=on
else
    sketchybar --set $NAME label="Desktop" \
                           icon="" \
                           drawing=on
fi
