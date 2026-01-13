# fzf shell integration
# Modern fzf (0.48+) has built-in shell integration via --zsh
# Falls back to legacy paths for older versions

if (( $+commands[fzf] )); then
   # Try modern built-in shell integration first (fzf 0.48+)
   if fzf --zsh &>/dev/null; then
      source <(fzf --zsh)
   # Fallback to legacy paths
   elif [[ -e "$HOME/.fzf.zsh" ]]; then
      . "$HOME/.fzf.zsh"
   elif [[ -e "/usr/share/fzf/completion.zsh" ]]; then
      . "/usr/share/fzf/completion.zsh"
      . "/usr/share/fzf/key-bindings.zsh"
   elif [[ -e "/usr/share/doc/fzf/examples/completion.zsh" ]]; then
      . "/usr/share/doc/fzf/examples/completion.zsh"
      . "/usr/share/doc/fzf/examples/key-bindings.zsh"
   fi
fi

# Catppuccin Mocha Colors
export FZF_DEFAULT_OPTS=" \
   --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
   --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
   --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
