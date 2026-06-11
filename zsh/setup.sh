#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$PWD"
CONFIG_DIR="$HOME/.config"
ZSH_CONFIG_DIR="$CONFIG_DIR/zsh"
ZSHRC_SOURCE="$ZSH_CONFIG_DIR/zshrc"
ZSHRC_TARGET="$HOME/.zshrc"
PLUGIN_ARCHIVE="$DOTFILES_DIR/zsh-plugins.tar.gz"
PLUGIN_DIR="$DOTFILES_DIR/zsh-plugins"
LOCAL_ENV_FILE="$HOME/.local.sh"
BACKUP_BASE="$HOME/.config/zsh-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

case "$(uname -s)" in
  Darwin) PLATFORM=macos ;;
  Linux) PLATFORM=linux ;;
  *) PLATFORM=unknown ;;
esac

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

setup_linux_plugins() {
  if [ ! -f "$PLUGIN_ARCHIVE" ]; then
    printf 'error   %s (missing plugin archive)\n' "$PLUGIN_ARCHIVE" >&2
    exit 1
  fi

  if [ -d "$PLUGIN_DIR" ]; then
    printf 'skip    %s (already extracted)\n' "$PLUGIN_DIR"
  else
    printf 'unzip   %s\n' "$PLUGIN_ARCHIVE"
    tar -xzf "$PLUGIN_ARCHIVE" -C "$DOTFILES_DIR"
    printf 'extract %s -> %s\n' "$PLUGIN_ARCHIVE" "$PLUGIN_DIR"
  fi

  if [ -e "$LOCAL_ENV_FILE" ] || [ -L "$LOCAL_ENV_FILE" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$LOCAL_ENV_FILE" "$BACKUP_DIR/local.sh"
    printf 'backup  %s -> %s\n' "$LOCAL_ENV_FILE" "$BACKUP_DIR/local.sh"
  fi

  printf 'export ZSH_PLUGINS="%s"\n' "$ZSH_CONFIG_DIR/zsh-plugins" > "$LOCAL_ENV_FILE"
  printf 'write   %s (ZSH_PLUGINS)\n' "$LOCAL_ENV_FILE"
}

if ! command -v zsh >/dev/null 2>&1; then
  printf 'error   zsh command not found\n' >&2
  exit 1
fi

printf 'check   %s\n' "$(zsh --version)"

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

link_path "$DOTFILES_DIR" "$ZSH_CONFIG_DIR" "$BACKUP_DIR/zsh"
link_path "$ZSHRC_SOURCE" "$ZSHRC_TARGET" "$BACKUP_DIR/zshrc"

if [ "$PLATFORM" = linux ]; then
  setup_linux_plugins
else
  printf 'skip    zsh plugins (not required on %s)\n' "$PLATFORM"
  printf 'skip    ZSH_PLUGINS (not required on %s)\n' "$PLATFORM"
fi

printf 'done    zsh setup complete\n'
