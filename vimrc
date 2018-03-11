" Settings {{{
    " Folding {{{
        set foldmethod=marker       " fold based on indent level
        set foldenable              " don't fold files by default on open
    " }}}
    set wildmenu                    " visual autocomplete for command menu
    set ignorecase                  " case-insensitive command completion
    set tabstop=4                   " number of visual spaces per TAB
    set shiftwidth=4
    set expandtab                   " tabs are spaces
    set number                      " show line numbers
    set lazyredraw                  " redraw only when we need to.
    set incsearch                   " search as characters are entered
    set hlsearch                    " highlight matches
    set relativenumber              " shows relative line numbers
    set nonumber                    " hides current line number (sets to 0)
    set clipboard=unnamedplus       " Allows yank to be copied to clipboard (similar to "+y)
" }}}
" Keybindings {{{
    let mapleader=","               " leader is comma

    " Folding
    nnoremap <space> za
    nnoremap <F3> zR                " Fold open
    nnoremap <F4> zM                " Fold close

    map <C-b> :NERDTreeToggle<CR>

    " Other
    nnoremap <leader><space> :nohlsearch<CR>
    set pastetoggle=<F2>
" }}}
" Airline Settings {{{
    let g:airline_powerline_fonts = 1
    let g:airline_theme='base16color'
" }}}
" Plugins {{{
call plug#begin()
    Plug 'tpope/vim-sensible'
    Plug 'francoiscabrol/ranger.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tmux-plugins/vim-tmux'
    Plug 'scrooloose/nerdtree'
call plug#end()
" }}}
" AutoCMD {{{
    " Just to make sure folding colors are set
    autocmd vimenter * highlight folded ctermbg=235

    " NerdTree Specifics
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

    " Filetype specific fixes
    autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
" }}}

" vim:foldmethod=marker:foldlevel=0
