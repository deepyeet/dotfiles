if [[ $(uname -s) == 'Darwin' ]]; then
   export GREP_OPTIONS="--color=always"
else
   alias grep="grep --color=auto"
fi
