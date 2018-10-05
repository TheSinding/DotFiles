#!/bin/sh
# This will install a bunch of things.. 
# For
#		zsh
#		other stuff
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
printf -v line "%.0s-" {1..40}


packmgr='unknown'
function os_type
{
case `uname` in
	Linux )
		echo "Linux distro, checking package manager"
		echo ${line// /}
     		LINUX=1
     		which yum >/dev/null  2>&1 && { echo "CentOS, Fedora, Redhat detected"; packmgr='yum'; return; }     	
 		which zypper >/dev/null 2>&1 && { echo "OpenSuse detected"; packmgr='zypper'; return; }
     		which apt-get >/dev/null 2>&1 && { echo "Debian based detected"; packmgr='apt'; return; }
		which pacman  >/dev/null 2>&1 && { echo "Arch based detected"; packmgr='pacman'; }
		
		which yay  >/dev/null 2>&1 && { echo "Using AUR"; packmgr='yay'; return; }
		return;
     ;;
  	Darwin )
     		DARWIN=1
     ;;
  	* )
    		echo "Unknown OS, not supported by this script";
     ;;
esac
}  
os_type


if [[ $LINUX -ne 1 ]]; then
	echo "Unknown linux";
fi
if [[ "$packmgr" == "unknown" ]]; then 
	echo "Unknown linux distro, exiting";
	exit 1;
fi


function link {
	printf "%-40s" "$3"
	if ln -s $1 $2 2>/dev/null; then
		printf " - ${BOLD} Done${NORMAL}\n"
	else
		printf " - ${BOLD} Link exists${NORMAL}\n"
	fi
}
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
esac

}

function readApplications {
	lines=$(while IFS="" read -r line; do
		echo $(sed 's/#.*//g' <<< ${line}); 
	done < $1)
	echo $lines

}

function installApplications {
	packages=$(readApplications $1)
	installPackage "$packages"
}

USER_ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
USER_ZSH_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
USER_ZSH_THEMES="$HOME/.oh-my-zsh/themes"
USER_ZSH="$HOME/.oh-my-zsh"
USER_CONFIG="$HOME/.config"
ZSH="$PWD/zsh"
TMUX="$PWD/tmux"
TERMITE="$PWD/termite"


if ! hash zsh 2>/dev/null; then
	echo "Installing ZSH"
	installPackage zsh
	echo "Changing shell"
	chsh -s $(which zsh)
	echo "Installing Oh My ZSH"
	git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi



# Check the regular folders
if [ ! -d "$HOME/code" ]; then
	mkdir $HOME/code
fi
if [ ! -d "$HOME/clones" ]; then
	mkdir $HOME/clones
fi


echo -e "\n${line// /-}"
printf "${BOLD}Linking stuff ${NORMAL}\n"
echo ${line// /-}

link "$ZSH/plugins/*" $USER_ZSH_PLUGINS "Linking Plugins"
link $ZSH/themes/bullet-train/bullet-train.zsh-theme $USER_ZSH_THEMES/bullet-train.zsh-theme "Linking Bullet Train Theme"

if [ -f $HOME/.zshrc ]; then
	mv $HOME/.zshrc $HOME/.zshrc.pre-dotfiles
fi

link $ZSH/.zshrc $HOME/.zshrc "Linking .zshrc"
if [ ! -d $HOME/.config/termite ]; then 
	mkdir $HOME/.config/termite -p
fi
link $TERMITE/config $HOME/.config/termite/config "Linking Termite config"

link $TMUX/.tmux.conf $HOME/.tmux.conf "Linking TMUX config"
link $PWD/.Xmodmap $HOME/.Xmodmap "Linking Xmodmap"

echo -e "\n${line// /}"

if [ -f $PWD/applications ]; then
	echo "Install applications from \"applications\"?"
	installApplications $PWD/applications;
fi	
if [ ! -f $HOME/.xinitrc ]; then
       echo "Creating xinitrc"
	touch $HOME/.xinitrc
 	echo "xmodmap ~/.Xmodmap" > ~/.xinitrc
fi


echo -e "\n${line// /}\n${BOLD}Thank you, come again!"
