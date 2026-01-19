#!/bin/sh

BACKUP_DIR="$HOME/.cache/voidarchy/backups/"

# List of user preference files to back up or restore
FILES="
$XDG_CONFIG_HOME/hypr/userprefs.conf
$XDG_CONFIG_HOME/hypr/monitors.conf
"

ACTION="$1"

print_block() {
  echo
  echo "== $1 =="
}

if [ "$ACTION" != "b" ] && [ "$ACTION" != "r" ]; then
  print_block "USAGE"
  echo "  $0 b  -> backup"
  echo "  $0 r  -> restore"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

if [ "$ACTION" = "b" ]; then
  print_block "Staring backup of user preference files"
else
  print_block "Staring restore of user preference files"
fi

for SRC in $FILES; do
  DEST="$BACKUP_DIR$SRC"

  if [ "$ACTION" = "b" ]; then
    if [ -e "$SRC" ]; then
      mkdir -p "$(dirname "$DEST")"
      cp -a "$SRC" "$DEST"
      print_block "backed up: $SRC"
    else
      print_block "missing: $SRC"
    fi
  else
    if [ -e "$DEST" ]; then
      mkdir -p "$(dirname "$SRC")"
      cp -a "$DEST" "$SRC"
      print_block "restored: $SRC"
    else
      print_block "missing backup: $SRC"
    fi
  fi
done