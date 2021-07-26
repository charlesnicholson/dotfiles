set nocompatible

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }

Plug 'ryanoasis/vim-devicons'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'moll/vim-bbye'

Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://gn.googlesource.com/gn', { 'rtp': 'misc/vim' }

Plug 'hrsh7th/nvim-compe'
Plug 'glepnir/lspsaga.nvim'

Plug 'scrooloose/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'
call plug#end()

let mapleader = ","

filetype plugin indent on
syntax enable

if $SSH_CONNECTION
  let g:solarized_termcolors=256
  let g:solarized_termtrans=1
endif

set background=dark
colorscheme solarized

set autoindent
set autoread
set backspace=indent,eol,start
set clipboard=unnamed
set completeopt=menuone,noinsert,noselect
set directory-=.
set encoding=utf-8
set expandtab
set hidden
set ignorecase
set inccommand=nosplit
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=tab:▸\ ,trail:▫
set relativenumber
set number
set ruler
set scrolloff=3
set shiftwidth=4
set shortmess+=c
set showcmd
set signcolumn=yes
set smartcase
set softtabstop=4
set spelllang=en
set splitbelow splitright
set tabstop=4
set undofile
set updatetime=300
set visualbell
set wildignore=log/**,node_modules/**,target/**,tmp/**
set wildmenu
set wildmode=longest,list,full
set whichwrap+=<,>,h,l,[,]

" Use <Tab> and <S-Tab> to navigate through completion popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" color the gutter with solarized-dark
highlight SignColumn ctermbg=8

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

" escape clears highlighting
nnoremap <silent> <Esc> :noh<CR><Esc>

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

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },

  indent = {
    enable = false,
    disable = {},
  },

  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "dockerfile",
    "graphql",
    "html",
    "javascript",
    "json",
    "jsonc",
    "lua",
    "python",
    "scss",
    "typescript",
    "yaml",
    "zig",
  },
}
EOF

" nvim-lspinstall
lua <<EOF
local required_servers = {
  "bash",
  "cmake",
  "cpp",
  "dockerfile",
  "graphql",
  "html",
  "json",
  "lua",
  "python",
  "typescript",
  "vim",
  "yaml",
}

local installed_servers = require'lspinstall'.installed_servers()
for _, server in pairs(required_servers) do
  if not vim.tbl_contains(installed_servers, server) then
    require'lspinstall'.install_server(server)
  end
end
EOF

" lspconfig
lua <<EOF
lsp_cfg = require('lspconfig')
lsp_cfg.bashls.setup{}
--lsp_cfg.clangd.setup{}
lsp_cfg.cmake.setup{}
lsp_cfg.dockerls.setup{}
lsp_cfg.graphql.setup{}
lsp_cfg.html.setup{}
lsp_cfg.jsonls.setup{}
lsp_cfg.pyright.setup{}
lsp_cfg.tsserver.setup{}
lsp_cfg.vimls.setup{}
lsp_cfg.yamlls.setup{}
EOF

" lsp general
lua <<EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
  }
)
EOF

" nvim-compe
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.source = {
  \ 'nvim_lsp': v:true,
  \ 'treesitter': v:true,
  \ 'path': v:true,
  \ 'buffer': v:true,
  \ 'ultisnips': v:true,
  \ 'calc': v:true,
  \ }

inoremap <silent><expr> <C-Space> compe#complete()

" lspsaga
lua <<EOF
require'lspsaga'.init_lsp_saga{}
EOF

" fzf-preview
"nmap <Leader>f [fzf-p]
"xmap <Leader>f [fzf-p]
"
"nnoremap <silent> [fzf-p]d      :<C-u>FzfPreviewDirectoryFiles<CR>
"nnoremap <silent> [fzf-p]p      :<C-u>FzfPreviewProjectFiles<CR>
"nnoremap <silent> [fzf-p]g      :<C-u>FzfPreviewGitFiles<CR>
"nnoremap <silent> [fzf-p]b      :<C-u>FzfPreviewBuffers<CR>
nnoremap          <Leader>a     :<C-u>FzfPreviewProjectGrep<Space>
xnoremap          <Leader>a     "sy:FzfPreviewProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
"nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffers<CR>
"nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffers<CR>
"nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResources project_mru git<CR>
"nnoremap <silent> [fzf-p]gf    :<C-u>FzfPreviewGitFiles<CR>
"nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatus<CR>
"nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActions<CR>
"nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResources buffer project_mru<CR>
"nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumps<CR>
"nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChanges<CR>
"nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
"nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
"nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrep<Space>
"xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
"nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTags<CR>
"nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFix<CR>
"nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationList<CR>

" fzf (fuzzy completer)
nmap <leader>t :FZF<CR>

" NERDTree
nmap <leader>ntt :NERDTreeToggle<CR>
nmap <leader>ntf :NERDTreeFind<CR>
let g:NERDSpaceDelims=1

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" bbye
:nnoremap <Leader>q :Bdelete<CR>

" Rainbow
let g:rainbow_active = 1

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
  vertical resize 100
  wincmd l " code 2
  vertical resize 100
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

fun! FocusEditWindow(editWindowID)
  let l:windowID = a:editWindowID + 2
  exec(l:windowID . "wincmd w")
endfun
command! -register FocusEditWindow call FocusEditWindow(0)
