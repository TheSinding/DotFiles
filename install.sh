#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$PWD"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
line=$(printf '%.0s-' {1..40})

function printHeadline { echo -e "\n\n${line}\n${BOLD}$1${NORMAL}\n${line}"; }
function printBold     { echo "${BOLD}$1${NORMAL}"; }

function link {
	printf "%-50s" "$3"
    if [[ -z "$1" ]]; then 
        printf "$1 folder exists - making backup"
        mkdir $DOTFILES/backup 2&>1 /dev/null || true
        cp -r $1 $DOTFILES/backup
    fi

	if ln -s "$1" "$2" 2>/dev/null; then
		printf " - ${BOLD}Done${NORMAL}\n"
	else
		printf " - ${BOLD}Link exists${NORMAL}\n"
	fi
}

### Git check ###

if [ ! -d ".git" ]; then
	printBold "No git repository found! Clone the repo first. Exiting."
	exit 1
fi

### Welcome ###

printBold "WELCOME TO TIMMY THE TINY INSTALLER, HAVE A NICE STAY! <3"
printf "Ready"; sleep 1
printf " Set"; sleep 0.25
for (( i=0; i<=4; i++ )); do sleep 0.25; printf "."; done
printf " ${BOLD}BAKE!${NORMAL}\n"; sleep 1

### Common dirs ###

USER_CONFIG="$HOME/.config"
mkdir -p "$HOME/code" "$HOME/clones" "$USER_CONFIG"

### Create default configs if not present ###

cp "$DOTFILES/starship/starship-gruvbox-dark.toml" "$DOTFILES/starship/starship.toml" 2>/dev/null || true
cp "$DOTFILES/ghostty/config-gruvbox-dark" "$DOTFILES/ghostty/config" 2>/dev/null || true

### Symlinks ###


### Important! Linking folders should be linked like fish or nvim below
### If linking like {SOURCE}/folder to {TARGET}/folder, it will try
### to create the link in side of the path of {TARGET}/folder

printHeadline "Linking stuff!"

ZSH="$DOTFILES/zsh"
TMUX="$DOTFILES/tmux"
TMUXREPO="$TMUX/tmux_gpakosz"
TPM="$TMUX/tpm"

[ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc.pre-dotfiles" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.pre-dotfiles"

link "$DOTFILES/fish"                     "$USER_CONFIG"                    "Linking fish configs"
link "$ZSH/.zshrc"                     "$HOME/.zshrc"                    "Linking .zshrc"
link "$TMUXREPO/.tmux.conf"            "$HOME/.tmux.conf"                "Linking TMUX config"
link "$TMUX/.tmux.conf.local"          "$HOME/.tmux.conf.local"          "Linking local TMUX config"
link "$DOTFILES/nvim"                  "$USER_CONFIG"               "Linking NVIM config"
link "$DOTFILES/task"                  "$USER_CONFIG"               "Linking Taskwarrior config"
link "$DOTFILES/starship/starship.toml" "$USER_CONFIG/starship.toml"     "Linking Starship config"

mkdir -p "$HOME/.tmux/plugins/tpm"
link "$TPM" "$HOME/.tmux/plugins/tpm" "Linking TPM"

if command -v ghostty >/dev/null 2>&1; then
	mkdir -p "$USER_CONFIG/ghostty"
	link "$DOTFILES/ghostty/config" "$USER_CONFIG/ghostty/config" "Linking Ghostty config"
fi

### OS-specific install ###

case "$(uname)" in
	Darwin)
		printHeadline "macOS detected"
		# shellcheck source=packages/macos/install.sh
		source "$DOTFILES/packages/macos/install.sh"
		;;
	Linux)
		printHeadline "Linux detected"
		# shellcheck source=packages/linux/install.sh
		source "$DOTFILES/packages/linux/install.sh"
		;;
	*)
		echo "Unsupported OS, exiting"
		exit 1
		;;
esac

### Goodbye ###

printBold "Thank you, come again!"
