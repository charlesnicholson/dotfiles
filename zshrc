export ZSH=$HOME/.oh-my-zsh
export NPM_PACKAGES=$HOME/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

for dir in \
    /bin \
    /opt/homebrew/bin \
    /usr/bin \
    /usr/sbin \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/local/git/bin \
    /usr/local/opt/python@3.8/bin \
    $NPM_PACKAGES/bin \
    /Users/charles/src/gcc-arm-none-eabi-9-2019-q4-major/bin \
; do
  if [[ -d $dir ]]; then path+=$dir; fi
done

plugins=(macos brew fzf git gem python screen sublime ripgrep fd)
fpath=(/usr/local/share/zsh-completions $fpath)

alias gps="git pull && git submodule update --init --recursive"
alias gs="git status"
alias gd="git diff"

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
ZSH_AUTOSUGGEST_USE_ASYNC=1

#export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_COMMAND='fd --type file'

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
