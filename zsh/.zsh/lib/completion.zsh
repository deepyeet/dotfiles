# Audit fpath for insecure directories (based on oh-my-zsh compfix)
autoload -Uz compaudit
function handle_completion_insecurities() {
  local -aU insecure_dirs
  insecure_dirs=( ${(f@):-"$(compaudit 2>/dev/null)"} )

  # If no such directories exist, get us out of here.
  (( ! ${#insecure_dirs} )) && return

  # List ownership and permissions of all insecure directories.
  print "Insecure completion-dependent directories detected:"
  ls -ld "${(@)insecure_dirs}"
}
handle_completion_insecurities

# Completion Configuration
zmodload -i zsh/complist

# tabbing a * opens menu instead of inserting everything
# you can use ^D to cancel the completion if you want your glob back
setopt glob_complete

setopt complete_in_word # put cursor in middle of word, press tab to fix word.
setopt always_to_end # move cursor to the end afterwards

# Only regenerate zcompdump once per day for faster startup
autoload -Uz compinit
if [[ -n $_MY_COMPDUMPFILE(#qN.mh+24) ]]; then
  compinit -d "$_MY_COMPDUMPFILE"
else
  compinit -C -d "$_MY_COMPDUMPFILE"
fi
autoload -Uz bashcompinit
bashcompinit -i

# Completion Quick Reference
# :completion:<function>:<completer>:<command>:<argument>:<tag>
#
# :completion:* will set that option for all tags

zstyle ':completion:*' menu select

# Completion matching rules (tried in order until one matches):
# 1. Case insensitive, treat - and _ as interchangeable
# 2. Exact match (empty string = no transformation)
# 3. Partial suffix match: typing 'bar' matches 'foo-bar' or 'foo_bar'
# 4. Substring match: typing 'abc' matches 'xxabcxx'
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' \
  '' \
  'r:|[-_.]=*' \
  'r:|?=**'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-prompt '%S%M matches%s' # page matches

# Use caching so that various things that support use-cache (apt?) are usable
zstyle ':completion::complete:*' use-cache yes
zstyle ':completion::complete:*' cache-path "$_MY_ZSH_CACHE_DIR"

zstyle ':completion:*' verbose yes
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{white}%B%d%b%f'

# Ignore uninteresting system users in completion
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle '*' single-ignored show

# SCP/SSH completion improvements - usually there is way too much info!
zstyle ':completion:*:*:scp:*' tag-order files 'users hosts:-host hosts:-domain:domain hosts:-ipaddr:ip\ addr'
zstyle ':completion:*:*:ssh:*' tag-order 'users hosts:-host hosts:-domain:domain hosts:-ipaddr:ip\ addr'
zstyle ':completion:*:*:(scp|ssh):*' group-order files users hosts-host hosts-domain hosts-ipaddr

zstyle ':completion:*:*:(scp|ssh):*:hosts-host' ignored-patterns '*.*' loopback localhost
zstyle ':completion:*:*:(scp|ssh):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:*:(scp|ssh):*:hosts-ipaddr' ignored-patterns '^<->.<->.<->.<->' '127.0.0.<->'

