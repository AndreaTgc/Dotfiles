#!/bin/bash
# Runs for each space item. $NAME is e.g. "space.3".

# Aerospace is currently not in the usual bin directories
# so we gotta declare this variable
# Since sketchybar is started with a plist, even if this
# directory is in the path it's not going to see it
AEROSPACE="/Users/andreacolombo/Binaries/aerospace/bin/aerospace"
index=${NAME#space.}
focused=$($AEROSPACE list-workspaces --focused)

if [ "$focused" = "$index" ]; then
  sketchybar --set "$NAME" icon="●" icon.highlight=on
else
  sketchybar --set "$NAME" icon="○" icon.highlight=off
fi
