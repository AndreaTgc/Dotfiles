#!/bin/bash
# Runs for each space item. $NAME is e.g. "space.3".

AEROSPACE=$(which aerospace)

index=${NAME#space.}
focused=$("$AEROSPACE" list-workspaces --focused)

if [ "$focused" = "$index" ]; then
  sketchybar --set "$NAME" icon="●" icon.highlight=on
else
  sketchybar --set "$NAME" icon="○" icon.highlight=off
fi
