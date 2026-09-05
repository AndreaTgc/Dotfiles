#!/usr/bin/env bash

# dotmgr.sh: read a manifest, install packages via the platform's native
# package manager, symlink dotfiles.
# Same manifest format: `pkg`/`pkg:macos`/`pkg:arch` and
# `link`/`link:macos`/`link:arch`.

set -uo pipefail
failed=()

manifest="${1:-manifest.pkgs}"
manifest_dir="$(cd "$(dirname "$manifest")" && pwd)"

[[ "$(uname -s)" == "Darwin" ]] && plat="macos" || plat="arch"

install_pkg() {
    local pkg="$1"
    if [[ "$plat" == "macos" ]]; then
        if port -q installed "$pkg" 2>/dev/null | grep -q "^ *$pkg "; then
            echo "$pkg already installed, skipping"
            return
        fi
        echo "installing $pkg (ports)"
        sudo port install "$pkg" || failed+=("$pkg")
    else
        if pacman -Qi "$pkg" &>/dev/null; then
            echo "$pkg already installed, skipping"
            return
        fi
        echo "installing $pkg (pacman)"
        sudo pacman -S --noconfirm "$pkg" || failed+=("$pkg")
    fi
}

install_cask() {
    install_pkg "$1"
}

while read -r directive a b; do
    [[ -z "$directive" || "$directive" == \#* ]] && continue

    if [[ "$directive" == *:* ]]; then
        suffix="${directive#*:}"
        directive="${directive%%:*}"
        [[ "$suffix" != "$plat" ]] && continue
    fi

    case "$directive" in
        pkg)
            install_pkg "$a"
            ;;
        cask)
            install_cask "$a"
            ;;
        link)
            target="${b/#\~/$HOME}"
            src="$manifest_dir/$a"
            echo "linking $target -> $src"
            mkdir -p "$(dirname "$target")"
            ln -sfn "$src" "$target"
            ;;
    esac
done < "$manifest"

if [[ ${#failed[@]} -gt 0 ]]; then
    echo ""
    echo "failed to install: ${failed[*]}"
    exit 1
fi
