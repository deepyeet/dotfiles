bindkey -v
export KEYTIMEOUT=1

# Vi mode cursor shape changes
# Block cursor for command mode, beam cursor for insert mode
function zle-keymap-select zle-line-init {
   case $KEYMAP in
      vicmd)      echo -ne '\e[1 q' ;;  # Block cursor
      viins|main) echo -ne '\e[5 q' ;;  # Beam cursor
   esac
   zle reset-prompt
   zle -R
}
zle -N zle-keymap-select
zle -N zle-line-init

# Ensure that the prompt is redrawn when the terminal size changes.
# Apparently ZSH knows about TRAPWINCH. Total black magic.
TRAPWINCH() {
  zle && zle -R
}

zmodload zsh/terminfo # Gives us $terminfo for things like $terminfo[kcuu1]

# Keybindings
# menuselect requires completion to be loaded first
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M viins "^A" _next_tags
bindkey -M viins "^P" up-line-or-history
bindkey -M viins "^N" down-line-or-history

bindkey -rM viins '^X' # Unbind self-insert to allow the other ^X binds to work

# unbind clear screen because it sucks
bindkey -rM viins '^L'
bindkey -rM vicmd '^L'

function vi_mode_prompt_info() {
   echo "${${${KEYMAP/vicmd/$1}/(main|viins)/$2}:-$2}"
}
