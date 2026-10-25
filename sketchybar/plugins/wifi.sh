#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

dev=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
ssid=$(networksetup -getairportnetwork "$dev" 2>/dev/null | sed 's/^Current Wi-Fi Network: //')

if [ -z "$ssid" ] || echo "$ssid" | grep -q "not associated"; then
  sketchybar --set "$NAME" icon.color=$DIM label="offline" label.color=$DIM
else
  sketchybar --set "$NAME" icon.color=$FG label="$ssid" label.color=$FG
fi
