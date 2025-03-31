if [[ -f "$HOME/.nvm/nvm.sh" ]]; then
   lazy_load load_nvm nvm

   function load_nvm() {
      [[ -z "$__NVM_DIR" ]] && export __NVM_DIR="$HOME/.nvm"
      [[ -s "$__NVM_DIR/nvm.sh" ]] && source "$__NVM_DIR/nvm.sh" --no-use
      unset __NVM_DIR
   }
fi
