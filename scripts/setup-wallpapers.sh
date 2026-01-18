#!/bin/bash

WALL_DIR="$HOME/Pictures/wallpapers"
REPO_URL="https://github.com/whoisYoges/lwalpapers.git"
WAYPAPER_CONF="$HOME/.config/waypaper/config.ini"

mkdir -p "$(dirname "$WAYPAPER_CONF")"

echo "Do you want to download wallpapers? (default: Y)"
read -r -p "[Y/n]: " choice
choice=${choice:-Y}

# create file if missing
[ -f "$WAYPAPER_CONF" ] || echo -e "[Settings]\nbackend = swww" > "$WAYPAPER_CONF"

# ensure [Settings] exists
grep -q "^\[Settings\]" "$WAYPAPER_CONF" || echo "[Settings]" | tee -a "$WAYPAPER_CONF" >/dev/null

# replace backend if exists, otherwise append
if grep -q "^backend\s*=" "$WAYPAPER_CONF"; then
  sed -i 's/^backend\s*=.*/backend = swww/' "$WAYPAPER_CONF"
else
  sed -i '/^\[Settings\]/a backend = swww' "$WAYPAPER_CONF"
fi


case "$choice" in
  y|Y|yes|YES)
    if [ -d "$WALL_DIR" ] && [ "$(ls -A "$WALL_DIR")" ]; then
      echo "Wallpaper folder already exists. Skipping download."
    else
      echo "Downloading wallpapers ..."
      mkdir -p "$WALL_DIR"
      git clone --depth=1 "$REPO_URL" "$WALL_DIR"
      rm -rf "$WALL_DIR/.git"
      echo "Wallpapers installed in $WALL_DIR"
    fi
    ;;
  *)
    echo "Skipped wallpaper download."
    ;;
esac


if command -v waypaper &>/dev/null; then
  echo "Setting a random wallpaper ..."
  waypaper --random --folder "$WALL_DIR"
else
  echo "waypaper is not installed. Please install it to set wallpapers."
fi