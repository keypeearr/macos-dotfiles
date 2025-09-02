#!/bin/bash

source "$CONFIG_DIR/colors.sh" 2>/dev/null || {
    ORANGE="0xfff5a442"
}

# Handle mouse events with optimized hover handler
if [[ "$SENDER" == "mouse.entered" || "$SENDER" == "mouse.exited" ]]; then
    if [[ -x "$CONFIG_DIR/plugins/hover_optimized.sh" ]]; then
        "$CONFIG_DIR/plugins/hover_optimized.sh"
    fi
    exit 0
fi

# Get CPU usage using a more reliable method
get_cpu_usage() {
    local cpu_line=$(top -l 2 -n 0 -F 2>/dev/null | grep "CPU usage" | tail -1)
    if [[ -n "$cpu_line" ]]; then
        # Extract user percentage from CPU usage line
        echo "$cpu_line" | awk '{gsub(/%/, "", $3); print int($3)}'
    else
        # Fallback to iostat if available
        if command -v iostat >/dev/null 2>&1; then
            iostat -c 1 2 2>/dev/null | tail -1 | awk '{print int(100-$6)}'
        else
            # Final fallback using ps
            ps -A -o %cpu 2>/dev/null | awk '{sum += $1} END {print int(sum)}'
        fi
    fi
}

CPU_USAGE=$(get_cpu_usage)

# Ensure reasonable bounds and valid number
if ! [[ "$CPU_USAGE" =~ ^[0-9]+$ ]] || [[ "$CPU_USAGE" -lt 0 ]]; then
    CPU_USAGE=0
elif [[ "$CPU_USAGE" -gt 100 ]]; then
    CPU_USAGE=100
fi

# Update sketchybar
sketchybar --set "$NAME" label="${CPU_USAGE}%" \
                         icon.color="$ORANGE" \
                         label.color="$ORANGE" 2>/dev/null
