#!/bin/sh
# This will install a bunch of things.. 
# For
#		zsh
#		other stuff
echo "Simon Sinding - Github.com/TheSinding"                                                                                                                                               
echo "Script installer v1.0 - 2016"
echo "-------------------------------------"
echo "Installing stuff"
sleep 2

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
ZSH_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"
ZSH_THEMES="$HOME/.oh-my-zsh/themes"
ZSH="$HOME/.oh-my-zsh"


# Check the regular folders
if [ ! -d "$HOME/code" ]; then
				echo "Creating code folder"
				mkdir $HOME/code
fi
if [ ! -d "$HOME/clones" ]; then
				echo "Creating clones folder"
				mkdir $HOME/clones
fi

# ZSH PLUGINS
if [ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]; then
	echo "Installing ZSH autosuggestions"
	git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS/zsh-autosuggestions
fi
if [ ! -d "$ZSH_PLUGINS/alias-tips" ]; then
	echo "Installing ZSH alias-tips"
	git clone https://github.com/djui/alias-tips.git $ZSH_PLUGINS/alias-tips
fi
if [ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting-filetypes" ]; then
	echo "Installing ZSH Highlighting"
	git clone https://github.com/trapd00r/zsh-syntax-highlighting-filetypes $ZSH_PLUGINS/zsh-syntax-highlighting-filetypes/
fi
if [ ! -d "$ZSH_PLUGINS/mylocation" ]; then
	echo "Installing ZSH Mylocation"
	git clone git@github.com:KasperChristensen/mylocation.git $ZSH_PLUGINS/mylocation/
fi

# ZSH THEMES
if [ ! -d "$ZSH_THEMES/pure" ]; then
	echo "Installing ZSH Pure"
	git clone https://github.com/sindresorhus/pure.git $ZSH_THEMES/pure
fi
if [ ! -d "$ZSH_THEMES/bullet-train" ]; then
	echo "Installing ZSH bullet-train"
	git clone git@github.com:TheSinding/bullet-train-oh-my-zsh-theme.git $ZSH_THEMES/bullet-train
fi



# ZSH Sourcing
HIGHLIGHTING_SOURCE="source $ZSH_PLUGINS/zsh-syntax-highlighting-filetypes/zsh-syntax-highlighting-filetypes.zsh"
# Check if the source line is already the last line in the .zshrc else put it there
if [ -f "$HOME/.zshrc" ]; then
				CHECK=$(awk '/./{line=$0} END{print line}' $HOME/.zshrc)
				if [ "$CHECK" != "$HIGHLIGHTING_SOURCE" ]; then
							echo $HIGHLIGHTING_SOURCE >> $HOME/.zshrc	
				fi
fi

# Git clone for code
if [ ! -d "$HOME/code/Klibbert" ]; then
	echo "Cloning Klibbert"
	git clone git@github.com:TheSinding/Klibbert.git $HOME/code/Klibbert
fi
if [ ! -d "$HOME/code/Concore" ]; then
	echo "Cloning Concore"
	git clone git@github.com:TheSinding/Concore.git	$HOME/code/Concore
fi
if [ ! -d "$HOME/code/SDU" ]; then
	echo "Cloning SDU"
	git clone git@github.com:TheSinding/SDU.git			$HOME/code/SDU
fi




if [ -f "$HOME/code/Klibbert/install.sh" ]; then
				if ! type klibbert > /dev/null; then
					echo "Installing klibbert"
					su -c "/bin/bash $HOME/code/Klibbert/install.sh" root
	fi
fi

echo "Done - Thanks, come again!"
