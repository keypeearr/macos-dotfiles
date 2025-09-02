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

# Get memory usage using a more reliable method
get_memory_usage() {
    local vm_output=$(vm_stat 2>/dev/null)
    if [[ -n "$vm_output" ]]; then
        echo "$vm_output" | awk '
            /Pages free:/ { free = $3 }
            /Pages active:/ { active = $3 }
            /Pages inactive:/ { inactive = $3 }
            /Pages speculative:/ { speculative = $3 }
            /Pages wired down:/ { wired = $4 }
            /Pages compressed:/ { compressed = $3 }
            END {
                # Remove colons and convert to numbers
                gsub(/:/, "", free); gsub(/:/, "", active); gsub(/:/, "", inactive)
                gsub(/:/, "", speculative); gsub(/:/, "", wired); gsub(/:/, "", compressed)
                
                # Validate we got reasonable numbers
                if (free == "" || active == "" || wired == "" || compressed == "") {
                    print 0
                    exit
                }
                
                # Calculate memory usage (active + wired + compressed represent actual usage)
                used_pages = active + wired + compressed
                total_pages = free + active + inactive + speculative + wired + compressed
                
                if (total_pages > 0) {
                    usage_percent = int((used_pages * 100) / total_pages)
                    if (usage_percent > 100) usage_percent = 100
                    if (usage_percent < 0) usage_percent = 0
                    print usage_percent
                } else {
                    print 0
                }
            }
        '
    else
        # Fallback using ps if vm_stat fails
        if command -v ps >/dev/null 2>&1; then
            local mem_kb=$(ps -A -o rss= 2>/dev/null | awk '{sum+=$1} END {print int(sum/1024)}')
            local total_mb=$(sysctl -n hw.memsize 2>/dev/null | awk '{print int($1/1024/1024)}')
            if [[ -n "$mem_kb" && -n "$total_mb" && "$total_mb" -gt 0 ]]; then
                echo $(( mem_kb * 100 / total_mb ))
            else
                echo 0
            fi
        else
            echo 0
        fi
    fi
}

MEMORY_USAGE=$(get_memory_usage)

# Ensure reasonable bounds and valid number
if ! [[ "$MEMORY_USAGE" =~ ^[0-9]+$ ]] || [[ "$MEMORY_USAGE" -lt 0 ]]; then
    MEMORY_USAGE=0
elif [[ "$MEMORY_USAGE" -gt 100 ]]; then
    MEMORY_USAGE=100
fi

# Update sketchybar
sketchybar --set "$NAME" label="${MEMORY_USAGE}%" \
                         icon.color="$ORANGE" \
                         label.color="$ORANGE" 2>/dev/null
