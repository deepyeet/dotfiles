alias hs='hg status'
alias hsl='hg sl'
alias hd='hg diff'
alias hdp='hg diff -r .^'

alias hco='hg checkout'
alias hcoc='hg checkout --clean' # doing stuff and just chuck it away
alias hcom='hg checkout --merge' # writing stuff on the wrong tip, hcom master

alias ha='hg add'
alias har='hg addremove'
alias hf='hg forget'
alias hrm='hg rm'
alias hrv='hg revert'
alias hrva='hg revert --all'

alias hc='hg commit'
alias hca='hg commit -A'
alias ham='hg amend'
alias hama='hg amend -A'

alias hl='hg pull'
alias hlu='hg pull -u'
alias hlr='hg pull --rebase'

alias hrb='hg rebase'

function hup() {
   hg pull
   hg rebase -d master
}
