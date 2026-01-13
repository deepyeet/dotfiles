# This is the zshenv file
# It's sourced on all invocations of zsh, including scripts
# This file should only contain things that may be necessary for scripts to
# function

# Append to PATH only if not already present (avoids duplicates)
function appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# PATH additions
[[ -d "$HOME/bin" ]] && appendpath "$HOME/bin"
[[ -d "$HOME/.cabal/bin" ]] && appendpath "$HOME/.cabal/bin"
[[ -d "$HOME/go" ]] && {
   export GOPATH="$HOME/go"
   appendpath "$GOPATH/bin"
}

# macOS: Set JAVA_HOME
if [[ "$OSTYPE" == darwin* ]]; then
   export JAVA_HOME=$(/usr/libexec/java_home)
fi

if [[ -z $SSH_AUTH_SOCK ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi
