set nocompatible

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
  autocmd VimEnter * PlugUpgrade
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'phaazon/hop.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'rebelot/kanagawa.nvim'

Plug 'kyazdani42/nvim-tree.lua'
Plug 'romgrk/barbar.nvim'
Plug 'nvim-lualine/lualine.nvim'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://gn.googlesource.com/gn', { 'rtp': 'misc/vim' }

Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-live-grep-args.nvim'

Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'ray-x/cmp-treesitter'
Plug 'hrsh7th/nvim-cmp'

Plug 'luochen1990/rainbow'
Plug 'kshenoy/vim-signature'
Plug 'lewis6991/gitsigns.nvim'
call plug#end()

let mapleader = ","

filetype plugin indent on
syntax enable

set termguicolors
set background=dark
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
set mouse=
set number
set relativenumber
set ruler
set scrollback=100000
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

let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

let g:python3_host_prog = 'python3.11'
let g:rainbow_active = 1

au Filetype c,c++,python setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
au Filetype typescript setlocal ts=2 sw=2 expandtab

au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen * :Gitsigns detach

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

" double-esc clears the search buffer
nnoremap <silent> <Esc><Esc> :let @/ = ""<CR>
" space toggles highlighting
nnoremap <silent> <Space> :set hlsearch!<CR>

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
tnoremap <C-[> <C-\><C-n>
tnoremap <S-Backspace> <Backspace>
tnoremap <S-Space> <Space>
tnoremap <C-Backspace> <Backspace>
tnoremap <C-Space> <Space>

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

colorscheme kanagawa

" barbar
nnoremap <Leader>q :BufferClose<CR>
nnoremap <Leader>Q :BufferDelete!<CR>
nnoremap <leader>bp :BufferPick<CR>
" steal back from vim-unimpaired for tab navigation
nnoremap [b :BufferPrevious<CR>
nnoremap ]b :BufferNext<CR>

" disable LSP logging (it gets huge)
lua vim.lsp.set_log_level("off") -- "debug" or "trace"

lua require'lualine'.setup()
lua require'gitsigns'.setup()

" nvim-tree
lua <<EOF
require'nvim-tree'.setup{
  view = {
    width = 40,
    preserve_window_proportions = true
  },
}
EOF
nmap <leader>lf :NvimTreeFindFile<CR>

" telescope
lua <<EOF
telescope = require'telescope'
local actions = require'telescope.actions'
telescope.setup{
  defaults = {
    mappings = { n = { ["<C-[>"] = actions.close, } }
  },

  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  },

  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
      layout_config = {
        height = 0.7,
        width = 0.4,
      }
    }
  }
}
require'telescope'.load_extension('fzf')
require'telescope'.load_extension('live_grep_args')
EOF

nmap <leader>f :Telescope find_files<CR>
nmap <leader>a :lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>
nmap <leader>jd :lua require'telescope.builtin'.lsp_definitions()<CR>
nmap <leader>js :lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<CR>
nmap <leader>jr :lua require'telescope.builtin'.lsp_references()<CR>
nmap <leader>jb :e#<CR>

" null-ls
lua <<EOF
null_ls = require'null-ls'
null_ls.setup{
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.clang_format,
  }
}
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

" lsp
lua <<EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false }
)
EOF

" nvim-cmp
lua <<EOF
local lspkind = require'lspkind'
local cmp = require'cmp'

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  formatting = { format = lspkind.cmp_format({ mode = 'symbol' }) },

  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
EOF

lua << EOF
require('mason').setup()
require('mason-lspconfig').setup{
  ensure_installed = {
    'bashls',
    'clangd',
    'cmake',
    'dockerls',
    'graphql',
    'html',
    'jsonls',
    'lua_ls',
    'pyright',
    'taplo',
    'tsserver',
    'vimls',
    'yamlls',
    'zls'
  }
}

local caps = require'cmp_nvim_lsp'.default_capabilities()
local util = require("lspconfig/util")

require'mason-lspconfig'.setup_handlers{
    function (server_name) -- default handler (optional)
        require'lspconfig'[server_name].setup{capabilities = caps}
    end,

    ['clangd'] = function()
        require'lspconfig'.clangd.setup{
          capabilities = caps,
          filetypes = { "c", "cpp", "objc", "objcpp" }, -- no "proto"
          handlers = {
            ['textDocument/publishDiagnostics'] = vim.lsp.with(
              vim.lsp.diagnostic.on_publish_diagnostics, {
                signs = true, -- false,
                underline = true, -- false,
                update_in_insert = false,
                virtual_text = true, -- false,
              }
            ),
          }
        }
      end,

    ['pyright'] = function()
        require'lspconfig'.pyright.setup{
          root_dir = function(...)
              return util.root_pattern('pyrightconfig.json')(...)
          end
        }
      end
}
EOF

autocmd VimEnter * MasonUpdate

nmap <leader>rs :lua vim.lsp.buf.rename()<CR>
nmap <leader>F :lua vim.lsp.buf.format()<CR>
nmap <leader>t :ClangdSwitchSourceHeader<CR>


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
