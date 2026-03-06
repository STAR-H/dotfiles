source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fpath=($ZSH_PLUGINS/zsh-completions $fpath)
autoload -Uz compinit && compinit
