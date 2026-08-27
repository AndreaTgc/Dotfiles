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
        if brew list --formula "$pkg" &>/dev/null; then
            echo "$pkg already installed, skipping"
            return
        fi
        echo "installing $pkg (brew)"
        brew install "$pkg" || failed+=("$pkg")
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
    local pkg="$1"
    if [[ "$plat" == "macos" ]]; then
        if brew list --cask "$pkg" &>/dev/null; then
            echo "$pkg already installed, skipping"
            return
        fi
        echo "installing $pkg (brew --cask)"
        brew install --cask "$pkg" || failed+=("$pkg")
    else
        # No separate "cask" concept on Arch -- same as install_pkg.
        # Not every macOS cask name matches an Arch package name (e.g.
        # claude-code isn't in the official repos at all) -- on failure
        # we record it and keep going rather than aborting the manifest.
        install_pkg "$pkg"
    fi
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
            ln -sf "$src" "$target"
            ;;
    esac
done < "$manifest"

if [[ ${#failed[@]} -gt 0 ]]; then
    echo ""
    echo "failed to install: ${failed[*]}"
    exit 1
fi
