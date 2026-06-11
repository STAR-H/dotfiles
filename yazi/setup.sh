#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$PWD"
CONFIG_DIR="$HOME/.config"
YAZI_CONFIG_DIR="$CONFIG_DIR/yazi"
BACKUP_BASE="$HOME/.config/yazi-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"
REQUIRED_YAZI_VERSION="26.1.22"

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

if ! command -v yazi >/dev/null 2>&1; then
  printf 'error   yazi command not found\n' >&2
  exit 1
fi

YAZI_VERSION_OUTPUT="$(yazi --version)"
YAZI_VERSION="$(printf '%s\n' "$YAZI_VERSION_OUTPUT" | sed -n 's/^Yazi \([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/p')"

if [ -z "$YAZI_VERSION" ]; then
  printf 'error   unable to parse yazi version: %s\n' "$YAZI_VERSION_OUTPUT" >&2
  exit 1
fi

if ! version_ge "$YAZI_VERSION" "$REQUIRED_YAZI_VERSION"; then
  printf 'error   yazi %s is required, found %s\n' "$REQUIRED_YAZI_VERSION" "$YAZI_VERSION" >&2
  exit 1
fi

printf 'check   yazi %s >= %s\n' "$YAZI_VERSION" "$REQUIRED_YAZI_VERSION"

mkdir -p "$CONFIG_DIR"
printf 'ready   %s\n' "$CONFIG_DIR"

if [ -L "$YAZI_CONFIG_DIR" ]; then
  if [ "$(readlink "$YAZI_CONFIG_DIR")" = "$DOTFILES_DIR" ]; then
    printf 'skip    %s (already linked)\n' "$YAZI_CONFIG_DIR"
    printf 'done    Yazi setup complete\n'
    exit 0
  fi

  ln -sfn "$DOTFILES_DIR" "$YAZI_CONFIG_DIR"
  printf 'update  %s -> %s\n' "$YAZI_CONFIG_DIR" "$DOTFILES_DIR"
  printf 'done    Yazi setup complete\n'
  exit 0
fi

if [ -e "$YAZI_CONFIG_DIR" ]; then
  mkdir -p "$(dirname -- "$BACKUP_DIR")"
  mv "$YAZI_CONFIG_DIR" "$BACKUP_DIR"
  printf 'backup  %s -> %s\n' "$YAZI_CONFIG_DIR" "$BACKUP_DIR"
fi

ln -s "$DOTFILES_DIR" "$YAZI_CONFIG_DIR"
printf 'link    %s -> %s\n' "$YAZI_CONFIG_DIR" "$DOTFILES_DIR"
printf 'done    Yazi setup complete\n'
