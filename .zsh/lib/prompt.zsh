function load-starship() {
   local starship_bin="${_YIYANG_ZSH_PLUGINS_DIR}/starship/starship" 
   if [[ -f "$starship_bin" ]]; then
      eval "$("$starship_bin" init zsh)"
   fi
}

load-starship
