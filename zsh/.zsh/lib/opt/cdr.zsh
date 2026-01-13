_MY_ZSH_CDR_DIR=$_MY_ZSH/cdr

[[ -d $_MY_ZSH_CDR_DIR ]] || mkdir -p $_MY_ZSH_CDR_DIR

setopt autocd # allows using .. and ... and stuff

autoload -Uz chpwd_recent_dirs cdr
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':chpwd:*' recent-dirs-file $_MY_ZSH_CDR_DIR/recent-dirs
zstyle ':chpwd:*' recent-dirs-max 1000
# fall through to cd
zstyle ':chpwd:*' recent-dirs-default yes

alias d='cdr -l | head -10'
alias 1='cdr 1'
alias 2='cdr 2'
alias 3='cdr 3'
alias 4='cdr 4'
alias 5='cdr 5'
alias 6='cdr 6'
alias 7='cdr 7'
alias 8='cdr 8'
alias 9='cdr 9'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
