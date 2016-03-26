set nocompatible

filetype off
call plug#begin('~/.vim/plugged')
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'luochen1990/rainbow'
Plug 'rking/ag.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'moll/vim-bbye'
Plug 'vim-scripts/a.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'sheerun/vim-polyglot'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'
call plug#end()
filetype plugin indent on

syntax enable
set background=dark
colorscheme solarized

let mapleader = ","

set autoindent
set autoread
set backspace=2
set backupcopy=yes
set completeopt-=preview
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

" j and k walk across word-wrapped lines
nnoremap j gj
nnoremap k gk

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
autocmd BufRead,BufNewFile *.tex set spell

" remove all trailing whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
    let @/=s
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" paste doesn't yank
vnoremap p "_dP

" redraw screen clears highlighting
nnoremap <c-l> :nohl<cr><c-l>

" fzf (fuzzy completer)
nmap <leader>t :FZF<CR>

" NERDTree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
let g:NERDSpaceDelims=1
let g:ctrlp_match_window = 'order:ttb,max:20'

" ag
nmap <leader>a :Ag<space>
set grepprg=ag\ --nogroup\ --nocolor

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" bbye
:nnoremap <Leader>q :Bdelete<CR>

" Rainbow
let g:rainbow_active = 1

" color the gutter with solarized-dark
highlight SignColumn ctermbg=8

" vim-gitgutter
let g:gitgutter_sign_column_always = 1

" youcompleteme
nnoremap <leader>jd :YcmCompleter GoTo<CR>
let g:ycm_confirm_extra_conf = 0
