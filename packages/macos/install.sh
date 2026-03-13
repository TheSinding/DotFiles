#!/usr/bin/env bash
# macOS-specific install — sourced from main install.sh
# Assumes: printHeadline, printBold, DOTFILES are available from parent

### Homebrew ###

# Detect prefix: Apple Silicon vs Intel
if [ "$(uname -m)" = "arm64" ]; then
	HOMEBREW_PREFIX="/opt/homebrew"
else
	HOMEBREW_PREFIX="/usr/local"
fi

if ! command -v brew >/dev/null 2>&1; then
	printBold "Homebrew not found, installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
fi

### Install packages via Brewfile ###

BREWFILE="$DOTFILES/packages/macos/Brewfile"
if [ -f "$BREWFILE" ]; then
	printHeadline "Installing packages from Brewfile"
	brew bundle install --file="$BREWFILE"
else
	printBold "No Brewfile found at packages/macos/Brewfile, skipping"
fi
