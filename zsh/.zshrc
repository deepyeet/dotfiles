# ==============================================================================
#                              ZSHRC - Unified Configuration
# ==============================================================================
# A single-file zsh configuration using zinit for plugin management.
# Managed with GNU Stow: run `stow zsh` from dotfiles directory.
#
# DATA LOCATIONS (XDG-compliant):
#   ~/.local/share/zinit/  - Zinit plugin manager and all plugins
#   ~/.local/share/zsh/    - Persistent data (cdr recent directories)
#   ~/.cache/zsh/          - Cache (completions dump and cache)
#
# STRUCTURE:
#   1. Environment       - EDITOR, PAGER, colors
#   2. Shell Options     - Core zsh behavior settings
#   3. Zinit + Plugins   - Plugin manager with proper load ordering
#   4. Completions       - Tab completion settings (after compinit)
#   5. Keybindings       - Vi mode, navigation, custom bindings
#   6. Recent Dirs       - Built-in cdr for quick directory access
#   7. Aliases           - Git, Mercurial, modern CLI tools
#   8. Tool Integrations - fzf, zoxide, atuin, starship
#   9. Local Overrides   - Machine-specific config (~/.zshlocalrc)
# ==============================================================================


# ==============================================================================
# 1. ENVIRONMENT
# ==============================================================================

export EDITOR=nvim
export PAGER=less

# LS_COLORS: Colorizes files in ls, eza, and tab completion.
# From Nord dircolors (https://github.com/arcticicestudio/nord-dircolors)
# Format: "type=ANSI_code:..." - see `dircolors --print-database`
LS_COLORS='no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:'
export LS_COLORS

# Linux TTY: Set Catppuccin Mocha colors for raw console (TERM=linux only)
if [[ "$TERM" = "linux" ]]; then
    printf %b '\e]P01E1E2E' '\e]P8585B70' '\e]P7BAC2DE' '\e]PFA6ADC8'
    printf %b '\e]P1F38BA8' '\e]P9F38BA8' '\e]P2A6E3A1' '\e]PAA6E3A1'
    printf %b '\e]P3F9E2AF' '\e]PBF9E2AF' '\e]P489B4FA' '\e]PC89B4FA'
    printf %b '\e]P5F5C2E7' '\e]PDF5C2E7' '\e]P694E2D5' '\e]PE94E2D5'
    clear
fi


# ==============================================================================
# 2. SHELL OPTIONS
# ==============================================================================

# XDG directories for zsh data
ZSH_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_DATA_DIR" "$ZSH_CACHE_DIR"

skip_global_compinit=1    # Skip Debian's premature compinit
unsetopt flow_control     # Disable Ctrl+S/Q (terminal freeze)
unsetopt bg_nice          # Don't nice background jobs (WSL fix)
setopt correct            # Suggest corrections for typos
setopt autocd             # Type directory name to cd into it

# History: Atuin handles interactive search (Ctrl+R).
# We keep minimal zsh history for:
#   - history-substring-search plugin (up/down arrow)
#   - Fallback if atuin is unavailable
setopt hist_ignore_space  # Ignore commands starting with space
setopt inc_append_history # Append immediately, not on exit
setopt share_history      # Share history between terminals
HISTSIZE=10000            # In-memory history (for substring search)
SAVEHIST=0                # Don't write to disk (atuin handles persistence)


# ==============================================================================
# 3. ZINIT PLUGIN MANAGER
# ==============================================================================
# Zinit is a flexible zsh plugin manager with proper compinit integration.
# Repository: https://github.com/zdharma-continuum/zinit
#
# ZINIT SYNTAX REFERENCE:
# ─────────────────────────────────────────────────────────────────────────────
# zinit light <plugin>     Load plugin (fast, no tracking)
# zinit load <plugin>      Load plugin (with reporting/tracking)
# zinit ice <modifiers>    Set options for NEXT zinit command only ("ice" melts)
#
# COMMON ICE MODIFIERS:
# ─────────────────────────────────────────────────────────────────────────────
# wait'N'      Defer loading until N tenths of second after prompt
#              wait'0' = after first prompt, wait'1' = 0.1s after, etc.
#              wait'0a' wait'0b' = priority ordering (a loads before b)
#
# lucid        Suppress "Loaded <plugin>" messages
#
# blockf       Block plugin from modifying fpath (we handle it ourselves)
#
# atload'cmd'  Run command after loading plugin
#
# as'program'  Treat as external program, not zsh plugin
#
# from'gh-r'   Download from GitHub Releases (binary releases)
#
# COMMANDS:
# ─────────────────────────────────────────────────────────────────────────────
# zinit update           Update all plugins
# zinit self-update      Update zinit itself
# zinit times            Show plugin load times (for debugging)
# zinit report <plugin>  Show what a plugin did (functions, aliases, etc.)
# zinit delete --all     Remove all plugins (clean reinstall)
# zinit zstatus          Show zinit status
#
# LOAD ORDER (critical for correctness):
# ─────────────────────────────────────────────────────────────────────────────
#   1. zsh-completions   - Adds completion definitions to fpath
#   2. compinit          - Initializes completion system (reads fpath)
#   3. fzf-tab           - Replaces completion menu (must be after compinit)
#   4. autosuggestions   - Wraps ZLE widgets (must be after compinit)
#   5. syntax-highlight  - Wraps ZLE widgets (must be last)
#
# WHY THIS ORDER MATTERS:
#   - compinit reads fpath, so completions must be added before it runs
#   - fzf-tab hooks into the completion system compinit creates
#   - autosuggestions/syntax-highlighting wrap ZLE widgets, so they must
#     load after any plugin that creates widgets they need to wrap
# ==============================================================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Auto-install zinit if missing
if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{33}Installing zinit...%f"
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- Phase 1: Completions (before compinit) ---
# blockf prevents the plugin from adding to fpath itself (zinit handles it)
zinit ice blockf
zinit light zsh-users/zsh-completions

# --- Phase 2: compinit ---
# Compile completions to ~/.cache/zsh/zcompdump for faster loading
# Only regenerate the dump file once per day
autoload -Uz compinit
_zcompdump="$ZSH_CACHE_DIR/zcompdump"
if [[ -n ${_zcompdump}(#qN.mh+24) ]]; then
    compinit -d "$_zcompdump"
else
    compinit -C -d "$_zcompdump"  # -C skips security check (faster)
fi
unset _zcompdump

# --- Phase 3: fzf-tab (after compinit) ---
# Replaces zsh's completion menu with fzf. Must load after compinit.
# wait'0a': load after first prompt, 'a' = highest priority among wait'0'
zinit ice wait'0a' lucid
zinit light Aloxaf/fzf-tab

# --- Phase 4: Widget wrappers (must be last) ---
# These plugins wrap ZLE widgets, so they must load after everything else
# that creates or modifies widgets.

# Autosuggestions: shows grayed-out suggestion as you type
zinit ice wait'0b' lucid
zinit light zsh-users/zsh-autosuggestions

# History substring search: up/down arrows search history
zinit ice wait'0b' lucid
zinit light zsh-users/zsh-history-substring-search

# Syntax highlighting: colorizes commands as you type
# Must be LAST because it wraps all other widgets
zinit ice wait'0c' lucid
zinit light zdharma-continuum/fast-syntax-highlighting


# ==============================================================================
# 4. COMPLETION SETTINGS
# ==============================================================================
# These zstyles configure how tab completion behaves.
# Loaded after compinit (handled by zinit above).
# ==============================================================================

zmodload -i zsh/complist
setopt glob_complete      # Tab on * opens menu instead of expanding
setopt complete_in_word   # Complete from middle of word
setopt always_to_end      # Move cursor to end after completion

# Matching: case-insensitive, partial, substring
# Tried in order until match found
zstyle ':completion:*' matcher-list \
    'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' \
    '' \
    'r:|[-_.]=*' \
    'r:|?=**'

zstyle ':completion:*' menu select                          # Arrow key menu
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{white}%B%d%b%f'

# Cache completions for faster repeated use
zstyle ':completion::complete:*' use-cache yes
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE_DIR/compcache"

# Ignore system users in completion
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
    clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
    gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
    ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
    operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
    usbmux uucp vcsa wwwrun xfs '_*'


# ==============================================================================
# 5. KEYBINDINGS
# ==============================================================================
# Vi mode with visual cursor feedback.
# ==============================================================================

bindkey -v                # Vi mode
export KEYTIMEOUT=1       # 10ms delay for key sequences (snappy escape)

# Cursor shape: block for command mode, beam for insert mode
function zle-keymap-select zle-line-init {
    case $KEYMAP in
        vicmd)      echo -ne '\e[1 q' ;;  # Block
        viins|main) echo -ne '\e[5 q' ;;  # Beam
    esac
    zle reset-prompt
    zle -R
}
zle -N zle-keymap-select
zle -N zle-line-init

# Redraw prompt on terminal resize
TRAPWINCH() { zle && zle -R }

# Menu navigation with hjkl
zmodload zsh/terminfo
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# History substring search bindings
bindkey '^[[A' history-substring-search-up    # Up arrow
bindkey '^[[B' history-substring-search-down  # Down arrow
[[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" history-substring-search-up
[[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M viins '^P' history-substring-search-up
bindkey -M viins '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Autosuggestions: Ctrl+Space to accept
bindkey '^ ' autosuggest-accept

# Ctrl+Z: toggle between fg and bg (or push current line)
function fancy-ctrl-z() {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Unbind problematic defaults
bindkey -rM viins '^X'  # Allow ^X prefix bindings
bindkey -rM viins '^L'  # Disable clear-screen
bindkey -rM vicmd '^L'


# ==============================================================================
# 6. RECENT DIRECTORIES (cdr)
# ==============================================================================
# Built-in zsh recent directory tracking.
# `d` lists recent dirs, `1`-`9` jumps to them.
# Data stored in ~/.local/share/zsh/cdr-recent-dirs
# ==============================================================================

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file "$ZSH_DATA_DIR/cdr-recent-dirs"
zstyle ':chpwd:*' recent-dirs-max 1000
zstyle ':chpwd:*' recent-dirs-default yes

alias d='cdr -l | head -10'
alias 1='cdr 1' 2='cdr 2' 3='cdr 3' 4='cdr 4' 5='cdr 5'
alias 6='cdr 6' 7='cdr 7' 8='cdr 8' 9='cdr 9'

# Quick parent directory navigation
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'


# ==============================================================================
# 7. ALIASES
# ==============================================================================

# --- Git ---
alias gs='git status'
alias glog='git log'
alias gl='git pull'
alias gp='git push'
alias gco='git checkout'
alias ga='git add'
alias gc='git commit'
alias gcam='git commit -am'

# --- Mercurial ---
alias hs='hg status'
alias hsl='hg sl'
alias hd='hg diff'
alias hdp='hg diff -r .^'
alias hco='hg checkout'
alias hcoc='hg checkout --clean'
alias hcom='hg checkout --merge'
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
hup() { hg pull && hg rebase -d master }

# --- Modern CLI tools (with fallbacks) ---
if (( $+commands[eza] )); then
    alias ls='eza --icons --group-directories-first'
    alias l='eza --icons'
    alias la='eza -a --icons'
    alias ll='eza -la --icons --git'
    alias tree='eza --tree --icons'
else
    case "$OSTYPE" in
        darwin*) alias ls='ls -G' ;;
        *)       alias ls='ls --color=auto' ;;
    esac
    alias l='ls'
    alias la='ls -A'
    alias ll='ls -lAh'
fi

if (( $+commands[bat] )); then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# fd: alias fdfind on Debian/Ubuntu
(( $+commands[fdfind] )) && (( ! $+commands[fd] )) && alias fd='fdfind'

# grep: always colorize
alias grep='grep --color=auto'


# ==============================================================================
# 8. TOOL INTEGRATIONS
# ==============================================================================

# --- fzf (fuzzy finder) ---
# Provides: Ctrl+T (files), Ctrl+R (history), Alt+C (cd)
if (( $+commands[fzf] )); then
    if fzf --zsh &>/dev/null; then
        source <(fzf --zsh)
    elif [[ -f ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
    elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
        source /usr/share/fzf/completion.zsh
    fi
    # Catppuccin Mocha theme
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

# --- zoxide (smart cd) ---
# Provides: z (jump), zi (interactive), Ctrl+G (fzf picker)
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
    # Ctrl+G: interactive directory picker
    function _zoxide-widget() {
        local result="$(zoxide query -i)"
        if [[ -n "$result" ]]; then
            BUFFER="cd ${(q)result}"
            zle accept-line
        fi
        zle reset-prompt
    }
    zle -N _zoxide-widget
    bindkey '^g' _zoxide-widget
fi

# --- atuin (better history) ---
# Provides: Ctrl+R (replaces fzf history search)
# Must load AFTER fzf to override Ctrl+R binding
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

# --- starship (prompt) ---
# Cross-shell prompt with git status, language versions, etc.
(( $+commands[starship] )) && eval "$(starship init zsh)"


# ==============================================================================
# 9. LOCAL OVERRIDES
# ==============================================================================
# Machine-specific config that shouldn't be in version control.
# Create ~/.zshlocalrc for local aliases, PATH additions, etc.
# ==============================================================================

[[ -f "${HOME}/.zshlocalrc" ]] && source "${HOME}/.zshlocalrc"
