
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# fix clangd can not find header
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export PATH=$PATH:~/Software/fzf/bin
# disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1
