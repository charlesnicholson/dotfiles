export ZSH=$HOME/.oh-my-zsh
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

fpath=(/usr/local/share/zsh-completions $fpath)

ZSH_THEME="powerline"
POWERLINE_NO_BLANK_LINE="true"
POWERLINE_HIDE_HOST_NAME="true"
POWERLINE_HIDE_USER_NAME="true"

DEFAULT_USER=cnicholson

alias gps="git pull && git submodule update --init --recursive"
alias gs="git status"
alias gd="git diff"
alias v="nvim"
alias vim="nvim"

plugins=(osx brew fzf gem python screen sublime)

source $ZSH/oh-my-zsh.sh

for dir in \
    /usr/local/bin \
    /usr/bin \
    /bin \
    /usr/sbin \
    /usr/local/git/bin \
; do
  if [[ -d $dir ]]; then path+=$dir; fi
done

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

export FZF_DEFAULT_COMMAND='ag -l -g ""'

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(rbenv init -)"
