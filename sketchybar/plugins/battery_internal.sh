#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Handle mouse events with optimized hover handler
if [[ "$SENDER" == "mouse.entered" || "$SENDER" == "mouse.exited" ]]; then
    "$CONFIG_DIR/plugins/hover_optimized.sh"
    exit 0
fi

# Get accurate battery info - improved parsing
BATTERY_INFO=$(pmset -g batt)
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -o '[0-9]\+%' | head -1 | tr -d '%')
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power\|charged')

# Validate percentage is a number
if [[ -z "$PERCENTAGE" ]] || ! [[ "$PERCENTAGE" =~ ^[0-9]+$ ]]; then
    # Fallback method using ioreg
    PERCENTAGE=$(ioreg -rc AppleSmartBattery | grep -o '"CurrentCapacity" = [0-9]*' | awk '{print $3}' | head -1)
    if [[ -z "$PERCENTAGE" ]] || ! [[ "$PERCENTAGE" =~ ^[0-9]+$ ]]; then
        PERCENTAGE=0
    fi
fi

# Ensure percentage is within bounds
if [[ "$PERCENTAGE" -gt 100 ]]; then
    PERCENTAGE=100
elif [[ "$PERCENTAGE" -lt 0 ]]; then
    PERCENTAGE=0
fi

# Battery icons based on percentage - optimized logic
if [[ "$PERCENTAGE" == "0" ]] || [[ -z "$PERCENTAGE" ]]; then
    ICON=$BATTERY_0
    COLOR=$ORANGE
elif [[ $PERCENTAGE -gt 80 ]]; then
    ICON=$BATTERY_100
    COLOR=$ORANGE
elif [[ $PERCENTAGE -gt 60 ]]; then
    ICON=$BATTERY_75
    COLOR=$ORANGE
elif [[ $PERCENTAGE -gt 40 ]]; then
    ICON=$BATTERY_50
    COLOR=$ORANGE
elif [[ $PERCENTAGE -gt 20 ]]; then
    ICON=$BATTERY_25
    COLOR=$ORANGE
else
    ICON=$BATTERY_0
    COLOR=$ORANGE
fi

# Override color and icon for charging/critical states
if [[ $CHARGING != "" ]]; then
    COLOR=$BATTERY_CHARGING
    ICON=$BATTERY_CHARGING
elif [[ "$PERCENTAGE" != "0" && $PERCENTAGE -lt 15 ]]; then
    COLOR=$BATTERY_CRITICAL
elif [[ "$PERCENTAGE" != "0" && $PERCENTAGE -lt 30 ]]; then
    COLOR=$BATTERY_WARNING
fi

# Single sketchybar call for efficiency
sketchybar --set $NAME icon="$ICON" \
                        label="$PERCENTAGE%" \
                        icon.color=$COLOR \
                        label.color=$COLOR
