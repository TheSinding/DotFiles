
export DOTFILES="$HOME/code/DotFiles"

export LC_ALL=en_DK.UTF-8
export LANG=en_DK.UTF-8
export LANGUAGE=en_DK.UTF-8
export EDITOR="vim"

alias grep="grep --color=auto"
alias ls="lsd -la"
alias eb="vim ~/.zshrc && echo 'Sourcing zsh file' && source ~/.zshrc"
alias ed="vim $HOME/code/DotFiles/"
alias en="vim ~/.config/nvim"
alias sb="source ~/.zshrc"
alias s="cd .."
alias c="code ."
alias t="tmux"
alias cat="bat"
alias ping="prettyping"
alias vim="nvim"

alias gl="git pull"
alias gp="git push"
alias gco="git checkout"
alias ll="lazygit"



## WARNING THIS DISABLES NVM 
alias nvm="fnm"
eval "$(fnm env --use-on-cd --shell fish)"



# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Fish command history
function history
    builtin history --show-time="%F %T "
end

# Cleanup orphaned packages
alias cleanup="sudo pacman -Rns (pacman -Qtdq)"


starship init fish | source
