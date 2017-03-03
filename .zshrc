# Zsh Config
# Simon Sinding - renremoulade.me
# 2016 - Oct


export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bullet-train"

plugins=(git osx rake builder alias-tips zsh-autosuggestions zsh-syntax-highlighting-filetypes )

source $ZSH/oh-my-zsh.sh

# Custom aliases 
alias c='clear'
alias wee='weechat'
alias grep='grep --color=auto'
alias ls='ls -la --color=auto'
alias eb="vim ~/.zshrc"
alias ewm='vim ~/.config/bspwm/bspwmrc'
alias ekm='vim ~/.config/sxhkd/sxhkdrc'
alias ep='vim ~/.config/bspwm/panels/panel'
alias s='cd ..'
alias ch='cd ~'
alias e='vim'
alias ya='PAGER="less -R" yaourt --pager --color'

mkcd(){
    if [[ "$1" ]]
    then mkdir -p "$1" && cd "$1"
    fi
}

# Exports
export TERM='xterm-256color'
export DEFAULT_USER='TheSinding'
export JAVA_HOME=/usr/lib/jvm/default
export EDITOR=vim
export GOPATH="$HOME/code/resources/Go"
export LOCALBIN="$HOME/.local/bin"
export LC_ALL="en_DK.UTF-8"
export ADB="$HOME/sdks/platform-tools"
if [ -d "$GOPATH/bin" ]; then
	PATH="$PATH:$GOPATH/bin"
else 
				echo "$GOPATH does not exsist"
				echo "Creating it for you"
				mkdir $GOPATH -p
				echo "Done"
fi
if [ -d $ADB ]; then
				PATH="$ADB:$PATH"
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
source /home/thesinding/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting-filetypes/zsh-syntax-highlighting-filetypes.zsh
