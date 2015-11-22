# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export PATH=/usr/local/gcc-arm-none-eabi-4_9-2014q4/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

ZSH_THEME="powerline"
POWERLINE_NO_BLANK_LINE="true"
POWERLINE_HIDE_HOST_NAME="true"
POWERLINE_HIDE_USER_NAME="true"

DEFAULT_USER=cnicholson

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias gps="git pull && git submodule update --init --recursive"
alias gs="git status"
alias v="mvim -v"
alias vim="mvim -v"
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx brew fasd gem git_remote_branch python ruby screen sublime mvn)

source $ZSH/oh-my-zsh.sh

# User configuration

for dir in \
    /usr/local/bin \
    /usr/bin \
    /bin \
    /usr/sbin \
    /usr/local/git/bin \
    /usr/local/gcc-4.8.0-qt-4.8.4-for-mingw32/win32-gcc/bin \
    ~/bin
; do
  if [[ -d $dir ]]; then path+=$dir; fi
done

# export MANPATH="/usr/local/man:$MANPATH"
export ANDROID_HOME='/Users/cnicholson/Development/adt-bundle-mac-x86_64-20140321/sdk'
export ANDROID_NDK_HOME='/Users/cnicholson/Development/android-ndk-r9d'
export ANDROID_NDK=$ANDROID_NDK_HOME
export NDK_HOME=$ANDROID_NDK_HOME

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_55.jdk/Contents/Home

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
export FZF_DEFAULT_COMMAND='ag -l -g ""'

PERL_MB_OP=T"--install_base \"/Users/cnicholson/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/cnicholson/perl5"; export PERL_MM_OPT;

brewchown () {
    CHOWNDIRS=("/usr/local/bin" "/usr/local/share" "/usr/local/share/man" "/usr/local/share/man/man1")
    for d in $CHOWNDIRS; do
        CMD="chown $USER $d"
        owner=`ls -ld $d | awk '{print $3}'`
        if [ "$owner" != "$USER" ]; then
            echo 1>&2 "It's brewchown time.  Chomp, chomp ..."
            echo 1>&2 sudo for: $CMD
            sudo $CMD
            break
        fi
    done
}

#brew () {
 #   brewchown
  #  `which brew` $@
#}

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

