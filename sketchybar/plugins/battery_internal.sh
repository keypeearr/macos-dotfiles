#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

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

# Get internal battery info (BAT0 equivalent)
BATTERY_INFO=$(pmset -g batt | grep "InternalBattery")
PERCENTAGE=$(echo $BATTERY_INFO | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo $BATTERY_INFO | grep 'AC Power')

# Battery icons based on percentage
if [[ $PERCENTAGE -gt 80 ]]; then
    ICON=$BATTERY_100
elif [[ $PERCENTAGE -gt 60 ]]; then
    ICON=$BATTERY_75
elif [[ $PERCENTAGE -gt 40 ]]; then
    ICON=$BATTERY_50
elif [[ $PERCENTAGE -gt 20 ]]; then
    ICON=$BATTERY_25
else
    ICON=$BATTERY_0
fi

# Set colors based on charging status and percentage
if [[ $CHARGING != "" ]]; then
    COLOR=$BATTERY_CHARGING
    ICON=$BATTERY_CHARGING
elif [[ $PERCENTAGE -lt 15 ]]; then
    COLOR=$BATTERY_CRITICAL
elif [[ $PERCENTAGE -lt 30 ]]; then
    COLOR=$BATTERY_WARNING
else
    COLOR=$ORANGE
fi

sketchybar --set $NAME icon="$ICON" \
                        label="$PERCENTAGE%" \
                        icon.color=$COLOR \
                        label.color=$COLOR
