#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/lnav"
TARGET_CONFIGS_DIR="$TARGET_DIR/configs/installed"
TARGET_FORMATS_DIR="$TARGET_DIR/formats/installed"

SRC_CONFIGS_DIR="$SOURCE_DIR/configs/installed"
SRC_FORMATS_DIR="$SOURCE_DIR/formats/installed"
BACKUP_SUFFIX="$(date +%Y%m%d%H%M%S)"

link_config() {
    local source="$1"
    local target="$2"

    if [[ -e "$target" && ! -L "$target" ]]; then
        mv "$target" "$target.backup.$BACKUP_SUFFIX"
    fi

    ln -sfn "$source" "$target"
}

mkdir -p "$TARGET_CONFIGS_DIR" "$TARGET_FORMATS_DIR"

link_config "$SRC_CONFIGS_DIR/dracula-custom.json" "$TARGET_CONFIGS_DIR/dracula-custom.json"
link_config "$SRC_CONFIGS_DIR/us-keymap.json" "$TARGET_CONFIGS_DIR/us-keymap.json"
link_config "$SRC_FORMATS_DIR/android-logcat.json" "$TARGET_FORMATS_DIR/android-logcat.json"
link_config "$SRC_FORMATS_DIR/export-filters-to.lnav" "$TARGET_FORMATS_DIR/export-filters-to.lnav"
link_config "$SRC_FORMATS_DIR/filter-highlight-in.lnav" "$TARGET_FORMATS_DIR/filter-highlight-in.lnav"
link_config "$SOURCE_DIR/config.json" "$TARGET_DIR/config.json"

ls -l "$TARGET_DIR/config.json" \
      "$TARGET_FORMATS_DIR/android-logcat.json" \
      "$TARGET_FORMATS_DIR/export-filters-to.lnav" \
      "$TARGET_FORMATS_DIR/filter-highlight-in.lnav" \
      "$TARGET_CONFIGS_DIR/us-keymap.json" \
      "$TARGET_CONFIGS_DIR/dracula-custom.json"

echo "configuration folder from '$SOURCE_DIR' has been successfully symlinked to '$TARGET_DIR'!"
