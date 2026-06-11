#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$PWD"
CONFIG_DIR="$HOME/.config"
NVIM_CONFIG_DIR="$CONFIG_DIR/nvim"
BACKUP_BASE="$HOME/.config/nvim-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

if [ -L "$NVIM_CONFIG_DIR" ]; then
  if [ "$(readlink "$NVIM_CONFIG_DIR")" = "$DOTFILES_DIR" ]; then
    printf 'skip    %s (already linked)\n' "$NVIM_CONFIG_DIR"
    printf 'done    Neovim setup complete\n'
    exit 0
  fi

  ln -sfn "$DOTFILES_DIR" "$NVIM_CONFIG_DIR"
  printf 'update  %s -> %s\n' "$NVIM_CONFIG_DIR" "$DOTFILES_DIR"
  printf 'done    Neovim setup complete\n'
  exit 0
fi

if [ -e "$NVIM_CONFIG_DIR" ]; then
  mkdir -p "$(dirname -- "$BACKUP_DIR")"
  mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
  printf 'backup  %s -> %s\n' "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

ln -s "$DOTFILES_DIR" "$NVIM_CONFIG_DIR"
printf 'link    %s -> %s\n' "$NVIM_CONFIG_DIR" "$DOTFILES_DIR"
printf 'done    Neovim setup complete\n'
