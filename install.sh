#!/bin/bash
set -e

echo "== Voidarchy =="

# must not be root
if [ "$EUID" -eq 0 ]; then
  echo "Run as normal user"
  exit 1
fi

chmod +x scripts/*.sh

bash scripts/install-pkgs.sh
bash scripts/userpref.sh b

echo ""
echo "== Copying dotfiles ... =="
cp -r "$(pwd)/configs/." ~

chmod +x ~/.config/voidarchy/scripts/*.sh

bash scripts/userpref.sh r
bash scripts/setup-wallpapers.sh
bash scripts/services.sh