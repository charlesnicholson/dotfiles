set nocompatible

let g:python_host_prog='/usr/bin/python'

filetype off
call plug#begin('~/.vim/plugged')
Plug 'Shougo/deoplete.nvim'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-obsession'
Plug 'rking/ag.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'tpope/vim-unimpaired'
Plug 'moll/vim-bbye'
Plug 'vim-scripts/a.vim'
Plug 'junegunn/fzf'
Plug 'justinmk/vim-syntax-extra'
Plug 'idbrii/vim-focusclip'
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
nnoremap j gj
nnoremap k gk

" fzf (fuzzy completer)
nmap <leader>t :FZF<CR>

" NERDTree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
let g:NERDSpaceDelims=1
let g:ctrlp_match_window = 'order:ttb,max:20'

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
"set noshowmode

" bbye
:nnoremap <Leader>q :Bdelete<CR>

" Semantic highlight
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,125,124,19]
let g:semanticEnableFileTypes = ["c", "python", "cpp"]
let g:semanticBlacklistOverride = {'c': ['define', 'class', 'std', 'auto', 'template', 'decltype', 'typedef', 'struct', 'enum', 'for', 'if', 'static', 'void']}

" Rainbow
let g:rainbow_active = 1

" Deoplete
let g:deoplete#enable_at_startup = 1
