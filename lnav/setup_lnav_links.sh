#!/bin/bash

# Define source and target directories
SOURCE_DIR="$(pwd)"
TARGET_DIR="$HOME/.config/lnav"
CONFIGS_DIR="$TARGET_DIR/configs"
FORMATS_DIR="$TARGET_DIR/formats"

# 1. Check if ~/.config/lnav/ exists, exit if not
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: $TARGET_DIR does not exist. Exiting."
    exit 1
fi

# Function to backup and symlink a file
backup_and_symlink_file() {
    local source_file="$1"
    local target_file="$2"

    if [[ -e "$target_file" ]]; then
        echo "Backing up existing $target_file to ${target_file}.bak"
        mv "$target_file" "${target_file}.bak"
    fi

    echo "Creating symlink from $source_file to $target_file"
    ln -s "$source_file" "$target_file"
}

# Function to backup and symlink a directory
backup_and_symlink_dir() {
    local source_dir="$1"
    local target_dir="$2"

    if [[ -d "$target_dir" && "$(ls -A "$target_dir")" ]]; then
        echo "Backing up existing $target_dir to ${target_dir}_bak"
        mv "$target_dir" "${target_dir}_bak"
    fi

    echo "Creating symlink from $source_dir to $target_dir"
    ln -s "$source_dir" "$(dirname "$target_dir")"
}

# 2. Handle config.json
backup_and_symlink_file "$SOURCE_DIR/config.json" "$TARGET_DIR/config.json"


# 3. Handle configs/installed
backup_and_symlink_dir "$SOURCE_DIR/configs/installed" "$CONFIGS_DIR/installed"

# 4. Handle formats/installed
backup_and_symlink_dir "$SOURCE_DIR/formats/installed" "$FORMATS_DIR/installed"

echo "Done!"
