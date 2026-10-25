#!/bin/bash

info=$(pmset -g batt)
percent=$(echo "$info" | grep -Eo "[0-9]+%" | head -1)

if echo "$info" | grep -q "AC Power"; then
  sketchybar --set "$NAME" label="+ ${percent}"
else
  sketchybar --set "$NAME" label="${percent}"
fi
