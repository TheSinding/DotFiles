#!/bin/sh
# This will install a bunch of things.. 
# For
#		zsh
#		other stuff
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
printf -v line "%.0s-" {1..40}

function printHeadline {
	echo "\n\n${line// /-}"
	echo "${BOLD}$1${NORMAL}"
	echo "${line// /-}"
}

function printLine {
	echo "\n\n${line// /-}"
}

function printBold {
	echo "${BOLD}$1${NORMAL}"
}

if [ ! -d ".git" ]; then
	printBold "No git repository found!";	
	printBold "For this installer script to work, you need to clone the repository";
	printBold "If you dont clone the repo, you need to install all the files manually";
	printBold "Exiting";
	exit 0;
fi

printBold "WELCOME TO TIMMY THE TINY INSTALLER, HAVE A NICE STAY! <3"

# Print a nice ready set bake sequence
printf "Ready"
sleep 1
printf " Set"
sleep 0.2500 
for (( i=0; i <= 4; i++ )); do
	sleep 0.250
	printf "."
done
printf " ${BOLD}BAKE!${NORMAL}\n"
sleep 1

packmgr='unknown'
function os_type
{
case `uname` in
	Linux )
		printHeadline "This is a Linux distro, checking package manager, you sexy thaaaing <3"
    		LINUX=1
     		which yum >/dev/null  2>&1 && { echo "CentOS, Fedora, Redhat detected"; packmgr='yum'; return; }     	
 		which zypper >/dev/null 2>&1 && { echo "OpenSuse detected"; packmgr='zypper'; return; }
     		which apt-get >/dev/null 2>&1 && { echo "Debian based detected"; packmgr='apt'; return; }
		which pacman  >/dev/null 2>&1 && { echo "Arch based detected"; packmgr='pacman'; }
		
		which yay  >/dev/null 2>&1 && { echo "Using AUR"; packmgr='yay'; return; }
		return;
     ;;
  	Darwin )
		printHeadline "Uhhh, this is a mac huh?!"
     		DARWIN=1
		which brew  >/dev/null 2>&1 && { echo "Using Brew"; packmgr='brew'; return; }
		return;
     ;;
  	* )
    		echo "Unknown OS, not supported by this script";
     ;;
esac
}  
os_type
PACMAN_CONFIG="/etc/pacman.conf"
##### Add colors to pacman output ######
if [ "$packmgr" == "pacman" ] || [ "$packmgr" == "yay" ]; then
	if [ -f $PACMAN_CONFIG ]; then
		if grep -Fq "#Color" $PACMAN_CONFIG; then
			echo "\n${BOLD}Adding colors to Pacman${NORMAL}"
			sudo sed -i 's/#Color/Color/g' $PACMAN_CONFIG
		fi
	fi
fi
#######################################

################ Flooff ######################
if [[ $LINUX -ne 1 ]] || [[ $DARWIN ]]; then
	echo "Unknown operating system";
fi

if [[ "$packmgr" == "unknown" ]]; then 
	echo "Unknown linux distro, exiting";
	exit 1;
fi
###############################################

######### Link function ############

function link {
	printf "%-40s" "$1 -> $2: $3"
	if ln -s -f $1 $2 2>/dev/null; then
		printf " - ${BOLD} Done${NORMAL}\n"
	else
		printf " - ${BOLD} Link exists${NORMAL}\n"
	fi
}



# Installer function using system package manger #

function installPackage {
case $packmgr in
	yay)
		$packmgr -Sy;
		$packmgr -S $1 --needed;
	;;
	pacman)
		sudo $packmgr -Sy;
		sudo $packmgr -S $1 --needed;
	;;
	apt)
		sudo $packmgr update;
		sudo $packmgr install $1;
	;;
	zypper)
		sudo $packmgr refresh;
		sudo $packmgr in $1;
	;;
	yum)
		sudo $packmgr update;
		sudo $packmgr install $1;
	;;
	brew)
		brew install $1;
	;;
esac

}

## Read a file into one line ##

function readFileToLine {
	lines=$(while IFS="" read -r line; do
		echo $(sed 's/#.*//g' <<< ${line}); 
	done < $1)
	echo $lines

}

#### Install the apps listed in a file #### 

function installApplications {
	packages=$(readFileToLine $1)
	echo "$packages"
	installPackage "$packages"
}
ENV_FILE="/etc/environment"
USER_CONFIG="$HOME/.config"
ZSH="$PWD/zsh"
TMUX="$PWD/tmux"
TMUXREPO="$TMUX/tmux_gpakosz"
TPM="$TMUX/tpm"
MISC="$PWD/misc"
echo $TMUXREPO

if ! hash zsh 2>/dev/null; then
	printBold "Installing ZSH"
	installPackage zsh
	printBold "Changing shell"
	chsh -s $(which zsh)
fi

# Check the regular folders
if [ ! -d "$HOME/code" ]; then
	mkdir $HOME/code
fi
if [ ! -d "$HOME/clones" ]; then
	mkdir $HOME/clones
fi

if [ ! -d "$USER_CONFIG" ]; then
	mkdir $USER_CONFIG
fi


############## Linking Stuff! ##############

printHeadline "Linking stuff!"

if [ -f $HOME/.zshrc ]; then
	if [ ! -f $HOME/.zshrc.pre-dotfiles ]; then
		mv $HOME/.zshrc $HOME/.zshrc.pre-dotfiles
	fi
fi

link $ZSH/.zshrc $HOME/.zshrc "Linking .zshrc"
if [ ! -d $HOME/.config/termite ]; then 
	mkdir $HOME/.config/termite -p
fi

link $TMUXREPO/.tmux.conf $HOME/.tmux.conf "Linking TMUX config"
link "$TMUX/.tmux.conf.local" "$HOME/.tmux.conf.local" "Linking local TMUX config"

## Link TPM
if [ ! -d $HOME/.tmux/plugins/tpm ]; then
	mkdir $HOME/.tmux/plugins/tpm -p
fi
link "$TPM/*" $HOME/.tmux/plugins/tpm "Linking TPM"
## 

link "$PWD/nvim" "$USER_CONFIG/nvim" "Linking NVIM Config"

### Install applications from ./applications file ###

if [ -f $PWD/applications ]; then
	printHeadline "${BOLD}Installing applications from \"applications\"${NORMAL}"
	installApplications $PWD/applications;
fi	

# Adding dotfiles location to the enviroments variables

DOTFILES_NAME="DOTFILES"
if grep -Fq "$DOTFILES_NAME" $ENV_FILE; then
	DOTFILES_LINE=$(grep -F "$DOTFILES_NAME" $ENV_FILE) 
	DOTFILES_VALUE=$(sed 's/.*=//g; s/"//g' <<< $DOTFILES_LINE)
	if [ ! "$DOTFILES_VALUE" == "$PWD" ]; then
		printBold "Fixing wrong dotfiles env variable location!"
		# SED doesn't like the / of a path, so we need to add \/ 
		OLD_PATH=$(echo $DOTFILES_VALUE | sed 's_/_\\/_g')
		NEW_PATH=$(echo $PWD | sed 's_/_\\/_g')
		sudo sed -i "s/$OLD_PATH/$NEW_PATH/g" "$ENV_FILE"
		exit 0
	fi
else 
	printBold "Adding dotfiles env variable"
	echo "# Added by Dotfiles install script\nDOTFILES=\"$PWD\"" | sudo tee -a $ENV_FILE
fi


### Goodbye ###
echo "\n${line// /}\n${BOLD}Thank you, come again!"
