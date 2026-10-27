#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
KITTY_CONFIG_DIR="$CONFIG_DIR/kitty"
BACKUP_BASE="$CONFIG_DIR/kitty-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

check_required_files() {
  local missing=0
  local item

  for item in kitty.conf current-theme.conf bg_fengling.webp; do
    if [ -f "$DOTFILES_DIR/$item" ]; then
      printf 'check   %s\n' "$DOTFILES_DIR/$item"
    else
      printf 'error   missing Kitty asset: %s\n' "$DOTFILES_DIR/$item" >&2
      missing=1
    fi
  done

  if [ "$missing" -ne 0 ]; then
    exit 1
  fi
}

check_font() {
  local font_family="HackNerdFont"

  if command -v fc-match >/dev/null 2>&1; then
    if fc-match "$font_family" >/dev/null 2>&1; then
      printf 'check   font %s\n' "$font_family"
    else
      printf 'warn    font %s not found; install it before using Kitty\n' "$font_family"
    fi
  else
    printf 'skip    font check (fc-match not found; common on macOS)\n'
  fi
}

if ! command -v kitty >/dev/null 2>&1; then
  printf 'error   kitty command not found\n' >&2
  printf 'hint    install Kitty first: https://sw.kovidgoyal.net/kitty/binary/\n' >&2
  exit 1
fi

printf 'check   %s\n' "$(kitty --version)"
check_required_files
check_font

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

if [ -L "$KITTY_CONFIG_DIR" ]; then
  if [ "$(readlink "$KITTY_CONFIG_DIR")" = "$DOTFILES_DIR" ]; then
    printf 'skip    %s (already linked)\n' "$KITTY_CONFIG_DIR"
    printf 'done    Kitty setup complete\n'
    exit 0
  fi

  ln -sfn "$DOTFILES_DIR" "$KITTY_CONFIG_DIR"
  printf 'update  %s -> %s\n' "$KITTY_CONFIG_DIR" "$DOTFILES_DIR"
  printf 'done    Kitty setup complete\n'
  exit 0
fi

if [ -e "$KITTY_CONFIG_DIR" ]; then
  mkdir -p "$(dirname -- "$BACKUP_DIR")"
  mv "$KITTY_CONFIG_DIR" "$BACKUP_DIR"
  printf 'backup  %s -> %s\n' "$KITTY_CONFIG_DIR" "$BACKUP_DIR"
fi

ln -s "$DOTFILES_DIR" "$KITTY_CONFIG_DIR"
printf 'link    %s -> %s\n' "$KITTY_CONFIG_DIR" "$DOTFILES_DIR"
printf 'done    Kitty setup complete\n'
