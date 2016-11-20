# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

# Zsh Config
# Simon Sinding - renremoulade.me
# 2016 - Oct

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

mkcd(){
    if [[ "$1" ]]
    then mkdir -p "$1" && cd "$1"
    fi
}


# Exports
export TERM='xterm-256color'
export DEFAULT_USER='TheSinding'
export JAVA_HOME=/usr/lib/jvm/
export EDITOR=vim
export GOPATH="$HOME/code/resources/Go/"

if [ -d "$GOPATH/bin" ]; then
	PATH="$PATH:$GOPATH/bin"
fi
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.config/composer/vendor/bin:$HOME/.local/bin:$PATH"
fi

# Sourcing
source /home/thesinding/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting-filetypes/zsh-syntax-highlighting-filetypes.zsh
