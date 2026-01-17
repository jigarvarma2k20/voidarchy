#!/bin/bash
set -e

echo "== Voidarchy =="

# must not be root
if [ "$EUID" -eq 0 ]; then
  echo "Run as normal user"
  exit 1
fi

if [ -s "pkg_list" ]; then
    echo "Installing official packages..."
    sudo pacman -S --needed --noconfirm - < pkg_list
else
    echo "pkg_list is empty or missing, skipping."
fi


if [ -s "aur_list" ]; then
    echo ""
    echo "Installing AUR packages (yay)..."
    if ! command -v yay &>/dev/null; then
        echo "'yay' not found, installing it first..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
    fi
    if command -v yay >/dev/null; then
        yay -S --needed --noconfirm - < aur_list
    else
        echo "Error: 'yay' not found. Cannot install AUR packages."
    fi
else
    echo ""
    echo "aur_list is empty, nothing to install from AUR."
fi

echo ""
echo "== Copying dotfiles... =="
cp -r "$(pwd)/configs/." ~

echo ""
chmod +x scripts/*.sh
echo "== Setting up wallpaper... =="
bash scripts/setup-wallpapers.sh

echo "== Starting services... =="
systemctl --user enable --now pipewire wireplumber
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager
sudo systemctl enable power-profiles-daemon
sudo systemctl enable sddm