# Fallback ls aliases when eza is not installed
# (eza aliases are defined in modern-tools.zsh)

if ! (( $+commands[eza] )); then
   case "$OSTYPE" in
      darwin*) alias ls='ls -G' ;;
      *)       alias ls='ls --color=auto' ;;
   esac

   alias l='ls'
   alias la='ls -A'
   alias ll='ls -lAh'
fi
