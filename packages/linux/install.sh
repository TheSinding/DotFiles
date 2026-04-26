#!/usr/bin/env bash
# Linux-specific install — sourced from main install.sh
# Assumes: printHeadline, printBold, DOTFILES are available from parent

### Detect package manager ###
# Check release files first (more reliable than command -v)

BACKUP_FOLDER="$PWD/.backups"

packmgr='unknown'

if [ -f /etc/arch-release ]; then
	if command -v paru >/dev/null 2>&1; then
		printBold "Arch Linux + AUR (paru) detected"
		packmgr='paru'
	else
		printBold "Arch Linux (pacman) detected"
		packmgr='pacman'
	fi
elif [ -f /etc/debian_version ]; then
	printBold "Debian/Ubuntu detected"
	packmgr='apt'
elif [ -f /etc/fedora-release ]; then
	printBold "Fedora detected"
	packmgr='yum'
elif [ -f /etc/SUSE-brand ] || [ -f /etc/opensuse-release ]; then
	printBold "OpenSUSE detected"
	packmgr='zypper'
else
	# Fallback: command -v detection
	command -v paru     >/dev/null 2>&1 && packmgr='paru'
	command -v pacman  >/dev/null 2>&1 && [ "$packmgr" = 'unknown' ] && packmgr='pacman'
	command -v apt-get >/dev/null 2>&1 && [ "$packmgr" = 'unknown' ] && packmgr='apt'
	command -v zypper  >/dev/null 2>&1 && [ "$packmgr" = 'unknown' ] && packmgr='zypper'
	command -v yum     >/dev/null 2>&1 && [ "$packmgr" = 'unknown' ] && packmgr='yum'
fi

if [ "$packmgr" = 'unknown' ]; then
	printBold "Could not detect a package manager, exiting"
	exit 1
fi

### Helpers ###

function syncPackageManager {
	case $1 in
		paru)     paru -Sy ;;
		pacman)  sudo pacman -Sy ;;
		apt)     sudo apt-get update ;;
		zypper)  sudo zypper refresh ;;
		yum)     sudo yum update ;;
		flatpak) flatpak update ;;
	esac
}

function installPackages {
	local mgr=$1; shift
	local packages=("$@")
	case $mgr in
		paru)     paru -S --needed "${packages[@]}" ;;
		pacman)  sudo pacman -S --needed "${packages[@]}" ;;
		apt)     sudo apt-get install -y "${packages[@]}" ;;
		zypper)  sudo zypper in "${packages[@]}" ;;
		yum)     sudo yum install -y "${packages[@]}" ;;
		flatpak)
			for pkg in "${packages[@]}"; do
				flatpak install flathub -y "$pkg"
			done ;;
	esac
}

function readPackageFile {
	local file=$1
	local packages=()
	while IFS= read -r line; do
		line=$(echo "$line" | sed 's/#.*//g' | xargs)
		[[ -n "$line" ]] && packages+=("$line")
	done < "$file"
	echo "${packages[@]}"
}

function installFromFile {
	local file=$1
	local mgr=$2
	local packages
	read -ra packages <<< "$(readPackageFile "$file")"
	if [[ ${#packages[@]} -eq 0 ]]; then
		printBold "No packages found in $file"
		return
	fi
	printBold "Packages: ${packages[*]}"
	syncPackageManager "$mgr"
	installPackages "$mgr" "${packages[@]}"
}

### If arch, but no aur, then install Paru
if [ "$packmgr" = 'pacman' ]; then
    installPackages "$packmgr" "paru"
    set packmgr = "paru"
fi


### If faillock exists, then set it to 0, fuck that
FAILLOCK_FILE="/etc/security/faillock.conf"
if [ -f "$FAILLOCK_FILE" ]; then
    echo "Faillock exists, backing up to $BACKUP_FOLDER/faillock.backup.conf"
    cp "$FAILLOCK_FILE" "faillock.backup.conf"
    sed 's/#.*deny.*=.*/deny = 0/g' -i "$FAILLOCK_FAIL";
fi

### Pacman: enable colors ###

if [ "$packmgr" = 'pacman' ] || [ "$packmgr" = 'paru' ]; then
	PACMAN_CONFIG="/etc/pacman.conf"
	if [ -f "$PACMAN_CONFIG" ] && grep -Fq "#Color" "$PACMAN_CONFIG"; then
		printBold "Enabling colors in pacman"
		sudo sed -i 's/#Color/Color/g' "$PACMAN_CONFIG"
	fi
fi

### Ensure ZSH is installed ###

if ! command -v zsh >/dev/null 2>&1; then
	printBold "Installing ZSH"
	syncPackageManager "$packmgr"
	installPackages "$packmgr" zsh
	chsh -s "$(command -v zsh)"
fi

### Flatpak ###

USE_FLATPAK=0
FLATPAK_FILE="$DOTFILES/packages/linux/flatpak"

if command -v flatpak >/dev/null 2>&1; then
	printBold "Flatpak detected"
	USE_FLATPAK=1
elif [ -f "$FLATPAK_FILE" ]; then
	printBold "Flatpak not installed but packages/linux/flatpak exists."
	printf "Install Flatpak? [y/n]: "
	read -r flatpak_choice
	if [[ "$flatpak_choice" =~ ^[Yy] ]]; then
		printBold "Installing Flatpak..."
		syncPackageManager "$packmgr"
		installPackages "$packmgr" flatpak
		USE_FLATPAK=1
	fi
fi

### Native packages ###

NATIVE_FILE="$DOTFILES/packages/linux/$packmgr"
if [ -f "$NATIVE_FILE" ]; then
	printHeadline "Installing packages via $packmgr"
	installFromFile "$NATIVE_FILE" "$packmgr"
else
	printBold "No package file for $packmgr (looked for packages/linux/$packmgr), skipping"
fi

### Flatpak packages ###

if [[ $USE_FLATPAK -eq 1 ]]; then
	if [ -f "$FLATPAK_FILE" ]; then
		printHeadline "Installing Flatpak packages"
		installFromFile "$FLATPAK_FILE" "flatpak"
	else
		printBold "No packages/linux/flatpak file found, skipping"
	fi
fi

### DOTFILES env variable ###

ENV_FILE="/etc/environment"
if grep -Fq "DOTFILES" "$ENV_FILE" 2>/dev/null; then
	DOTFILES_LINE=$(grep -F "DOTFILES" "$ENV_FILE")
	DOTFILES_VALUE=$(echo "$DOTFILES_LINE" | sed 's/.*=//g; s/"//g')
	if [ "$DOTFILES_VALUE" != "$DOTFILES" ]; then
		printBold "Fixing DOTFILES env variable"
		OLD_PATH=$(echo "$DOTFILES_VALUE" | sed 's_/_\\/_g')
		NEW_PATH=$(echo "$DOTFILES" | sed 's_/_\\/_g')
		sudo sed -i "s/$OLD_PATH/$NEW_PATH/g" "$ENV_FILE"
	fi
else
	printBold "Adding DOTFILES env variable"
	printf "# Added by Dotfiles install script\nDOTFILES=\"%s\"\n" "$DOTFILES" | sudo tee -a "$ENV_FILE"
fi
