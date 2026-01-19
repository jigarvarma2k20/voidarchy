#!/bin/bash
set -euo pipefail

# resolve script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

PKG_LIST="$PARENT_DIR/pkg_list"
AUR_LIST="$PARENT_DIR/aur_list"
YAY_DIR="/tmp/yay"

print_block() {
  echo
  echo "== $1 =="
}

install_pacman() {
  if [ -s "$PKG_LIST" ]; then
    print_block "INSTALLING OFFICIAL PACKAGES"
    sudo pacman -S --needed --noconfirm - < "$PKG_LIST"
  else
    echo "== SKIP == pkg_list missing or empty"
  fi
}

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    echo "== OK == yay already installed"
    return
  fi

  print_block "INSTALLING YAY (AUR HELPER)"
  rm -rf "$YAY_DIR"
  git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
  (cd "$YAY_DIR" && makepkg -si --noconfirm)
  rm -rf "$YAY_DIR"
}

install_aur() {
  if [ -s "$AUR_LIST" ]; then
    print_block "INSTALLING AUR PACKAGES"
    install_yay
    yay -S --needed --noconfirm - < "$AUR_LIST"
  else
    echo "== SKIP == aur_list missing or empty"
  fi
}

print_block "PACKAGE INSTALL START"
install_pacman
install_aur