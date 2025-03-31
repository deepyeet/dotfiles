# random yubikey things

function ykman_oath() {
   ykman oath remember-password
   ykman oath code -s "$@"
}

function ykman_oath_xclip() {
   ykman oath remember-password
   ykman oath code -s "$@" | xclip -in -selection clipboard
}

alias mfa=ykman_oath
alias mfax=ykman_oath_xclip
