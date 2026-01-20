#!/bin/bash

WALL_DIR="$HOME/Pictures/wallpapers"
REPO_URL="https://github.com/whoisYoges/lwalpapers.git"
DEFAULT_WALL="$XDG_CONFIG_HOME/voidarchy/wall.jpg"


print_block() {
  echo "== $1 =="
}


print_block "Wallpaper Setup"

read -r -p "Download wallpapers? [Y/n] (default: Y): " choice </dev/tty
choice=${choice:-Y}

case "$choice" in
  y|Y|yes|YES)
    print_block "Selected: Y"
    if [ -d "$WALL_DIR" ] && [ "$(ls -A "$WALL_DIR")" ]; then
      print_block "Wallpapers already exist"
    else
      print_block "Downloading wallpapers"
      print_block "Thanks to whoisYoges for the wallpaper collection"
      mkdir -p "$WALL_DIR"
      git clone --depth=1 "$REPO_URL" "$WALL_DIR"
      rm -rf "$WALL_DIR/.git"
    fi

    print_block "Setting random wallpaper"
    waypaper --random --folder "$WALL_DIR"
    ;;
  *)
    print_block "Selected: N"
    print_block "Using default wallpaper"
    waypaper --wallpaper "$DEFAULT_WALL"
    ;;
esac