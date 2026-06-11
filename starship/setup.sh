#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$PWD"
CONFIG_DIR="$HOME/.config"
STARSHIP_CONFIG_DIR="$CONFIG_DIR/starship"
BACKUP_BASE="$HOME/.config/starship-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

if [ -L "$STARSHIP_CONFIG_DIR" ]; then
  if [ "$(readlink "$STARSHIP_CONFIG_DIR")" = "$DOTFILES_DIR" ]; then
    printf 'skip    %s (already linked)\n' "$STARSHIP_CONFIG_DIR"
    printf 'done    Starship setup complete\n'
    exit 0
  fi

  ln -sfn "$DOTFILES_DIR" "$STARSHIP_CONFIG_DIR"
  printf 'update  %s -> %s\n' "$STARSHIP_CONFIG_DIR" "$DOTFILES_DIR"
  printf 'done    Starship setup complete\n'
  exit 0
fi

if [ -e "$STARSHIP_CONFIG_DIR" ]; then
  mkdir -p "$(dirname -- "$BACKUP_DIR")"
  mv "$STARSHIP_CONFIG_DIR" "$BACKUP_DIR"
  printf 'backup  %s -> %s\n' "$STARSHIP_CONFIG_DIR" "$BACKUP_DIR"
fi

ln -s "$DOTFILES_DIR" "$STARSHIP_CONFIG_DIR"
printf 'link    %s -> %s\n' "$STARSHIP_CONFIG_DIR" "$DOTFILES_DIR"
printf 'done    Starship setup complete\n'
