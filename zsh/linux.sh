source $HOME/tools/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/tools/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fpath=($HOME/tools/zsh-plugins/zsh-completions $fpath)
autoload -Uz compinit && compinit
