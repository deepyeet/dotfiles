# Minimal zsh history settings (atuin handles search via Ctrl+R)
# These are still needed for up/down arrow navigation

HISTFILE="$_MY_ZSH/histfile"
HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_space      # ignore commands starting with space
setopt inc_append_history     # append immediately, not on exit
setopt share_history          # share between terminals
