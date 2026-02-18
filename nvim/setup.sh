#!/bin/bash

# Set paths
DOTFILES_DIR="$PWD"
CONFIG_DIR="$HOME/.config/"

mkdir -p "$CONFIG_DIR"

# Create symlink for the entire folder to ~/.config
ln -s "$DOTFILES_DIR" "$CONFIG_DIR"

echo "configuration folder from '$DOTFILES_DIR' has been successfully symlinked to '$CONFIG_DIR'!"

