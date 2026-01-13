# Modern CLI tool aliases with fallbacks
# These tools are Rust-based replacements for classic Unix tools

# eza (better ls) - https://github.com/eza-community/eza
if (( $+commands[eza] )); then
  alias ls='eza --icons --group-directories-first'
  alias l='eza --icons'
  alias la='eza -a --icons'
  alias ll='eza -la --icons --git'
  alias tree='eza --tree --icons'
fi

# bat (better cat) - https://github.com/sharkdp/bat
if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# fd (better find) - https://github.com/sharkdp/fd
# Note: fd is often installed as 'fdfind' on Debian/Ubuntu
if (( $+commands[fdfind] )) && (( ! $+commands[fd] )); then
  alias fd='fdfind'
fi

# zoxide (better z/cd) - https://github.com/ajeetdsouza/zoxide
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"

  # C-g keybinding for interactive directory selection (like old fzf-z)
  function _zoxide-widget() {
    local result
    result="$(zoxide query -i)"
    if [[ -n "$result" ]]; then
      BUFFER="cd ${(q)result}"
      zle accept-line
    fi
    zle reset-prompt
  }
  zle -N _zoxide-widget
  bindkey '^g' _zoxide-widget
fi

# atuin (better history) - https://github.com/atuinsh/atuin
# Must load after fzf to override Ctrl+R
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh)"
fi
