#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/opencode"
BACKUP_BASE="$HOME/.config/opencode-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

link_item() {
  local item="$1"
  local source_path="$SOURCE_DIR/$item"
  local target_path="$CONFIG_DIR/$item"

  if [ ! -e "$source_path" ]; then
    printf 'skip    %s (missing in dotfiles)\n' "$item"
    return
  fi

  if [ -L "$target_path" ]; then
    if [ "$(readlink "$target_path")" = "$source_path" ]; then
      printf 'skip    %s (already linked)\n' "$item"
      return
    fi

    ln -sfn "$source_path" "$target_path"
    printf 'update  %s -> %s\n' "$target_path" "$source_path"
    return
  fi

  if [ -e "$target_path" ]; then
    local backup_path="$BACKUP_DIR/$item"
    mkdir -p "$(dirname -- "$backup_path")"
    mv "$target_path" "$backup_path"
    printf 'backup  %s -> %s\n' "$target_path" "$backup_path"
  fi

  ln -s "$source_path" "$target_path"
  printf 'link    %s -> %s\n' "$target_path" "$source_path"
}

if [ -L "$CONFIG_DIR" ] || { [ -e "$CONFIG_DIR" ] && [ ! -d "$CONFIG_DIR" ]; }; then
  root_backup="$BACKUP_DIR/_root"
  mkdir -p "$(dirname -- "$root_backup")"
  mv "$CONFIG_DIR" "$root_backup"
  printf 'backup  %s -> %s\n' "$CONFIG_DIR" "$root_backup"
fi

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

link_item opencode.json
link_item tui.json
link_item AGENTS.md
link_item agents
link_item commands
link_item skills
link_item caveman-plugin
link_item themes

printf 'done    OpenCode setup complete\n'

# This installer does not touch OpenCode auth state.
