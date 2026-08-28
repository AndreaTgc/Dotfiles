#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/wifipicker-style.rasi"

# Get available Wi-Fi networks
networks=$(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list \
    | awk -F: '
    {
        active = ($1 == "*")
        ssid = $2
        signal = $3
        security = $4

        if (ssid != "")
            printf "%s  %s%%  %s\n", ssid, signal, security
    }')

# Let the user select a network
selected=$(printf '%s\n' "$networks" | rofi \
    -dmenu \
    -i \
    -theme "$ROFI_THEME" \
    -p "" \
    -no-custom)

[ -z "$selected" ] && exit 0

# Extract SSID from the selected line
ssid=$(printf '%s\n' "$selected" | sed -E 's/^.*  (.*)  [0-9]+%  .*$/\1/')

# Check whether the network requires a password
security=$(printf '%s\n' "$selected" | sed -E 's/^.*  [0-9]+%  (.*)$/\1/')

if [ "$security" = "--" ]; then
    nmcli device wifi connect "$ssid"
else
    password=$(rofi \
        -dmenu \
        -password \
        -p "Password")

    [ -z "$password" ] && exit 0

    nmcli device wifi connect "$ssid" password "$password"
fi

