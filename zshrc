export ZSH=$HOME/.oh-my-zsh
export NPM_PACKAGES=$HOME/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

fpath=(/usr/local/share/zsh-completions $fpath)

ZSH_THEME="powerline"
POWERLINE_NO_BLANK_LINE="true"
POWERLINE_HIDE_HOST_NAME="true"
POWERLINE_HIDE_USER_NAME="true"

alias gps="git pull && git submodule update --init --recursive"
alias gs="git status"
alias gd="git diff"

plugins=(osx brew fzf gem python screen sublime)


for dir in \
    /bin \
    /usr/bin \
    /usr/sbin \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/local/git/bin \
    ~/.gem/ruby/2.7.0/bin \
    $NPM_PACKAGES/bin \
; do
  if [[ -d $dir ]]; then path+=$dir; fi
done

eval "$(rbenv init -)"

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

