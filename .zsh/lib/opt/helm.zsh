if [[ $+commands[helm] -ne 0 ]]; then
   lazy_load load_helm helm

   function load_helm() {
      __HELM_COMPLETION_FILE="${_YIYANG_ZSH_CACHE_DIR}/helm_completion"

      if [[ ! -f $__HELM_COMPLETION_FILE ]]; then
         helm completion zsh >! $__HELM_COMPLETION_FILE
      fi

      [[ -f $__HELM_COMPLETION_FILE ]] && source $__HELM_COMPLETION_FILE

      unset __HELM_COMPLETION_FILE
   }
fi
