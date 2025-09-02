#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Optimized consolidated system monitoring
# Cache file to track previous values and reduce unnecessary updates
CACHE_FILE="/tmp/sketchybar_system_cache"

# Get all system info efficiently
get_system_info() {
    # CPU Usage - using the proven method from original
    CPU_USAGE=$(top -l 2 -n 0 -F 2>/dev/null | grep "CPU usage" | tail -1 | awk '{gsub(/%/, "", $3); print int($3)}' 2>/dev/null)
    [[ -z "$CPU_USAGE" ]] || ! [[ "$CPU_USAGE" =~ ^[0-9]+$ ]] && CPU_USAGE=0
    [[ "$CPU_USAGE" -gt 100 ]] && CPU_USAGE=100
    
    # Memory Usage - correctly calculate app memory vs total
    MEMORY_USAGE=$(vm_stat 2>/dev/null | awk '
        /Pages free:/ { free = $3 }
        /Pages active:/ { active = $3 }
        /Pages inactive:/ { inactive = $3 }
        /Pages speculative:/ { spec = $3 }
        /Pages wired down:/ { wired = $4 }
        /Pages compressed:/ { compressed = $3 }
        END {
            gsub(/[^0-9]/, "", free); gsub(/[^0-9]/, "", active); 
            gsub(/[^0-9]/, "", inactive); gsub(/[^0-9]/, "", spec);
            gsub(/[^0-9]/, "", wired); gsub(/[^0-9]/, "", compressed)
            # Calculate app memory (active + wired) vs total physical memory
            app_memory = active + wired
            total = free + active + inactive + spec + wired
            if (total > 0) print int((app_memory * 100) / total)
            else print 0
        }')
    [[ -z "$MEMORY_USAGE" ]] || ! [[ "$MEMORY_USAGE" =~ ^[0-9]+$ ]] && MEMORY_USAGE=0
    [[ "$MEMORY_USAGE" -gt 100 ]] && MEMORY_USAGE=100
    
    # Battery Info - using proven pmset method from original
    BATTERY_INFO=$(pmset -g batt 2>/dev/null)
    BATTERY_PCT=$(echo "$BATTERY_INFO" | grep -o '[0-9]\+%' | head -1 | tr -d '%')
    BATTERY_CHARGING=$(echo "$BATTERY_INFO" | grep -q 'AC Power' && echo "1" || echo "0")
    [[ -z "$BATTERY_PCT" ]] || ! [[ "$BATTERY_PCT" =~ ^[0-9]+$ ]] && BATTERY_PCT=0
    [[ "$BATTERY_PCT" -gt 100 ]] && BATTERY_PCT=100
    
    echo "${CPU_USAGE}|${MEMORY_USAGE}|${BATTERY_PCT}|${BATTERY_CHARGING}"
}

# Load previous values from cache
[[ -f "$CACHE_FILE" ]] && PREV_VALUES=$(cat "$CACHE_FILE") || PREV_VALUES=""

# Get current values
CURRENT_VALUES=$(get_system_info)

# Only update if values changed significantly (2% threshold for CPU/Memory, any change for battery)
IFS='|' read -r CPU MEM BAT CHRG <<< "$CURRENT_VALUES"
IFS='|' read -r PREV_CPU PREV_MEM PREV_BAT PREV_CHRG <<< "$PREV_VALUES"

CPU_DIFF=$((CPU - PREV_CPU))
MEM_DIFF=$((MEM - PREV_MEM))
[[ $CPU_DIFF -lt 0 ]] && CPU_DIFF=$((0 - CPU_DIFF))
[[ $MEM_DIFF -lt 0 ]] && MEM_DIFF=$((0 - MEM_DIFF))

# Update only if significant change detected
if [[ "$PREV_VALUES" == "" ]] || [[ $CPU_DIFF -gt 2 ]] || [[ $MEM_DIFF -gt 2 ]] || \
   [[ "$BAT" != "$PREV_BAT" ]] || [[ "$CHRG" != "$PREV_CHRG" ]]; then
    
    # Determine battery icon and color
    if [[ "$CHRG" == "1" ]]; then
        BATTERY_ICON="󰂄"
        BATTERY_COLOR="0xff00ff00"
    elif [[ $BAT -le 10 ]]; then
        BATTERY_ICON="󰁺"
        BATTERY_COLOR="0xffff0000"
    elif [[ $BAT -le 20 ]]; then
        BATTERY_ICON="󰁻"
        BATTERY_COLOR="0xffff7833"
    elif [[ $BAT -le 40 ]]; then
        BATTERY_ICON="󰁾"
        BATTERY_COLOR="$ORANGE"
    elif [[ $BAT -le 60 ]]; then
        BATTERY_ICON="󰂀"
        BATTERY_COLOR="$ORANGE"
    elif [[ $BAT -le 80 ]]; then
        BATTERY_ICON="󰂁"
        BATTERY_COLOR="$ORANGE"
    else
        BATTERY_ICON="󰁹"
        BATTERY_COLOR="$ORANGE"
    fi
    
    # Update all components in single call
    sketchybar --set cpu drawing=on label="${CPU}%" icon.color="$ORANGE" label.color="$ORANGE" \
               --set memory drawing=on label="${MEM}%" icon.color="$ORANGE" label.color="$ORANGE" \
               --set battery_internal icon="$BATTERY_ICON" label="${BAT}%" icon.color="$BATTERY_COLOR" label.color="$BATTERY_COLOR"
    
    # Update cache
    echo "$CURRENT_VALUES" > "$CACHE_FILE"
fi