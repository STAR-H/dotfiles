#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
TMUX_CONFIG_DIR="$CONFIG_DIR/tmux"
TMUX_CONF_SYMLINK="$HOME/.tmux.conf"
BACKUP_BASE="$HOME/.config/tmux-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

link_path() {
  local source_path="$1"
  local target_path="$2"
  local backup_path="$3"

  if [ -L "$target_path" ]; then
    if [ "$(readlink "$target_path")" = "$source_path" ]; then
      printf 'skip    %s (already linked)\n' "$target_path"
      return
    fi

    ln -sfn "$source_path" "$target_path"
    printf 'update  %s -> %s\n' "$target_path" "$source_path"
    return
  fi

  if [ -e "$target_path" ]; then
    mkdir -p "$(dirname -- "$backup_path")"
    mv "$target_path" "$backup_path"
    printf 'backup  %s -> %s\n' "$target_path" "$backup_path"
  fi

  ln -s "$source_path" "$target_path"
  printf 'link    %s -> %s\n' "$target_path" "$source_path"
}

remove_legacy_config() {
  local target

  if [ ! -e "$TMUX_CONF_SYMLINK" ] && [ ! -L "$TMUX_CONF_SYMLINK" ]; then
    return
  fi

  if [ -L "$TMUX_CONF_SYMLINK" ]; then
    target="$(readlink "$TMUX_CONF_SYMLINK")"
    if [ "$target" = "$TMUX_CONFIG_DIR/tmux.conf" ] || [ "$target" = "$DOTFILES_DIR/tmux.conf" ]; then
      rm "$TMUX_CONF_SYMLINK"
      printf 'remove  %s (duplicate legacy entry)\n' "$TMUX_CONF_SYMLINK"
      return
    fi
  fi

  mkdir -p "$(dirname -- "$BACKUP_DIR")"
  mv "$TMUX_CONF_SYMLINK" "$BACKUP_DIR/tmux.conf"
  printf 'backup  %s -> %s\n' "$TMUX_CONF_SYMLINK" "$BACKUP_DIR/tmux.conf"
}

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

link_path "$DOTFILES_DIR" "$TMUX_CONFIG_DIR" "$BACKUP_DIR/tmux"
remove_legacy_config

printf 'done    tmux setup complete\n'
