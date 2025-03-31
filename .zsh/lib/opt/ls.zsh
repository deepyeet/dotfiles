if [[ $(uname -s) == 'Darwin' ]]; then
   alias ls='ls -G'
else
   alias ls='ls --color'
fi

alias l='ls'
alias la='ls -A'
alias ll='ls -lAh'
