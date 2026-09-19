#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
NVIM_CONFIG_DIR="$CONFIG_DIR/nvim"
BACKUP_BASE="$HOME/.config/nvim-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

check_build_deps() {
  local missing=0

  if command -v cc >/dev/null 2>&1; then
    printf 'check   %s\n' "$(cc --version | sed -n '1p')"
  else
    printf 'error   C compiler not found (install gcc or clang)\n' >&2
    missing=1
  fi

  if command -v make >/dev/null 2>&1; then
    printf 'check   %s\n' "$(make --version | sed -n '1p')"
  else
    printf 'error   make command not found\n' >&2
    missing=1
  fi

  if [ "$missing" -ne 0 ]; then
    printf 'error   install Neovim build dependencies first (Arch: sudo pacman -S base-devel)\n' >&2
    exit 1
  fi
}

check_build_deps

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
