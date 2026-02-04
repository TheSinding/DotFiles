# Zsh Config
# Simon Sinding - sinding.dev
# 2016 - Oct

#export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true
#export BAT_THEME="Nord"
export SCRIPTS="$HOME/scripts"
export CLONE_DIR="$HOME/clones"
export LC_ALL=da_DK.UTF-8
export LANG=da_DK.UTF-8
export LANGUAGE=da_DK.UTF-8
export EDITOR="vim"
export GOPATH="$HOME/code/resources/Go"
export LOCALBIN="$HOME/.local/bin"
export ADB="$ANDROID_HOME/platform-tools"
export ANDROID_TOOLS="$ANDROID_HOME/tools"
export TERM='xterm-256color'
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

export BAT_THEME="gruvbox-dark"

alias python=python3
alias grep='grep --color=auto'
alias ls='lsd -la'
alias eb="vim ~/.zshrc && echo 'Sourcing zsh file' && source ~/.zshrc"
alias sb='source ~/.zshrc'
alias s='cd ..'
alias c='code .'
alias t="tmux"
alias cat="bat"
alias ping="prettyping"
alias vim="nvim"
alias pingme="osascript -e 'display notification \"COMMAND DONE!\" with title \"PING PING MOTHERFUCKER\"'"
alias gl='git pull'
alias gp='git push'


## WARNING THIS DISABLES NVM 
alias nvm="fnm"
eval "$(fnm env --use-on-cd --shell zsh)"


setopt EXTENDED_HISTORY
setopt autocd

autoload -U compinit; compinit

eval "$(starship init zsh)"

source <(fzf --zsh)

set -o vi
# Fix for backspace in vi mode
bindkey -v '^?' backward-delete-char

#plugins=(git git-flow rake alias-tips zsh-autosuggestions zsh-syntax-highlighting minikube)

# Open TMUX if exists
#if [ -z "$TMUX" ]; then
  #tmux attach -t TMUX || tmux new -s TMUX
#fi

mkcd(){
  if [[ "$1" ]]
  then mkdir -p "$1" && cd "$1"
  fi
}

# LEGO

alias am-signin-aws-dev='saml2aws login -a am-dev --skip-prompt --force --mfa-token $(op item get --otp goj53afetg27ald242bsm5yse4)'
alias am-signin-aws-qa='saml2aws login -a am-qa --skip-prompt --force --mfa-token $(op item get --otp goj53afetg27ald242bsm5yse4)'
alias am-signin-aws-prod='saml2aws login -a am-prod --skip-prompt --force --mfa-token $(op item get --otp goj53afetg27ald242bsm5yse4)'

alias am-tunnel-db='aws ssm start-session --target $(aws ssm describe-instance-information | jq -r ".InstanceInformationList.[0].InstanceId") --region eu-west-1  --document-name "AWS-StartPortForwardingSessionToRemoteHost" --parameters host=$(aws rds describe-db-clusters | jq ".DBClusters.[0].Endpoint"),portNumber="5432",localPortNumber="5432"'

alias am-pgcli='pgcli $(aws secretsmanager get-secret-value --secret-id postgres-connection-string-base | jq -r ".SecretString | fromjson | .POSTGRESQL_CONNECTION_STRING" | sed "s/@.*/@localhost:5432/")'

#if [ -d "$HOME/Library/Android/sdk" ]; then
#  ANDROID_HOME="$HOME/Library/Android/sdk"
#  PATH="$ANDROID_HOME/platform-tools:$PATH"
#fi

#if [ -d $ADB ]; then
#    PATH="$ADB:$PATH"
#fi

#if [ -d $ANDROID_TOOLS ]; then
#	PATH="$ANDROID_TOOLS:$PATH"
#fi


# This line is for removing the VIM Ctrl-S thing..
stty -ixon

#nvm() {
#  echo "Loading nvm..."
#  unset -f nvm
#  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#  # Call nvm with original arguments
#  nvm "$@"
#}

j() {
  echo "Loading autojump..."
  unset -f j
  [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
  # Call nvm with original arguments
  j "$@"
}



# LEGO Specific
export AWS_PROFILE=default
export AWS_DEFAULT_REGION=eu-west-1
export AWS_REGION=${AWS_DEFAULT_REGION}
export SAML2AWS_REGION=${AWS_DEFAULT_REGION}

. "$HOME/.local/bin/env"
