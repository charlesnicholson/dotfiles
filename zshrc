# Instant prompt (must be first)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

path=($HOME/.local/bin /opt/homebrew/bin /usr/local/bin /usr/local/sbin $path)

zstyle ':omz:update' mode auto

plugins=(autoupdate brew fzf fzf-tab git gh python zsh-autosuggestions zsh-syntax-highlighting)

alias gps="git pull && git submodule update --init --recursive"
alias gs="git status"
alias gd="git diff"

for f in ~/src/fi/keys/*.txt(N); do export "${${f:t}%.txt}"="$(<"$f")"; done

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
ZSH_CUSTOM_AUTOUPDATE_NUM_WORKERS=8

export FZF_DEFAULT_COMMAND='fd --type file'

source "$ZSH/oh-my-zsh.sh"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# vim mode on ctrl-] so it works in neovim splits as well w/o escape conflicts
bindkey -v
bindkey '^]' vi-cmd-mode
bindkey -r '^['

export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

[[ -f "$HOME/Library/Caches/envy/shell/hook.zsh" ]] && source "$HOME/Library/Caches/envy/shell/hook.zsh"
