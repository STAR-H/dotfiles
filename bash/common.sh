# alias
alias ls='ls --color=auto'
alias ll='ls -alh --color=auto'
alias cl='clear'
alias gs='git status -s -uno'

# tmux history share
shopt -s histappend
export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export HISTFILESIZE=200000
export PROMPT_COMMAND='history -a; history -n'

#neovim
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  alias vi='nvim'
  alias vif='nvim $(fzf)'
fi

# yazi
if command -v yazi >/dev/null 2>&1; then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  }
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
  export FZF_CTRL_R_OPTS="--reverse"
  eval "$(fzf --bash)"
fi

# starship
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
  eval "$(starship init bash)"
fi
