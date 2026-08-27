#!/usr/bin/env bash

choice=$(printf "Logout\nSuspend\nReboot\nShutdown\n" |
    rofi -dmenu -i -p "Power")

case "$choice" in
    "Logout") hyprctl dispatch exit ;;
    "Suspend") systemctl suspend ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
esac
