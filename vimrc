" Folding {{{
" "=== folding ===
    set foldmethod=indent   " fold based on indent level
    set foldnestmax=10      " max 10 depth
    set foldenable          " don't fold files by default on open
    nnoremap <space> za
    set foldlevelstart=10   " start with fold level of 1
" " }}}

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
    set foldenable          " enable folding
    set foldlevelstart=10   " open most folds by default
    set foldnestmax=10      " 10 nested fold max
    set foldmethod=indent   " fold based on indent level
" }}}

" Section Name {{{
" set number "This will be folded
" " }}}
"
let mapleader=","       " leader is comma

nnoremap <leader><space> :nohlsearch<CR>
noremap <space> za

call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-sensible'
call plug#end()

" vim:foldmethod=marker:foldlevel=0
