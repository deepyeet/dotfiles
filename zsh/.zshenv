# ==============================================================================
# ZSHENV - Sourced for ALL zsh invocations (including scripts)
# ==============================================================================
# Keep this minimal. Only environment variables that scripts might need.
# Interactive-only config goes in .zshrc.
# ==============================================================================

export EDITOR=nvim
export PAGER=less

# Append to PATH only if not already present
appendpath() {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}

[[ -d "$HOME/bin" ]] && appendpath "$HOME/bin"

# SSH agent socket (systemd user service)
[[ -z "$SSH_AUTH_SOCK" ]] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# ==============================================================================
# Machine-specific config that shouldn't be in version control.
# ==============================================================================
[[ -f "${HOME}/.zshlocalenv" ]] && source "${HOME}/.zshlocalenv"
