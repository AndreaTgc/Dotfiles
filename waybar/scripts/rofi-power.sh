#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/powermenu-style.rasi"

options="󰍁\n󰗽\n󰤄\n󰑓\n󰐥"
chosen=$(echo -e "$options" | rofi -dmenu -p "" -theme "$ROFI_THEME") || exit 0
[ -z "$chosen" ] && exit 0

case "$chosen" in
    "󰍁") swaylock ;;
    "󰗽") swaymsg exit ;;
    "󰤄") systemctl suspend ;;
    "󰑓") systemctl reboot ;;
    "󰐥") systemctl poweroff ;;
esac
