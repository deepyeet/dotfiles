export HISTFILE="$_YIYANG_ZSH/histfile"
export HISTSIZE=16384
export SAVEHIST=16384

# Mostly stolen from zsh history.zsh lib
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# kill 'r' builtin, this wow seriously
disable r

freeze_history () {
   if [[ -z "$HISTFILE" ]]; then
      echo "History is already frozen" >&2
   else
      fc -A
      # read the history back in otherwise we don't have history!
      fc -p "$HISTFILE"
      # don't write anything
      unset HISTFILE
   fi
}

unfreeze_history () {
   # restore the original history
   fc -P
}

alias fh='freeze_history'
alias ufh='unfreeze_history'
