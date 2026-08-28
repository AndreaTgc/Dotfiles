#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/powermenu-style.rasi"

choice=$(printf "Logout\nSuspend\nReboot\nShutdown\n" |
    rofi -dmenu -i -p "Power" -theme="$ROFI_THEME")

case "$choice" in
    "Logout") hyprctl dispatch exit ;;
    "Suspend") systemctl suspend ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
esac
