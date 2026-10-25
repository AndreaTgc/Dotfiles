#!/bin/bash

cpu=$(top -l 2 -n 0 -s 1 | awk '/CPU usage/ { line=$0 } END {
  split(line, a, " ");
  gsub("%","",a[3]); gsub("%","",a[5]);
  printf "%.0f", a[3] + a[5]
}')

if [ "$cpu" -ge 80 ]; then
  color=0xfff43841
elif [ "$cpu" -ge 50 ]; then
  color=0xffffdd33
else
  color=0xff73d936
fi

sketchybar --set "$NAME" icon.color=$color label="${cpu}%" label.color=$color
