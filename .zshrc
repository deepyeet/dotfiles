# Environment variables for the interactive terminal.

# Should move these.
export EDITOR=nvim
export PAGER=less

# Nord Dircolors
# Seems to work OK with Catppuccin... maybe
# ==============================================================================
# Copyright (C) 2017-present Arctic Ice Studio <development@arcticicestudio.com>
# Copyright (C) 2017-present Sven Greb <development@svengreb.de>
# Project:    Nord dircolors
# Version:    0.2.0
# Repository: https://github.com/arcticicestudio/nord-dircolors
# License:    MIT
LS_COLORS='no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:';
export LS_COLORS
# ------------------------------------------------------------------------------

if [ "$TERM" = "linux" ]; then
  # Taken from the catppuccin repo somewhere
	printf %b '\e]P01E1E2E' # set background color to "Base"
	printf %b '\e]P8585B70' # set bright black to "Surface2"

	printf %b '\e]P7BAC2DE' # set text color to "Text"
	printf %b '\e]PFA6ADC8' # set bright white to "Subtext0"

	printf %b '\e]P1F38BA8' # set red to "Red"
	printf %b '\e]P9F38BA8' # set bright red to "Red"

	printf %b '\e]P2A6E3A1' # set green to "Green"
	printf %b '\e]PAA6E3A1' # set bright green to "Green"

	printf %b '\e]P3F9E2AF' # set yellow to "Yellow"
	printf %b '\e]PBF9E2AF' # set bright yellow to "Yellow"

	printf %b '\e]P489B4FA' # set blue to "Blue"
	printf %b '\e]PC89B4FA' # set bright blue to "Blue"

	printf %b '\e]P5F5C2E7' # set magenta to "Pink"
	printf %b '\e]PDF5C2E7' # set bright magenta to "Pink"

	printf %b '\e]P694E2D5' # set cyan to "Teal"
	printf %b '\e]PE94E2D5' # set bright cyan to "Teal"

	clear
fi

# Debian compinit is pointless. We're doing it here.
# Turning this off messes with our zsh.
skip_global_compinit=1

#===================================
# Lazy Load to speed up zsh start
#
# Authors:
#   xcv58 <i@xcv58.com>
#-----------------------------------
# TODO: get working so that completions lazy load on tab?

function lazy_load() {
    local load_func=${1}
    local lazy_func="lazy_${load_func}"

    shift
    for i in ${@}; do
        alias ${i}="${lazy_func} ${i}"
    done

    eval "
    function ${lazy_func}() {
        unset -f ${lazy_func}
        lazy_load_clean $@
        eval ${load_func}
        unset -f ${load_func}
        eval \$@
    }
    "
}

function lazy_load_clean() {
    for i in ${@}; do
        unalias ${i}
    done
}

#----------------------------------
# Variables and folders
#==================================

_YIYANG_ZSH="$HOME/.zsh"
_YIYANG_ZSH_CACHE_DIR="$_YIYANG_ZSH/cache"
_YIYANG_ZSH_PLUGINS_DIR="$_YIYANG_ZSH/plugins"
_YIYANG_COMPDUMPFILE="$_YIYANG_ZSH/zcompdump"

# Set up a place to dump all my ZSH stuff
[[ -d "$_YIYANG_ZSH" ]] || mkdir -p "$_YIYANG_ZSH"
[[ -d "$_YIYANG_ZSH_CACHE_DIR" ]] || mkdir -p "$_YIYANG_ZSH_CACHE_DIR"
[[ -d "$_YIYANG_ZSH_PLUGINS_DIR" ]] || mkdir -p "$_YIYANG_ZSH_PLUGINS_DIR"

# If this is a symlink we also need to create the link for lib
(
if [[ -L "$HOME/.zshrc" && ! -e "$_YIYANG_ZSH/lib" ]]; then
   cd "$HOME"
   rcsymlink=$(dirname $(readlink .zshrc))
   zshsrcdir=$(cd "$rcsymlink" && pwd)

   # If there's no lib then link it otherwise don't touch
   ln -s "$zshsrcdir/.zsh/lib" "$_YIYANG_ZSH/lib"
fi
)

# TODO: Figure out where to put these options
unsetopt flow_control # disables ^S and ^Q for controlling terminal output
unsetopt bg_nice # fix for wsl where zsh tries to nice bg processes

#==============================================================================
# Plugin Loading
#------------------------------------------------------------------------------
# This section may also end up loading things into fpath, etc, which should
# be done before compinit. Pray that nothing here depends on compinit.

# Turns out, antigen fucks with completion
# I've decided to nuke it
function clone_plugin() {
   local plugin_repo=$1
   local plugin_name=${1##*/}
   local _plugin_dir="$_YIYANG_ZSH_PLUGINS_DIR/$plugin_name"
   if [[ ! -d "$_plugin_dir" ]]; then
      git clone --depth 1 $plugin_repo "$_plugin_dir" &> /dev/null
   fi

   echo "$_plugin_dir"
}

function load_plugin() {
   local plugin_repo=$1
   local _plugin_dir=$(clone_plugin "$plugin_repo")

   local sourced=$2
   source $_plugin_dir/$sourced
}

# Install starship if we're not on a system that has it available in repository
if [[ ! -d "$_YIYANG_ZSH_PLUGINS_DIR/starship" ]]; then
   mkdir -p "$_YIYANG_ZSH_PLUGINS_DIR/starship" 
   curl -sS curl https://starship.rs/install.sh | sh -s -- -b "$_YIYANG_ZSH_PLUGINS_DIR/starship"
fi

load_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting.plugin.zsh
load_plugin https://github.com/zsh-users/zsh-completions.git zsh-completions.plugin.zsh
load_plugin https://github.com/zsh-users/zsh-history-substring-search zsh-history-substring-search.zsh
export _Z_DATA="$_YIYANG_ZSH/.z" 
load_plugin https://github.com/rupa/z.git z.sh
load_plugin https://github.com/molovo/tipz tipz.zsh
load_plugin https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions.zsh
load_plugin https://github.com/andrewferrier/fzf-z.git fzf-z.plugin.zsh

#==============================================================================
# Local
#------------------------------------------------------------------------------
# This is here because:
# 1. You can add things into the fpath before completion loads
# 2. It's after all the plugins are loaded and all the vars defined, meaning
#    they are usable, and we can load even more plugins.
# 3. Custom prompt hooks exist - use `custom_right_prompt`.

if [[ -e "$HOME/.zshlocalrc" ]]; then
   . "$HOME/.zshlocalrc"
fi

# ==============================================================
# Prompt - adds stuff into fpath
# --------------------------------------------------------------
. "$_YIYANG_ZSH/lib/prompt.zsh"

#==============================================================================
# Core
#------------------------------------------------------------------------------

# Load completion
# Nothing can load into fpath after this
. "$_YIYANG_ZSH/lib/completion.zsh"

# Completion must be loaded before keybindings which depends on menuselect
. "$_YIYANG_ZSH/lib/keybinds.zsh"

# Other bunch of random options
. "$_YIYANG_ZSH/lib/history.zsh"
. "$_YIYANG_ZSH/lib/correction.zsh"

#==============================================================================
# Additional Settings
#------------------------------------------------------------------------------
# Note: NONE of these settings may add things into fpath because it doesn't work

# Plugin specific settings
. "$_YIYANG_ZSH/lib/plugins/fzf-z.zsh"
. "$_YIYANG_ZSH/lib/plugins/zsh-syntax-highlighting.zsh"
. "$_YIYANG_ZSH/lib/plugins/zsh-autosuggestions.zsh"
. "$_YIYANG_ZSH/lib/plugins/zsh-history-substring-search.zsh"

# Things which configure various external tools
. "$_YIYANG_ZSH/lib/opt/cdr.zsh"
. "$_YIYANG_ZSH/lib/opt/fzf.zsh"
. "$_YIYANG_ZSH/lib/opt/fancy-ctrl-z.zsh"
. "$_YIYANG_ZSH/lib/opt/git.zsh"
. "$_YIYANG_ZSH/lib/opt/grep.zsh"
. "$_YIYANG_ZSH/lib/opt/helm.zsh"
. "$_YIYANG_ZSH/lib/opt/hg.zsh"
. "$_YIYANG_ZSH/lib/opt/kubectl.zsh"
. "$_YIYANG_ZSH/lib/opt/ls.zsh"
. "$_YIYANG_ZSH/lib/opt/minikube.zsh"
. "$_YIYANG_ZSH/lib/opt/nvm.zsh"
. "$_YIYANG_ZSH/lib/opt/pyenv.zsh"
. "$_YIYANG_ZSH/lib/opt/rbenv.zsh"
. "$_YIYANG_ZSH/lib/opt/virtualenv.zsh"
. "$_YIYANG_ZSH/lib/opt/virtualenvwrapper.zsh"
. "$_YIYANG_ZSH/lib/opt/yubikey.zsh"

