#!/bin/bash

# Set paths
DOTFILES_DIR="$PWD"  # Use the current directory (PWD) and append 'tmux' folder
TMUX_CONFIG_DIR="$HOME/.config/"
TMUX_CONF_FILE="$TMUX_CONFIG_DIR/tmux/tmux.conf"
TMUX_CONF_SYMLINK="$HOME/.tmux.conf"

# Create ~/.config/tmux directory if it doesn't exist
mkdir -p "$TMUX_CONFIG_DIR"

# Create symlink for the entire tmux folder to ~/.config
ln -s "$DOTFILES_DIR" "$TMUX_CONFIG_DIR"

# Create symlink for tmux.conf
ln -s "$TMUX_CONF_FILE" "$TMUX_CONF_SYMLINK"

echo "tmux configuration folder from '$DOTFILES_DIR' has been successfully symlinked to '$TMUX_CONFIG_DIR'!"
