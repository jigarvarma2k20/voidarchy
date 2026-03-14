######## Voidarchy Zsh Configuration ########
# This is the primary Zsh configuration file. It sets up the shell environment,
# For machine-specific overrides, add custom settings to ~/.zshrc

# Completion
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# History
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Starship Configuration
eval "$(starship init zsh)"


######## Load Local Overrides ##########

if [ -f "$HOME/.zshrc" ]; then
  source "$HOME/.zshrc"
fi