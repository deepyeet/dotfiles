# This is the zshenv file
# It's sourced on all invocations of zsh, including scripts
# This file should only contain things that may be necessary for scripts to
# function

# Stolen from profile
# This helps with dupes
function appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# PATH
[[ -d "$HOME/bin" ]] && appendpath "$HOME/bin"
[[ -d "$HOME/.rbenv/bin" ]] && appendpath "$HOME/.rbenv/bin"
[[ -d "$HOME/.cabal/bin" ]] && appendpath "$HOME/.cabal/bin"
[[ -d "$HOME/go" ]] && {
   export GOPATH="$HOME/go"
   appendpath "$GOPATH/bin"
}

# OSX fun + fix the java version
# Unfuck me later
if [[ $(uname -s) == 'Darwin' ]]; then
   export JAVA_HOME=$(/usr/libexec/java_home)
fi

export EDITOR=vim
if [[ -z $SSH_AUTH_SOCK ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi
