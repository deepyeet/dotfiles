# opt for the /usr/share version first

__FZF_LOADED=false
if ! $__FZF_LOADED && [[ -e "$HOME/.fzf.zsh" ]]; then
   . "$HOME/.fzf.zsh"
   __FZF_LOADED=true
fi

if ! $__FZF_LOADED && [[ -e "/usr/share/fzf/completion.zsh" ]]; then
   . "/usr/share/fzf/completion.zsh"
   . "/usr/share/fzf/key-bindings.zsh"
   __FZF_LOADED=true
fi

if ! $__FZF_LOADED && [[ -e "/usr/share/fzf/shell/key-bindings.zsh" ]]; then
   . "/usr/share/fzf/shell/key-bindings.zsh"
   __FZF_LOADED=true
fi

if ! $__FZF_LOADED && [[ -e "/usr/share/doc/fzf/examples/completion.zsh" ]]; then
   . "/usr/share/doc/fzf/examples/completion.zsh"
   . "/usr/share/doc/fzf/examples/key-bindings.zsh"
   __FZF_LOADED=true
fi

if ! $__FZF_LOADED && (( $+commands[brew] )); then
   __BREW_PREFIX="$(brew --prefix)/opt/fzf/shell"
   if [[ -e "${__BREW_PREFIX}" ]]; then
      . "${__BREW_PREFIX}/completion.zsh"
      . "${__BREW_PREFIX}/key-bindings.zsh"
      __FZF_LOADED=true
   fi
   unset __BREW_PREFIX
fi

# Catppuccin Colors
export FZF_DEFAULT_OPTS=" \
   --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
   --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
   --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
