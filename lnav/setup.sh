#!/bin/bash

# Define source and target directories
SOURCE_DIR="$(pwd)"
TARGET_DIR="$HOME/.config/lnav"
TAR_CONFIGS_DIR="$TARGET_DIR/configs/installed"
TAR_FORMATS_DIR="$TARGET_DIR/formats/installed"

SRC_CONFIGS_DIR="$SOURCE_DIR/configs/installed"
SRC_FORMATS_DIR="$SOURCE_DIR/formats/installed"


ln -s "$SRC_CONFIGS_DIR/dracula_custom.json" "$TAR_CONFIGS_DIR/dracula_custom.json"
ln -s "$SRC_CONFIGS_DIR/us-keymap.json" "$TAR_CONFIGS_DIR/us-keymap.json"

ln -s "$SRC_FORMATS_DIR/android-logcat.json" "$TAR_FORMATS_DIR/android-logcat.json"

ln -s "$SOURCE_DIR/config.json" "$TARGET_DIR/config.json"

ls -l "$TARGET_DIR/config.json" \
      "$TAR_FORMATS_DIR/android-logcat.json" \
      "$TAR_CONFIGS_DIR/us-keymap.json" \
      "$TAR_CONFIGS_DIR/dracula_custom.json"

echo "configuration folder from '$SOURCE_DIR' has been successfully symlinked to '$TARGET_DIR'!"
