#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Cache file for time to avoid unnecessary updates every second
CACHE_FILE="/tmp/sketchybar_time_cache"
CURRENT_MINUTE=$(date '+%Y%m%d%H%M')

# Only update if minute changed (reduces updates from 60/min to 1/min)
if [[ ! -f "$CACHE_FILE" ]] || [[ "$(cat "$CACHE_FILE")" != "$CURRENT_MINUTE" ]]; then
    TIME=$(TZ="Asia/Manila" date '+%d/%m/%Y - %H:%M' 2>/dev/null)
    [[ -z "$TIME" ]] && TIME="$(date '+%d/%m/%Y - %H:%M')"
    
    sketchybar --set "$NAME" label="$TIME" \
                             icon.color="$ORANGE" \
                             label.color="$ORANGE"
    
    echo "$CURRENT_MINUTE" > "$CACHE_FILE"
fi
