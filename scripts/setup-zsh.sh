#!/usr/bin/env bash

# voidarchy - Zsh Setup Script

source ./utils.sh

echo
echo "It is recommended to configure Zsh for a better experience."
echo -n "Would you like to continue? [Y/n]: "
read -r answer

# Default to yes if empty
answer=${answer:-Y}

case "$answer" in
  [Yy]* )
    echo "Continuing setup..."
    ;;
  *)
    echo "Skipping Zsh setup. You can run this script later to set it up."
    exit 0
    ;;
esac

print_block " Installing zsh useful plugins..."
sudo pacman -Sy --noconfirm \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-history-substring-search \
  eza

current_shell="$(getent passwd "$USER" | cut -d: -f7)"

if [ "$current_shell" = "/bin/zsh" ]; then
    print_block "Zsh is already the default shell."
else
    print_block "Setting zsh as default shell..."
    chsh -s /bin/zsh "$USER"
fi

print_block "Creating ~/.zshrc (if missing)..."
  
if [ ! -f "$HOME/.zshrc" ]; then
  cat > "$HOME/.zshrc" <<'EOF'
# Machine-specific configuration.
# allowing you to override any settings or add custom aliases/functions without modifying the main config.
# Useful for environment variables, path adjustments, or machine-specific tools.

alias c='clear'
alias l='eza -lh --icons=auto'
alias ls='eza --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias vc='code'

fastfetch
EOF
fi

echo
echo "Setup complete."
echo "Restart terminal or run: exec zsh"
echo