#!/bin/bash
set -e

echo "== Voidarchy =="

# must not be root
if [ "$EUID" -eq 0 ]; then
  echo "Run as normal user"
  exit 1
fi

echo "Sudo privileges are required for installation."
sudo -v

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

# it's noticed that the hyprland is not reloading automatically after config copy
hyprctl reload

echo ""
echo "== Installation Complete! =="

echo "make sure to select hyprland session in lockscreen."
echo "Enjoy your Voidarchy setup :)"

echo "Its recommended to reboot the system now."
read -r -p "Reboot now? [Y/n] (default: Y): " reboot_choice </dev/tty
reboot_choice=${reboot_choice:-Y}
case "$reboot_choice" in
  y|Y|yes|YES)
    echo "Rebooting..."
    sudo reboot
    ;;
  *)
    echo "Reboot skipped. Please reboot manually."
    ;;
esac