# ==============================================================================
#                              ZSHRC - Unified Configuration
# ==============================================================================
# A single-file zsh configuration using zinit for plugin management.
# Managed with GNU Stow: run `stow zsh` from dotfiles directory.
#
# DATA LOCATIONS (XDG-compliant):
#   ~/.local/share/zinit/  - Zinit plugin manager and all plugins
#   ~/.cache/zsh/          - Cache (completions dump and cache)
#
# STRUCTURE:
#   1. Environment       - EDITOR, PAGER, colors
#   2. Shell Options     - Core zsh behavior settings
#   3. Zinit + Plugins   - Plugin manager with proper load ordering
#   4. Completions       - Tab completion settings (after compinit)
#   5. Keybindings       - Vi mode, navigation, custom bindings
#   6. Aliases           - Git, Mercurial, modern CLI tools
#   7. Tool Integrations - fzf, zoxide, atuin
#   8. Local Overrides   - Machine-specific config (~/.zshlocalrc)
# ==============================================================================


# ==============================================================================
# 1. ENVIRONMENT
# ==============================================================================

export EDITOR=nvim
export PAGER=less

# LS_COLORS: Colorizes files in ls, fd, and tab completion.
# From Nord dircolors (https://github.com/arcticicestudio/nord-dircolors)
LS_COLORS='no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:'
export LS_COLORS


# ==============================================================================
# 2. SHELL OPTIONS
# ==============================================================================

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

skip_global_compinit=1    # Skip Debian's premature compinit
unsetopt flow_control     # Disable Ctrl+S/Q (terminal freeze)
unsetopt bg_nice          # Don't nice background jobs (WSL fix)
setopt correct            # Suggest corrections for typos
setopt autocd             # Type directory name to cd into it

# History: Atuin handles search (Ctrl+R) and up/down arrows.
# Minimal zsh history as fallback if atuin unavailable.
setopt hist_ignore_space  # Ignore commands starting with space
setopt inc_append_history # Append immediately, not on exit
setopt share_history      # Share history between terminals
HISTSIZE=10000            # In-memory history
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
unalias zi 2>/dev/null  # zinit defines zi=zinit; we want zoxide's zi

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

# Syntax highlighting: colorizes commands as you type
# Must be LAST because it wraps all other widgets
zinit ice wait'0c' lucid
zinit light zdharma-continuum/fast-syntax-highlighting


# ==============================================================================
# 4. COMPLETION SETTINGS
# ==============================================================================
# fzf-tab replaces the menu UI; we only need matching logic and cache.
# ==============================================================================

setopt complete_in_word always_to_end

# Matching: case-insensitive, exact, partial-suffix, substring (tried in order)
zstyle ':completion:*' matcher-list \
    'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' '' 'r:|[-_.]=*' 'r:|?=**'

# Cache completions
zstyle ':completion::complete:*' use-cache yes
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE_DIR/compcache"


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

# Autosuggestions: Ctrl+Space to accept
bindkey '^ ' autosuggest-accept

# Unbind problematic defaults
bindkey -rM viins '^X'  # Allow ^X prefix bindings


# ==============================================================================
# 6. ALIASES
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
    alias la='eza -a --icons'
    alias ll='eza -la --icons --git'
    alias tree='eza --tree --icons'
else
    case "$OSTYPE" in
        darwin*) alias ls='ls -G' ;;
        *)       alias ls='ls --color=auto' ;;
    esac
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
# 7. TOOL INTEGRATIONS
# ==============================================================================

# --- fzf (fuzzy finder) ---
# Provides: Ctrl+T (files), Alt+C (cd). Ctrl+R overridden by atuin.
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

# --- zoxide (smart cd) ---
# Provides: z (jump), zi (interactive)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# --- atuin (better history) ---
# Provides: Ctrl+R (replaces fzf history search)
# Must load AFTER fzf to override Ctrl+R binding
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

# --- Prompt ---
# Clean prompt with useful info:
#   - hostname (for SSH awareness)
#   - directory
#   - red % if last command failed
PROMPT='%F{green}%m%f:%F{blue}%~%f %(?.%#.%F{red}%#%f) '


# ==============================================================================
# 8. LOCAL OVERRIDES
# ==============================================================================
# Machine-specific config that shouldn't be in version control.
# Create ~/.zshlocalrc for local aliases, PATH additions, etc.
# ==============================================================================

[[ -f "${HOME}/.zshlocalrc" ]] && source "${HOME}/.zshlocalrc"
