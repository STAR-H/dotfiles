#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$DOTFILES_DIR")"
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
REQUIRED_YAZI_VERSION="26.1.22"

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

version_ge() {
  local current="$1"
  local required="$2"
  local current_major current_minor current_patch
  local required_major required_minor required_patch

  IFS=. read -r current_major current_minor current_patch <<< "$current"
  IFS=. read -r required_major required_minor required_patch <<< "$required"

  if [ "$current_major" -gt "$required_major" ]; then
    return 0
  fi

  if [ "$current_major" -lt "$required_major" ]; then
    return 1
  fi

  if [ "$current_minor" -gt "$required_minor" ]; then
    return 0
  fi

  if [ "$current_minor" -lt "$required_minor" ]; then
    return 1
  fi

  [ "$current_patch" -ge "$required_patch" ]
}

check_tool() {
  local label="$1"
  local command_name="$2"
  local output version
  shift 2

  if command -v "$command_name" >/dev/null 2>&1; then
    output="$("$@" 2>/dev/null | sed -n '1p')"
    version="$(printf '%s\n' "$output" | sed -n 's/^[^0-9]*\([0-9][0-9]*\.[0-9][0-9.]*\).*/\1/p')"
    printf 'check   %s %s\n' "$label" "${version:-$output}"
  else
    printf 'warn    %s command not found\n' "$label"
  fi
}

check_fd() {
  if command -v fd >/dev/null 2>&1; then
    printf 'check   fd %s\n' "$(fd --version 2>/dev/null | sed -n 's/^[^0-9]*\([0-9][0-9]*\.[0-9][0-9.]*\).*/\1/p')"
  elif command -v fdfind >/dev/null 2>&1; then
    printf 'check   fd %s\n' "$(fdfind --version 2>/dev/null | sed -n 's/^[^0-9]*\([0-9][0-9]*\.[0-9][0-9.]*\).*/\1/p')"
  else
    printf 'warn    fd command not found\n'
  fi
}

check_yazi() {
  local version_output version

  if ! command -v yazi >/dev/null 2>&1; then
    printf 'warn    yazi command not found (requires >= %s)\n' "$REQUIRED_YAZI_VERSION"
    return
  fi

  version_output="$(yazi --version 2>/dev/null)"
  version="$(printf '%s\n' "$version_output" | sed -n 's/^Yazi \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p; s/^[[:space:]]*Version:[[:space:]]*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p' | sed -n '1p')"

  if [ -z "$version" ]; then
    printf 'warn    unable to parse yazi version: %s\n' "$version_output"
    return
  fi

  if version_ge "$version" "$REQUIRED_YAZI_VERSION"; then
    printf 'check   yazi %s >= %s\n' "$version" "$REQUIRED_YAZI_VERSION"
  else
    printf 'warn    yazi %s < %s\n' "$version" "$REQUIRED_YAZI_VERSION"
  fi
}

check_external_tools() {
  check_tool starship starship starship --version
  check_tool fzf fzf fzf --version
  check_yazi
  check_tool rg rg rg --version
  check_fd
  check_tool zoxide zoxide zoxide --version
  check_tool nvim nvim nvim --version
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
check_external_tools

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

"$REPO_DIR/starship/setup.sh"

printf 'done    zsh setup complete\n'
