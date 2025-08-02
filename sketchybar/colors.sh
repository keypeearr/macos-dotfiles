#!/bin/bash

# Color Palette based on your Waybar config
export BLACK=0xff181926
export WHITE=0xfff4f4f5
export RED=0xffed8796
export GREEN=0xffa6da95
export BLUE=0xff8aadf4
export YELLOW=0xffeed49f
export ORANGE=0xffff7833  # Your main accent color rgb(255, 120, 51)
export MAGENTA=0xfff5bde6
export GREY=0xff939ab7
export TRANSPARENT=0x00000000

# General bar colors
export BAR_COLOR=0x00000000  # Transparent background
export ITEM_BG_COLOR=0xcc1e1e1e  # rgba(30, 30, 30, 0.8)
export ACCENT_COLOR=$ORANGE

# Specific item colors
export ICON_COLOR=$ORANGE
export LABEL_COLOR=$ORANGE
export BACKGROUND_1=0xcc1e1e1e  # rgba(30, 30, 30, 0.8)
export BACKGROUND_2=0x603c3e4f

# Workspace colors
export WORKSPACE_ACTIVE_BG=$ORANGE
export WORKSPACE_ACTIVE_TEXT=$WHITE
export WORKSPACE_INACTIVE_BG=$TRANSPARENT
export WORKSPACE_INACTIVE_TEXT=$ORANGE

# Battery colors
export BATTERY_CHARGING=0xff00ff00
export BATTERY_WARNING=$ORANGE
export BATTERY_CRITICAL=0xffff0000

# Hover colors (matching Waybar)
export HOVER_BG=0x4dff7833  # rgba(255, 120, 51, 0.3)
export HOVER_TEXT=$WHITE
export WORKSPACE_HOVER_BG=0x80ff7833  # rgba(255, 120, 51, 0.5) for workspaces

# Active/pressed colors
export ACTIVE_BG=$ORANGE
export ACTIVE_TEXT=$WHITE
