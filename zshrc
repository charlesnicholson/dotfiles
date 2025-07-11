export ZSH="$HOME/.oh-my-zsh"
export NPM_PACKAGES="$HOME/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"

for dir in \
    /bin \
    /opt/homebrew/bin \
    /usr/bin \
    /usr/sbin \
    /usr/local/bin \
    /usr/local/sbin \
    "$NPM_PACKAGES/bin"
do
  if [[ -d $dir ]]; then
    path+=("$dir")
  fi
done

plugins=(brew fzf git gh gem python screen sublime zsh-autosuggestions zsh-syntax-highlighting)
fpath=(/usr/local/share/zsh-completions $fpath)

alias gps="git pull && git submodule update --init --recursive"
alias gs="git status"
alias gd="git diff"

[[ -f "$HOME/src/fi/github-pat.txt" ]] && export GITHUB_TOKEN=$(<"$HOME/src/fi/github-pat.txt")
[[ -f "$HOME/src/fi/basic-auth.txt" ]] && export FI_SERVER_AUTH_HEADER=$(<"$HOME/src/fi/basic-auth.txt")
[[ -f "$HOME/src/fi/openai-key.txt" ]] && export OPENAI_API_KEY=$(<"$HOME/src/fi/openai-key.txt")

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
ZSH_AUTOSUGGEST_USE_ASYNC=1

export FZF_DEFAULT_COMMAND='fd --type file'

export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi

### Instant prompt (must come before oh-my-zsh.sh)
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

