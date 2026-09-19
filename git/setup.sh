#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
GIT_CONFIG_DIR="$CONFIG_DIR/git"
GITCONFIG_INCLUDE="~/.config/git/gitconfig"
BACKUP_BASE="$HOME/.config/git-backups"
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

if ! command -v git >/dev/null 2>&1; then
  printf 'error   git command not found\n' >&2
  exit 1
fi

printf 'check   %s\n' "$(git --version)"

if command -v delta >/dev/null 2>&1; then
  printf 'check   git-delta %s\n' "$(delta --version 2>/dev/null | sed -n '1p')"
else
  printf 'warn    git-delta command not found (delta)\n'
fi

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

link_path "$DOTFILES_DIR" "$GIT_CONFIG_DIR" "$BACKUP_DIR/git"

if git config --global --get-all include.path 2>/dev/null | grep -Fx "$GITCONFIG_INCLUDE" >/dev/null; then
  printf 'skip    ~/.gitconfig include.path %s\n' "$GITCONFIG_INCLUDE"
else
  git config --global --add include.path "$GITCONFIG_INCLUDE"
  printf 'append  ~/.gitconfig include.path %s\n' "$GITCONFIG_INCLUDE"
fi

printf 'done    git setup complete\n'
