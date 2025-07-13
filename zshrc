export ZSH="$HOME/.oh-my-zsh"

for dir in \
    /bin \
    /opt/homebrew/bin \
    /usr/bin \
    /usr/sbin \
    /usr/local/bin \
    /usr/local/sbin
do
  if [[ -d $dir ]]; then
    path+=("$dir")
  fi
done

zstyle ':omz:update' mode auto

plugins=(autoupdate brew fzf fzf-tab git gh python sublime zsh-autosuggestions zsh-syntax-highlighting)

fpath=(/usr/local/share/zsh-completions $fpath)

alias gps="git pull && git submodule update --init --recursive"
alias gs="git status"
alias gd="git diff"

for f in ~/src/fi/keys/*.txt(N); do export "${${f:t}%.txt}"="$(<"$f")"; done

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_CUSTOM_AUTOUPDATE_NUM_WORKERS=8

export FZF_DEFAULT_COMMAND='fd --type file'

# Instant prompt (must come before oh-my-zsh.sh)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$ZSH/oh-my-zsh.sh"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# vim mode on ctrl-] so it works in neovim splits as well w/o escape conflicts
bindkey -v
bindkey '^]' vi-cmd-mode
bindkey -r '^['

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

