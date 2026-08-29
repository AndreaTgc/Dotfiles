#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/powermenu-style.rasi"

choice=$(printf "%s\n" "Lock" "Logout" "Suspend" "Reboot" "Shutdown" |
    rofi -dmenu -i -p "Power" -theme="$ROFI_THEME")

case "$choice" in
    "Lock") swaylock ;;
    "Logout") hyprctl dispatch exit ;;
    "Suspend") systemctl suspend ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
    "") exit 0 ;;
esac
