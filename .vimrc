" vim:set ft=vim et sw=2:

let mapleader=" "
let maplocalleader="\\"

" Numbering
set number
set relativenumber

set expandtab
set shiftwidth=2
set softtabstop=2

set ignorecase
set smartcase

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

nnoremap <silent> <leader>w :update<cr>
nnoremap <silent> <leader>q :bd<cr>

"===============================================================
" The below are "defaults" that in theory make vim behave like
" nvim, so that I get a consistent environment no matter which.
" Copied from mikeslattery/nvim-defaults.vim
"---------------------------------------------------------------

" Skip everything below if we are in nvim.
if has('nvim')
  set nosmarttab
  finish
endif

" Vim 7 options that differ

set nocompatible
if has('autocmd')
  filetype plugin indent on
endif

set backspace=indent,eol,start
set encoding=utf-8
set incsearch
set nolangremap
let &nrformats="bin,hex"
set showcmd
set ruler
set wildmenu

" Vim 7, 8 options that differ

set autoindent
set autoread
set background=dark
set belloff=all
set cdpath=,.,~/src,~/
set clipboard=unnamed,unnamedplus
set cmdheight=1
set complete=.,w,b,u,t
set cscopeverbose
set diffopt=internal,filler
set display=lastline
" TODO: 'fillchars' defaults (in effect) to "vert:│,fold:·,sep:│"
set fillchars=
set formatoptions=tcqj
let &keywordprg=":Man"
set nofsync
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set hidden
set history=10000
set hlsearch
set nojoinspaces
set laststatus=2
set listchars=tab:>\ ,trail:-,nbsp:+
set maxcombine=6
set mouse=a
set scroll=13
set scrolloff=0
set sessionoptions-=options
set shortmess=filnxtToOF
set sidescroll=1
set smarttab
set nostartofline
set tabpagemax=50
set tags=./tags;,tags
set notitle
set switchbuf=uselast
set titleold=
set ttimeout
set ttimeoutlen=50
set ttyfast
"TODO: set viewoptions+=unix,slash
set viewoptions-=options
let &viminfo='!,'.&viminfo
let &wildoptions="pum,tagfile"

" DEFAULT-MAPPINGS
" :help default-mappings
nnoremap Y y$
nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<CR><C-L>
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Implement Q
let g:qreg='@'
function! RecordOrStop()
  if reg_recording() == ''
    echo 'Enter register to record to: '
    let g:qreg=getcharstr()
    if g:qreg != "\e"
      execute 'normal! q'.g:qreg
    endif
  else
    normal! q
    call setreg(g:qreg, substitute(getreg(g:qreg), "q$", "", ""))
  endif
endfunction

" :MapQ will activate the Q mapping
command! MapQ noremap q <cmd>call RecordOrStop()<cr>
noremap Q <cmd>execute 'normal! @'.g:qreg<cr>

" DEFAULT PLUGINS

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
if exists(":Man") != 2
  runtime! ftplugin/man.vim
endif
