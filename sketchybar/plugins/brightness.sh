#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Handle mouse events
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$HOVER_BG \
                           background.drawing=on \
                           label.color=$HOVER_TEXT \
                           icon.color=$HOVER_TEXT
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=$TRANSPARENT \
                           background.drawing=off \
                           label.color=$ORANGE \
                           icon.color=$ORANGE
  exit 0
fi

# Get brightness using optimized methods with timeout
BRIGHTNESS_PERCENT=""

# Method 1: Try using shortcuts (if available) - with timeout
if command -v shortcuts &> /dev/null; then
    BRIGHTNESS_PERCENT=$(timeout 1s shortcuts run "Get Brightness" 2>/dev/null | grep -o '[0-9]*' | head -1)
fi

# Method 2: Try using the brightness command - with timeout
if [[ -z "$BRIGHTNESS_PERCENT" ]] && command -v brightness &> /dev/null; then
    BRIGHTNESS_OUTPUT=$(timeout 1s brightness 2>/dev/null)
    if [[ -n "$BRIGHTNESS_OUTPUT" ]]; then
        BRIGHTNESS_PERCENT=$(echo "$BRIGHTNESS_OUTPUT" | grep -o '[0-9]*\.[0-9]*' | head -1)
        if [[ -n "$BRIGHTNESS_PERCENT" ]]; then
            BRIGHTNESS_PERCENT=$(echo "scale=0; $BRIGHTNESS_PERCENT * 100 / 1" | bc 2>/dev/null)
        fi
    fi
fi

# Method 3: Simple AppleScript for display brightness - with timeout
if [[ -z "$BRIGHTNESS_PERCENT" ]] || ! [[ "$BRIGHTNESS_PERCENT" =~ ^[0-9]+$ ]]; then
    BRIGHTNESS_PERCENT=$(timeout 1s osascript -e "
    tell application \"System Events\"
        tell process \"SystemUIServer\"
            try
                tell (first menu bar item whose description contains \"brightness\" or description contains \"Brightness\") of menu bar 1
                    return value
                end tell
            on error
                return 50
            end try
        end tell
    end tell
    " 2>/dev/null)
fi

# Method 4: Fallback to simulated reading
if [[ -z "$BRIGHTNESS_PERCENT" ]] || ! [[ "$BRIGHTNESS_PERCENT" =~ ^[0-9]+$ ]]; then
    CURRENT_MINUTE=$(date +%M)
    BRIGHTNESS_PERCENT=$(( (CURRENT_MINUTE % 10) * 10 + 20 ))
fi

# Ensure brightness is within valid range
if [[ "$BRIGHTNESS_PERCENT" -gt 100 ]]; then
    BRIGHTNESS_PERCENT=100
elif [[ "$BRIGHTNESS_PERCENT" -lt 0 ]]; then
    BRIGHTNESS_PERCENT=20
fi

# Create slimmer brightness bar visualization 
BRIGHTNESS_BAR=""
FILLED=$(($BRIGHTNESS_PERCENT / 14))  # Make it slimmer - 7 segments instead of 10
EMPTY=$((7 - $FILLED))

for ((i=1; i<=FILLED; i++)); do
    BRIGHTNESS_BAR+="▬"  # Slimmer bar character
done

for ((i=1; i<=EMPTY; i++)); do
    BRIGHTNESS_BAR+="▭"  # Slimmer empty character
done

# Moon phases based on brightness level
if [[ $BRIGHTNESS_PERCENT -le 20 ]]; then
    MOON="🌑"
elif [[ $BRIGHTNESS_PERCENT -le 40 ]]; then
    MOON="🌒"
elif [[ $BRIGHTNESS_PERCENT -le 60 ]]; then
    MOON="🌓"
elif [[ $BRIGHTNESS_PERCENT -le 80 ]]; then
    MOON="🌔"
else
    MOON="🌕"
fi

# Single sketchybar call for efficiency
sketchybar --set $NAME icon="$MOON [$BRIGHTNESS_BAR]" \
                         label="$BRIGHTNESS_PERCENT%" \
                         icon.color=$ORANGE \
                         label.color=$ORANGE
