#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/bin"
TMP_DIR="$(mktemp -d)"

mkdir -p "$BIN_DIR"

OS="$(uname -s)"
ARCH="$(uname -m)"


# Supported platforms:
#   - macOS arm64 (Apple Silicon)
#   - Linux x86_64
if [[ "$OS" == "Darwin" && "$ARCH" == "arm64" ]]; then
  PLATFORM="macos-arm64"

elif [[ "$OS" == "Linux" && "$ARCH" == "x86_64" ]]; then
  PLATFORM="linux-x86_64"

else
  echo "Unsupported platform: OS=$OS ARCH=$ARCH"
  exit 1
fi

log() {
  printf "\033[36m[install]\033[0m %s\n" "$1"
}

download() {
  local url="$1"
  local out="$2"
  curl -L --fail --progress-bar "$url" -o "$out"
}

install_bin() {
  local src="$1"
  local name="$2"
  chmod +x "$src"
  mv "$src" "$BIN_DIR/$name"
  log "installed $name"
}

#######################################
# neovim
#######################################
log "install neovim v0.10.4"
cd "$TMP_DIR"

if [[ "$PLATFORM" == "macos-arm64" ]]; then
  NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-macos-arm64.tar.gz"
elif [[ "$PLATFORM" == "linux-x86_64" ]]; then
  NVIM_URL="https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz"
fi

download "$NVIM_URL" nvim.tar.gz
tar xf nvim.tar.gz
install_bin nvim-*/bin/nvim nvim

#######################################
# ripgrep
#######################################
log "install ripgrep 15.1.0"

if [[ "$PLATFORM" == "macos-arm64" ]]; then
  RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-aarch64-apple-darwin.tar.gz"
elif [[ "$PLATFORM" == "linux-x86_64" ]]; then
  RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz"
fi

download "$RG_URL" rg.tar.gz
tar xf rg.tar.gz
install_bin ripgrep-*/rg rg

#######################################
# fzf
#######################################
log "install fzf v0.67.0"

if [[ "$PLATFORM" == "macos-arm64" ]]; then
  FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-darwin_arm64.tar.gz"
elif [[ "$PLATFORM" == "linux-x86_64" ]]; then
  FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-linux_amd64.tar.gz"
fi

download "$FZF_URL" fzf.tar.gz
tar xf fzf.tar.gz
install_bin fzf fzf

#######################################
# yazi
#######################################
log "install yazi v26.1.22"

if [[ "$PLATFORM" == "macos-arm64" ]]; then
  YAZI_URL="https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-apple-darwin.zip"
elif [[ "$PLATFORM" == "linux-x86_64" ]]; then
  YAZI_URL="https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-musl.zip"
fi

download "$YAZI_URL" yazi.zip
unzip -q yazi.zip
install_bin yazi*/yazi yazi

#######################################
# starship
#######################################
log "install starship v1.24.2"

if [[ "$PLATFORM" == "macos-arm64" ]]; then
  STARSHIP_URL="https://github.com/starship/starship/releases/download/v1.24.2/starship-aarch64-apple-darwin.tar.gz"
elif [[ "$PLATFORM" == "linux-x86_64" ]]; then
  STARSHIP_URL="https://github.com/starship/starship/releases/download/v1.24.2/starship-x86_64-unknown-linux-musl.tar.gz"
fi
download "$STARSHIP_URL" starship.tar.gz
tar xf starship.tar.gz
install_bin starship starship

#######################################
# cleanup
#######################################
rm -rf "$TMP_DIR"

log "all tools installed to $BIN_DIR"

