#!/bin/bash

# Get current date and time in Manila timezone
TIME=$(TZ="Asia/Manila" date '+%d/%m/%Y - %H:%M:%S')

sketchybar --set $NAME label="$TIME"
