# Zsh Config
# Simon Sinding - renremoulade.me
# 2016 - Oct


export ZSH=$HOME/.oh-my-zsh
export SCRIPTS="$HOME/scripts"
export CLONE_DIR="$HOME/clones"

ZSH_THEME="bullet-train"

plugins=(git rake builder alias-tips zsh-autosuggestions zsh-syntax-highlighting copyzshell)

source $ZSH/oh-my-zsh.sh
#source $CLONE_DIR/enhancd/init.sh

# Other ?
source /etc/profile.d/autojump.zsh

# Custom aliases 

alias grep='grep --color=auto'
#alias ls='ls -la --color=auto' # This is the old boring ls
alias ls='exa -lha --git' # This is the new exciting ls
alias lst='exa -lhT -L 2 --git' # This is the new exciting ls
alias eb="vim ~/.zshrc"
alias q="quasar"
alias sb='source ~/.zshrc'
alias ewm='vim ~/.config/bspwm/bspwmrc'
alias ekm='vim ~/.config/sxhkd/sxhkdrc'
alias ep='vim ~/.config/bspwm/panels/panel'
alias htop='vtop'
alias s='cd ..'
alias updatePacman="sudo pacman -Sy"
alias ch='cd ~'
alias e='vim'
alias ya='PAGER="less -R" yaourt --pager --color'
alias ctc='xclip -sel c < '
alias yaourtwc='yaourt --m-arg --skipchecksums --m-arg --skippgpcheck -Sb'
alias fg='feathers generate'
alias c='clear'
alias t="tmux"

mkcd(){
    if [[ "$1" ]]
    then mkdir -p "$1" && cd "$1"
    fi
}

# Exports
export TERM='xterm-256color'
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export DEFAULT_USER='TheSinding'
export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/usr/lib/jvm/default"
export JDK_HOME="/usr/lib/jvm/java-8-openjdk/"
export EDITOR=vim
export GOPATH="$HOME/code/resources/Go"
export LOCALBIN="$HOME/.local/bin"
export LC_ALL="en_DK.UTF-8"
export ADB="$ANDROID_HOME/platform-tools"
export ANDROID_TOOLS="$ANDROID_HOME/tools"

# Bullet Train Specific
export BULLETTRAIN_DIR_EXTENDED=0
export BULLETTRAIN_DIR_BG=0
export BULLETTRAIN_DIR_FG=15
export BULLETTRAIN_TIME_BG=6
export BULLETTRAIN_TIME_FG=15
export BULLETTRAIN_GIT_BG=15
export CUSTOM_START="~ %F{blue}>"

# Path Checking

if [ -d "$GOPATH" ]; then
	PATH="$PATH:$GOPATH/bin"
else 
	echo "$GOPATH does not exsist"
    echo "Creating it for you"
	mkdir -p $GOPATH 
	echo "Done"
fi

if [ -d $ADB ]; then
    PATH="$ADB:$PATH"
fi

if [ -d $ANDROID_TOOLS ]; then
	PATH="$ANDROID_TOOLS:$PATH"
fi

if [ -d $LOCALBIN ]; then
    PATH="$HOME/.config/composer/vendor/bin:$HOME/.local/bin:$PATH"
else
	echo "$LOCALBIN does not exsist"
    echo "Creating it for you"
	mkdir $LOCALBIN -p
	echo "Done"
fi

# This line is for removing the VIM Ctrl-S thing..
stty -ixon

# Sourcing
# The line under here needs to be the last line for my install script to work!
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

###-tns-completion-start-###
if [ -f /home/thesinding/.tnsrc ]; then 
    source /home/thesinding/.tnsrc 
fi
###-tns-completion-end-###
