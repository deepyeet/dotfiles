# Stolen and modified from oh-my-zsh

if [[ $+commands[kubectl] -ne 0 ]]; then
   lazy_load load_kubectl kubectl

   function load_kubectl() {
      __KUBECTL_COMPLETION_FILE="${_YIYANG_ZSH_CACHE_DIR}/kubectl_completion"

      if [[ ! -f $__KUBECTL_COMPLETION_FILE ]]; then
         kubectl completion zsh >! $__KUBECTL_COMPLETION_FILE
      fi

      [[ -f $__KUBECTL_COMPLETION_FILE ]] && source $__KUBECTL_COMPLETION_FILE

      unset __KUBECTL_COMPLETION_FILE
   }
fi
