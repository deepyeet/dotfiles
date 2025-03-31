# stolen from oh-my-zsh

if [[ $+commands[pyenv] -ne 0 && ! $HOSTNAME =~ 'facebook.com' && ! $HOSTNAME =~ ".od" ]]; then
   # This is for Linux. OSX brew path should be there already.
   pyenvdirs=("$HOME/.pyenv" "/usr/local/pyenv" "/opt/pyenv")
   for dir in $pyenvdirs; do
      if [[ -d $dir/bin ]]; then
         export PATH="$PATH:$dir/bin"
         break
      fi
   done

   function load_pyenv() {
      eval "$(pyenv init - zsh)"
      if (( $+commands[pyenv-virtualenv-init] )); then
         eval "$(pyenv virtualenv-init - zsh)"
      fi
   }

   # We don't want to lazy load this, because of features around shell
   load_pyenv
fi
