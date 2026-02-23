#!/bin/bash
set -e

echo "== Voidarchy =="

source ./utils.sh

# must not be root
if [ "$EUID" -eq 0 ]; then
  print_block "Run as normal user"
  exit 1
fi

echo "Sudo privileges are required for installation."
sudo -v

chmod +x scripts/*.sh

bash scripts/install-pkgs.sh
bash scripts/userpref.sh b

bash scripts/setup-zsh.sh

echo ""
print_block "Copying dotfiles ..."
cp -r "$(pwd)/configs/." ~

chmod +x ~/.config/voidarchy/scripts/*.sh

bash scripts/userpref.sh r
bash scripts/setup-wallpapers.sh
bash scripts/services.sh


# it's noticed that the hyprland is not reloading automatically after config copy
hyprctl reload

echo ""
print_block "Installation Complete!"

print_block "make sure to select hyprland session in lockscreen."
print_block "Enjoy your Voidarchy setup :)"

print_block "Its recommended to reboot the system now."
read -r -p "Reboot now? [Y/n] (default: Y): " reboot_choice </dev/tty
reboot_choice=${reboot_choice:-Y}
case "$reboot_choice" in
  y|Y|yes|YES)
    print_block "Rebooting..."
    sudo reboot
    ;;
  *)
    print_block "Reboot skipped. Please reboot manually."
    ;;
esac