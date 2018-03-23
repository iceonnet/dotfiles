" Settings {{{
    " Folding {{{
        set foldmethod=marker       " fold based on indent level
        set foldenable              " don't fold files by default on open
    " }}}
    " Plugins {{{
        let g:airline_powerline_fonts = 1
        let g:airline_theme='base16color'
        " Autohighlight
        set updatetime=250          " timeout
        autocmd vimenter * highlight CursorAutoHighlight cterm=bold,reverse ctermbg=0
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
    set modeline
    let mapleader=","               " leader is comma
    filetype plugin on
    filetype plugin indent on
" }}}
" Keybindings {{{
    " Plugins {{{
        " NERDTree
        map <C-b> :NERDTreeToggle<CR>

        " VimWiki
        map <leader>wo :Vimwiki2HTMLBrowse<CR>
        map <leader>tl :VimwikiToggleListItem<CR>
    " }}}
    let mapleader=","               " leader is comma

    " Folding
    nnoremap <space> za
    nnoremap <F3> zR                " Fold open
    nnoremap <F4> zM                " Fold close


    " Other
    nnoremap <leader><space> :nohlsearch<CR>
    set pastetoggle=<F2>
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
        Plug 'davidhalter/jedi-vim'
        Plug 'vimwiki/vimwiki'
        Plug 'https://github.com/tpope/vim-commentary'
        Plug 'lygaret/autohighlight.vim'
    call plug#end()
" }}}
" AutoCMD {{{
    " Just to make sure folding colors are set
    autocmd vimenter * highlight folded ctermbg=235

    " NerdTree Specifics
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" }}}

" vim:foldmethod=marker:foldlevel=0
