export PATH=$HOME/Workspace/Softwares/nvim-macos-arm64/bin:$PATH

# Install coreutils to get GNU versions of standard utilities
# (macOS ships BSD variants with different behavior).
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/libtool/libexec/gnubin:$PATH"

# zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-completions
if type brew &>/dev/null; then
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

autoload -Uz compinit
compinit
fi

# disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

