#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Consolidated system monitoring - CPU, Memory, Battery in single script
# This reduces system calls and improves performance significantly

# Cache file for previous values to avoid unnecessary updates
CACHE_FILE="/tmp/sketchybar_system_cache"

# Get all system info in parallel for maximum performance
get_system_info() {
    # CPU Usage - using top with optimized settings
    CPU_USAGE=$(top -l 2 -n 0 -F 2>/dev/null | grep "CPU usage" | tail -1 | awk '{gsub(/%/, "", $3); print int($3)}' 2>/dev/null)
    [[ -z "$CPU_USAGE" ]] || ! [[ "$CPU_USAGE" =~ ^[0-9]+$ ]] && CPU_USAGE=0
    [[ "$CPU_USAGE" -gt 100 ]] && CPU_USAGE=100
    
    # Memory Usage - optimized vm_stat parsing
    MEMORY_USAGE=$(vm_stat 2>/dev/null | awk '
        /Pages free:/ { free = $3 }
        /Pages active:/ { active = $3 }
        /Pages wired down:/ { wired = $4 }
        /Pages compressed:/ { compressed = $3 }
        END {
            gsub(/:/, "", free); gsub(/:/, "", active); gsub(/:/, "", wired); gsub(/:/, "", compressed)
            used = active + wired + compressed
            total = free + used
            if (total > 0) print int((used * 100) / total)
            else print 0
        }')
    [[ -z "$MEMORY_USAGE" ]] || ! [[ "$MEMORY_USAGE" =~ ^[0-9]+$ ]] && MEMORY_USAGE=0
    
    # Battery Info - single pmset call
    BATTERY_INFO=$(pmset -g batt 2>/dev/null)
    BATTERY_PERCENTAGE=$(echo "$BATTERY_INFO" | grep -o '[0-9]\+%' | head -1 | tr -d '%')
    BATTERY_CHARGING=$(echo "$BATTERY_INFO" | grep -q 'AC Power' && echo "true" || echo "false")
    [[ -z "$BATTERY_PERCENTAGE" ]] || ! [[ "$BATTERY_PERCENTAGE" =~ ^[0-9]+$ ]] && BATTERY_PERCENTAGE=0
    [[ "$BATTERY_PERCENTAGE" -gt 100 ]] && BATTERY_PERCENTAGE=100
    
    echo "$CPU_USAGE|$MEMORY_USAGE|$BATTERY_PERCENTAGE|$BATTERY_CHARGING"
}

# Check cache for previous values to avoid unnecessary updates
if [[ -f "$CACHE_FILE" ]]; then
    PREV_VALUES=$(cat "$CACHE_FILE")
else
    PREV_VALUES=""
fi

# Get current values
CURRENT_VALUES=$(get_system_info)

# Only update if values changed (reduces SketchyBar calls)
if [[ "$CURRENT_VALUES" != "$PREV_VALUES" ]]; then
    # Parse current values
    IFS='|' read -r CPU_USAGE MEMORY_USAGE BATTERY_PERCENTAGE BATTERY_CHARGING <<< "$CURRENT_VALUES"
    
    # Battery icon logic
    if [[ "$BATTERY_CHARGING" == "true" ]]; then
        BATTERY_ICON="󰂄"
        BATTERY_COLOR="0xff00ff00"
    elif [[ "$BATTERY_PERCENTAGE" -gt 80 ]]; then
        BATTERY_ICON="󰁹"
        BATTERY_COLOR="$ORANGE"
    elif [[ "$BATTERY_PERCENTAGE" -gt 60 ]]; then
        BATTERY_ICON="󰂀"
        BATTERY_COLOR="$ORANGE"
    elif [[ "$BATTERY_PERCENTAGE" -gt 40 ]]; then
        BATTERY_ICON="󰁾"
        BATTERY_COLOR="$ORANGE"
    elif [[ "$BATTERY_PERCENTAGE" -gt 20 ]]; then
        BATTERY_ICON="󰁻"
        BATTERY_COLOR="$ORANGE"
    elif [[ "$BATTERY_PERCENTAGE" -gt 15 ]]; then
        BATTERY_ICON="󰁺"
        BATTERY_COLOR="0xffffff7833"  # Warning
    else
        BATTERY_ICON="󰁺"
        BATTERY_COLOR="0xffff0000"    # Critical
    fi
    
    # Update all system components
    sketchybar --set cpu label="$CPU_USAGE%" icon.color="$ORANGE" label.color="$ORANGE"
    sketchybar --set memory label="$MEMORY_USAGE%" icon.color="$ORANGE" label.color="$ORANGE"
    sketchybar --set battery_internal icon="$BATTERY_ICON" label="$BATTERY_PERCENTAGE%" icon.color="$BATTERY_COLOR" label.color="$BATTERY_COLOR"
    
    # Update cache
    echo "$CURRENT_VALUES" > "$CACHE_FILE"
fi