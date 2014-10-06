set nocompatible

filetype on

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Bundle 'gmarik/Vundle.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'kien/ctrlp.vim'
Bundle 'rking/ag.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'austintaylor/vim-indentobject'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-unimpaired'
Bundle 'moll/vim-bbye'
Bundle 'vim-scripts/a.vim'
Bundle 'junegunn/fzf'
call vundle#end()
filetype plugin indent on

syntax enable
set background=dark
colorscheme solarized

let mapleader = ","

set mouse=a
set ttymouse=xterm2
set autoindent
set autoread
set backspace=2
set backupcopy=yes
set directory-=.
set encoding=utf-8
set expandtab
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:▸\ ,trail:▫
set number
set ruler
set scrolloff=3
set shiftwidth=4
set showcmd
set smartcase
set softtabstop=4
set tabstop=4
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu
set wildmode=longest,list,full
set whichwrap+=<,>,h,l,[,]

if $TMUX == ''
    set clipboard+=unnamed
endif

" cursor shapes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" highlight cursor row/column
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" md files are markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell

" remove all trailing whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" paste doesn't yank
vnoremap p "_dP

" fzf (fuzzy completer)
"set rtp+=/usr/local/Cellar/fzf/0.8.4

" ctrlp
nmap <leader>t :CtrlP<CR>
nmap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" NERDTree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
let g:NERDSpaceDelims=1
let g:ctrlp_match_window = 'order:ttb,max:20'

" easymotion
nmap <Leader> <Plug>(easymotion-prefix)
nmap <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>e <Plug>(easymotion-bd-e)

" gitgutter
let g:gitgutter_enabled = 1
nmap <leader>g :GitGutterToggle<CR>

" ycm
let g:ycm_confirm_extra_conf = 0
let g:ycm_add_preview_to_completeopt = 0
set completeopt-=preview

" ag
nmap <leader>a :Ag<space>
set grepprg=ag\ --nogroup\ --nocolor

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set noshowmode

" bbye
:nnoremap <Leader>q :Bdelete<CR>

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'

