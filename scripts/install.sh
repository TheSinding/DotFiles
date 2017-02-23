#!/bin/sh
# This will install a bunch of things.. 
# For
#		zsh
#		other stuff


packmgr='unknown'
function os_type
{
case `uname` in
  Linux )
		 echo "Linux distro, checking package manager"
     LINUX=1
     which yum >/dev/null  2>&1 && { echo "CentOS, Fedora, Redhat detected"; packmgr='yum'; return; }     	
 	   which zypper >/dev/null 2>&1 && { echo "OpenSuse detected"; packmgr='zypper'; return; }
     which apt-get >/dev/null 2>&1 && { echo "Debian based detected"; packmgr='apt'; return; }
		 which pacman  >/dev/null 2>&1 && { echo "Arch based detected"; packmgr='pacman'; return; }
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
if [[ $EUID -ne 0 ]]; then
				echo "Please run this script as root"
				exit 1;
fi

echo "installing ZSH"

case $packmgr in
				pacman)
								$packmgr -S zsh;
								;;
				apt)
								$packmgr update;
								$packmgr install zsh;
								;;
				zypper)
								$packmgr refresh;
								$packmgr in zsh;
								;;
				yum)
								$packmgr update;
								$packmgr install zsh;
								;;
esac

read -p "Enter your linux username:" user

chsh -s $(which zsh) "$user"

protocol="unknown"
which wget >/dev/null 2>1& && { protocol="wget"; }
which curl >/dev/null 2>1& && { protocol="curl"; }
case $protocol in 
				curl)
								echo "Downloading and installing Oh my zsh"
								sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
								dl=1
								;;
				wget)
								echo "Downloading and installing Oh my zsh"
								dl=1
								sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
								;;
				unknown)
								dl=0
								echo "Curl nor Wget is installing, aborting Oh my zsh installation"
								;;
esac

if [[ $dl -eq 1 ]]; then
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
ZSH_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
ZSH_THEMES="$HOME/.oh-my-zsh/custom/themes/"
ZSH="$HOME/.oh-my-zsh"



# Check the regular folders
if [ -d "$HOME/code" ]; then
				mkdir $HOME/code
fi
if [ -d "$HOME/clones" ]; then
				mkdir $HOME/clones
fi

# ZSH PLUGINS
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS/zsh-autosuggestions
git clone https://github.com/djui/alias-tips.git $ZSH_PLUGINS/alias-tips
git clone https://github.com/trapd00r/zsh-syntax-highlighting-filetypes $ZSH_PLUGINS/zsh-syntax-highlighting-filetypes/
git clone git@github.com:KasperChristensen/mylocation.git $ZSH_PLUGINS/mylocation/

# ZSH THEMES
git clone https://github.com/sindresorhus/pure.git $ZSH_THEMES/pure
git clone git@github.com:TheSinding/bullet-train-oh-my-zsh-theme.git $ZSH_THEMES/bullet-train

# ZSH Sourcing
HIGHLIGHTING_SOURCE="source $ZSH_PLUGINS/zsh-syntax-highlighting-filetypes/zsh-syntax-highlighting-filetypes.zsh"
# Check if the source line is already the last line in the .zshrc else put it there
if [ -f "$HOME/.zshrc" ]; then
				CHECK=$(awk '/./{line=$0} END{print line}' $HOME/.zshrc)
				if [ "$CHECK" != "$HIGHLIGHTING_SOURCE" ]; then
							echo $HIGHLIGHTING_SOURCE >> $HOME/.zshrc	
				fi
fi
fi
# Git clone for code
git clone git@github.com:TheSinding/Klibbert.git $HOME/code/Klibbert
git clone git@github.com:TheSinding/Concore.git	$HOME/code/Concore
git clone git@github.com:TheSinding/SDU.git			$HOME/code/SDU

if [ -f "$HOME/code/Klibbert/install.sh" ]; then
				if type klibbert > /dev/null; then
					echo "Installing klibbert"
					su -c "/bin/bash $HOME/code/Klibbert/install.sh" root
	fi
fi
