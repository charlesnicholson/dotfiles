set nocompatible

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'phaazon/hop.nvim'

Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lifepillar/vim-solarized8'

Plug 'kyazdani42/nvim-tree.lua'
Plug 'romgrk/barbar.nvim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'onsails/lspkind.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://gn.googlesource.com/gn', { 'rtp': 'misc/vim' }

Plug 'nvim-telescope/telescope.nvim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'ray-x/cmp-treesitter'

Plug 'luochen1990/rainbow'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'
call plug#end()

let mapleader = ","

filetype plugin indent on
syntax enable

set termguicolors
set background=dark
colorscheme solarized8

set autoindent
set autoread
set backspace=indent,eol,start
set clipboard=unnamed
set completeopt=menu,menuone,noselect
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

au Filetype c,c++ setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
au Filetype typescript setlocal ts=2 sw=2 expandtab

" Highlight text on yank
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

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

" barbar
nnoremap <Leader>q :BufferClose<CR>
nnoremap <leader>bp :BufferPick<CR>
" steal back from vim-unimpaired for tab navigation
nnoremap [b :BufferPrevious<CR>
nnoremap ]b :BufferNext<CR>

" nvim-tree
lua <<EOF
require'nvim-tree'.setup{ view = { width = 40 } }
EOF
" (l)ocate (f)ile
nmap <leader>lf :NvimTreeFindFile<CR>


" telescope
lua <<EOF
require'telescope'.setup{}
EOF

" hop
lua <<EOF
require'hop'.setup()
vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('n', '<Leader>h', "<cmd>:HopChar1<cr>", {})
EOF

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

" lspconfig
lua <<EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false }
)
EOF

" nvim-cmp
lua <<EOF
local lspkind = require'lspkind'
lspkind.setup{}

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        print(entry.source.name)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          buffer = "[BUF]",
          treesitter = "[TS]",
          path = "[PATH]",
        })[entry.source.name]
        return vim_item
      end
    })
  },

  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'treesitter' },
    { name = 'vsnip' },
    { name = 'calc' },
    { name = 'buffer' },
    { name = 'path' }
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

EOF

" lsp-installer
lua <<EOF
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {}

  opts.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  if server.name == "clangd" then
      opts.handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            signs = false,
            underline = false,
            update_in_insert = false,
            virtual_text = false,
          }
        ),
      }
  end

  server:setup(opts)
end)
EOF

" telescope
nmap <leader>t :Telescope find_files<CR>
nmap <leader>a :Telescope live_grep<CR>

" airline
let g:airline_powerline_fonts = 1

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
  NvimTreeOpen
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
  NvimTreeOpen
  wincmd l " code 1
  vertical resize 100
  stopinsert
endfun
command! -register LaptopLayout call LaptopLayout()

fun! FocusEditWindow(editWindowID)
  let l:windowID = a:editWindowID + 2
  exec(l:windowID . "wincmd w")
endfun
command! -register FocusEditWindow call FocusEditWindow(0)
