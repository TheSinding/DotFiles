#!/bin/sh
# This will install a bunch of things.. 
# For
#		zsh
#		other stuff
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
printf -v line "%.0s-" {1..40}

function printHeadline {
	echo -e "\n\n${line// /-}"
	echo -e "${BOLD}$1${NORMAL}"
	echo -e "${line// /-}"
}

function printLine {
	echo -e "\n\n${line// /-}"
}

function printBold {
	echo -e "${BOLD}$1${NORMAL}"
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



######## Pull Git submodules ###########
printHeadline "Pulling submodules!"
git submodule update --init

echo -e "${BOLD}Done${NORMAL}"
########################################


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
			echo -e "\n${BOLD}Adding colors to Pacman${NORMAL}"
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
	printf "%-40s" "$3"
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
	installPackage "$packages"
}
ENV_FILE="/etc/environment"
USER_ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
USER_ZSH_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
USER_ZSH_THEMES="$HOME/.oh-my-zsh/themes"
OH_MY_ZSH="$HOME/.oh-my-zsh"
USER_CONFIG="$HOME/.config"
ZSH="$PWD/zsh"
TMUX="$PWD/tmux"
TMUXREPO="$TMUX/tmux_gpakosz"
TPM="$TMUX/tpm"
MISC="$PWD/misc"
TERMITE="$PWD/termite"
echo $TMUXREPO

###### Install ZSH and OH MY ZSH!!! #########

if ! hash zsh 2>/dev/null; then
	printBold "Installing ZSH"
	installPackage zsh
	printBold "Changing shell"
	chsh -s $(which zsh)
fi
if [ ! -d "$OH_MY_ZSH" ]; then
	printBold "Installing Oh My ZSH"
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

# Check the regular folders
if [ ! -d "$HOME/code" ]; then
	mkdir $HOME/code
fi
if [ ! -d "$HOME/clones" ]; then
	mkdir $HOME/clones
fi


############## Linking Stuff! ##############

printHeadline "Linking stuff!"

link "$ZSH/plugins/*" $USER_ZSH_PLUGINS "Linking Plugins"
link $ZSH/themes/bullet-train/bullet-train.zsh-theme $USER_ZSH_THEMES/bullet-train.zsh-theme "Linking Bullet Train Theme"

if [ -f $HOME/.zshrc ]; then
	if [ ! -f $HOME/.zshrc.pre-dotfiles ]; then
		mv $HOME/.zshrc $HOME/.zshrc.pre-dotfiles
	fi
fi

link $ZSH/.zshrc $HOME/.zshrc "Linking .zshrc"
if [ ! -d $HOME/.config/termite ]; then 
	mkdir $HOME/.config/termite -p
fi

# Termite Color switcher
TERMITE_CSW="termite-color-switcher"
TERMITE_CSW_PATH="$MISC/$TERMITE_CSW"

# This is because of the termite color switcher
link $TERMITE/theme $HOME/.config/termite/theme "Linking Termite Theme file"
link $TERMITE/color $HOME/.config/termite "Linking Termite color files"
link $TERMITE/option $HOME/.config/termite "Linking Termite options file"
if [ ! -d $HOME/bin ]; then
	mkdir $HOME/bin
fi
link $TERMITE_CSW_PATH/bin/color $HOME/bin/color "Linking Termite Color bin"

# Without Termite color switcher
# link $TERMITE/config $HOME/.config/termite/config "Linking Termite config"

link $TMUXREPO/.tmux.conf $HOME/.tmux.conf "Linking TMUX config"
link "$TMUX/.tmux.conf.local" "$HOME/.tmux.conf.local" "Linking local TMUX config"

## Link TPM
if [ ! -d $HOME/.tmux/plugins/tpm ]; then
	mkdir $HOME/.tmux/plugins/tpm -p
fi
link "$TPM/*" $HOME/.tmux/plugins/tpm "Linking TPM"
## 

link $PWD/.Xmodmap $HOME/.Xmodmap "Linking Xmodmap"



### Install applications from ./applications file ###

if [ -f $PWD/applications ]; then
	printHeadline "${BOLD}Installing applications from \"applications\"${NORMAL}"
	installApplications $PWD/applications;
fi	
if [ ! -f $HOME/.xinitrc ]; then
       	printBold "Creating xinitrc"
	touch $HOME/.xinitrc
 	echo "xmodmap ~/.Xmodmap" > ~/.xinitrc
fi

# Docker related stuff
if [ hash docker 2>/dev/null ]; then
	printHeadline "Docker stuff"
	printBold "Enabling and starting docker"
	sudo systemctl enable docker
	printBold "Adding user to docker group"
	sudo usermod -aG docker $USER
	printBold "Done, remember to log out"
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
	echo -e "# Added by Dotfiles install script\nDOTFILES=\"$PWD\"" | sudo tee -a $ENV_FILE
fi


### Goodbye ###
printBold "\n\n\nNOTE: To get zsh working, log in and out"
echo -e "\n${line// /}\n${BOLD}Thank you, come again!"
