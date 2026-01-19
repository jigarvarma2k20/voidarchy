#!/bin/bash

WALL_DIR="$HOME/Pictures/wallpapers"
REPO_URL="https://github.com/whoisYoges/lwalpapers.git"
DEFAULT_WALL="$XDG_CONFIG_HOME/voidarchy/wall.jpg"

echo "== Wallpaper Setup =="

read -r -p "Download wallpapers? [Y/n] (default: Y): " choice </dev/tty
choice=${choice:-Y}

case "$choice" in
  y|Y|yes|YES)
    echo "== Selected: Y =="
    if [ -d "$WALL_DIR" ] && [ "$(ls -A "$WALL_DIR")" ]; then
      echo "== Wallpapers already exist =="
    else
      echo "== Downloading wallpapers =="
      echo "== Thanks to whoisYoges for the wallpaper collection =="
      mkdir -p "$WALL_DIR"
      git clone --depth=1 "$REPO_URL" "$WALL_DIR"
      rm -rf "$WALL_DIR/.git"
    fi

    echo "== Setting random wallpaper =="
    waypaper --random --folder "$WALL_DIR"
    ;;
  *)
    echo "== Selected: N =="
    echo "== Using default wallpaper =="
    waypaper --wallpaper "$DEFAULT_WALL"
    ;;
esac
