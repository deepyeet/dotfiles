if [[ $+commands[rbenv] -ne 0 ]]; then
   lazy_load load_rbenv rbenv

   function load_rbenv() {
      eval "$(rbenv init -)"
   }
fi
