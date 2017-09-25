" Folding {{{
" "=== folding ===
    set foldmethod=marker   " fold based on indent level
    set foldenable          " don't fold files by default on open
    nnoremap <space> za
" }}}

" Settings {{{
    set wildmenu            " visual autocomplete for command menu
    set ignorecase          " case-insensitive command completion
    set tabstop=4           " number of visual spaces per TAB
    set softtabstop=4       " number of spaces in tab when editing
    set expandtab           " tabs are spaces
    set number              " show line numbers
    set lazyredraw          " redraw only when we need to.
    set incsearch           " search as characters are entered
    set hlsearch            " highlight matches
    set relativenumber      " shows relative line numbers
    set nonumber            " hides current line number (sets to 0)
" }}}

let mapleader=","       " leader is comma

nnoremap <leader><space> :nohlsearch<CR>
noremap <space> za
set pastetoggle=<F2>

call plug#begin()
    Plug 'tpope/vim-sensible'
    Plug 'francoiscabrol/ranger.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdtree'
call plug#end()

" vim:foldmethod=marker:foldlevel=0
