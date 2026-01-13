# Override the default key bindings

if [[ -n "$terminfo[kcuu1]" ]]; then
   bindkey "$terminfo[kcuu1]" history-substring-search-up
   bindkey "$terminfo[kcud1]" history-substring-search-down
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M viins "^P" history-substring-search-up
bindkey -M viins "^N" history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
