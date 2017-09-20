set nocompatible

let atgoogle = isdirectory("/usr/share/vim/google")
if atgoogle
    source ~/.config/nvim/google.vim
endif

call plug#begin('~/.local/share/nvim/plugged')
if (!atgoogle)
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
endif
Plug 'luochen1990/rainbow'
Plug 'mileszs/ack.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
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

if $SSH_CONNECTION
  let g:solarized_termcolors=256
  let g:solarized_termtrans=1
endif

set background=dark
colorscheme solarized
let mapleader = ","

set autoindent
set autoread
set backspace=indent,eol,start
set visualbell
set backup
set clipboard=unnamed
set directory-=.
set encoding=utf-8
set expandtab
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:▸\ ,trail:▫
set relativenumber
set number
set ruler
set scrolloff=3
set shiftwidth=4
set splitbelow splitright
set showcmd
set smartcase
set undofile
set softtabstop=4
set tabstop=4
set wildignore=log/**,node_modules/**,target/**,tmp/**
set wildmenu
set wildmode=longest,list,full
set whichwrap+=<,>,h,l,[,]
set inccommand=nosplit
set lazyredraw

au Filetype typescript setlocal ts=2 sw=2 expandtab

" j and k navigate wrapped lines
noremap j gj
noremap k gk

" relative number jumps work with wrapped lines
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
vnoremap <expr> j v:count == 0 ? 'gj' : 'j'
vnoremap <expr> k v:count == 0 ? 'gk' : 'k'

" navigate splits with C-hjkl
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" cursor shapes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" highlight cursor row/column
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" terminal config
"au BufWinEnter,BufEnter,WinEnter * if &buftype == 'terminal' | :startinsert | endif
let g:terminal_scrollback_buffer_size = 100000
au TermOpen * set nobuflisted
tnoremap <Esc> <C-\><C-n>

" md files are markdown
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.md set spell
au BufRead,BufNewFile *.tex set spell

" remove all trailing whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
    let @/=s
endfun
au BufWritePre * :call <SID>StripTrailingWhitespaces()

vnoremap p "_dP
noremap x "_x

" escape clears highlighting and re-renders syntax highlighting
nnoremap <silent> <Esc> :noh<CR>:syntax sync fromstart<CR><Esc>

" fzf (fuzzy completer)
nmap <leader>t :FZF<CR>

" NERDTree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
let g:NERDSpaceDelims=1
let g:ctrlp_match_window = 'order:ttb,max:20'

" ack
nmap <leader>a :Ack<space>
let g:ackprg = 'ag --vimgrep --smart-case'

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" bbye
:nnoremap <Leader>q :Bdelete<CR>

" Rainbow
let g:rainbow_active = 1

" vim-gitgutter
set signcolumn=yes
" color the gutter with solarized-dark
highlight SignColumn ctermbg=8

" youcompleteme
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
let g:ycm_confirm_extra_conf = 0
if !exists("g:ycm_semantic_triggers")
   let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

fun! DesktopLayout()
  vsp " code 2
  vsp " terminal 1
  terminal
  sp " terminal 2
  terminal
  sp " terminal 3
  terminal
  NERDTree
  wincmd l " code 1
  vertical resize 90
  wincmd l " code 2
  vertical resize 90
  stopinsert
endfun
command! -register DesktopLayout call DesktopLayout()

fun! LaptopLayout()
  vsp " terminal 1
  terminal
  sp " terminal 2
  terminal
  NERDTree
  wincmd l " code 1
  vertical resize 90
  stopinsert
endfun
command! -register LaptopLayout call LaptopLayout()
