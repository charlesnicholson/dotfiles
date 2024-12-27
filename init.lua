local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')

Plug 'folke/neodev.nvim'
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

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('https://gn.googlesource.com/gn', { rtp = 'misc/vim' })

Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
Plug 'nvim-telescope/telescope-live-grep-args.nvim'

Plug 'stevearc/dressing.nvim'

Plug('Saghen/blink.cmp', { tag = 'v*' })

Plug 'luochen1990/rainbow'
Plug 'chentoast/marks.nvim'
Plug 'lewis6991/gitsigns.nvim'
vim.call('plug#end')

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = { "*" },
  command = "PlugUpgrade"
})

vim.g.mapleader = ","
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.python3_host_prog = 'python3.11'
vim.g.rainbow_active = 1
vim.g.c_syntax_for_h = 1

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.clipboard = 'unnamed'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.directory['.'] = nil
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '▫' }
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.pumheight = 20
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.scrolloff = 3
vim.opt.shortmess:append({ c = true })
vim.opt.showcmd = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelllang = "en"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.visualbell = true
vim.opt.wildignore = { 'node_modules/**', '__pycache__', '*.o', '*.a' }
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest', 'list', 'full' }
vim.opt.whichwrap:append({
  ['<'] = true,
  ['>'] = true,
  h = true,
  l = true,
  ['['] = true,
  [']'] = true
})

vim.cmd.colorscheme('kanagawa')

-- highlight text yank
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 150, on_visual = true }
  end,
})

-- j and k navigate wrapped lines
vim.keymap.set('', 'j', 'gj', { silent = true, noremap = true })
vim.keymap.set('', 'k', 'gk', { silent = true, noremap = true })

-- relative number jumps work with wrapped lines
vim.keymap.set({ 'n', 'v' }, 'j', function() return vim.v.count > 0 and 'j' or 'gj' end,
  { noremap = true, expr = true })
vim.keymap.set({ 'n', 'v' }, 'k', function() return vim.v.count > 0 and 'k' or 'gk' end,
  { noremap = true, expr = true })

-- navigate splits with C-hjkl
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true, noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true, noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true, noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true, noremap = true })

-- double-esc clears the search buffer
vim.keymap.set('n', '<Esc><Esc>', ':let @/ = ""<CR>', { silent = true })

-- space toggles highlighting
vim.keymap.set('n', '<Space>', ':set hlsearch!<CR>', { silent = true })

-- cursor shapes
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- highlight cursor row/column
vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  callback = function()
    vim.opt.cursorline = true
    vim.opt.cursorcolumn = true
  end
})

vim.api.nvim_create_autocmd('WinLeave', {
  pattern = '*',
  callback = function()
    vim.opt.cursorline = false
    vim.opt.cursorcolumn = false
  end
})

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- terminal config
vim.g.terminal_scrollback_buffer_size = 100000
vim.keymap.set('t', '<C-[>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('t', '<S-Backspace>', '<Backspace>', { silent = true })
vim.keymap.set('t', '<S-Space>', '<Space>', { silent = true })
vim.keymap.set('t', '<C-Backspace>', '<Backspace>', { silent = true })
vim.keymap.set('t', '<C-Space>', '<Space>', { silent = true })

-- clean up terminal gutter
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.bo.buflisted = false
    vim.cmd("Gitsigns detach")
  end,
})


-- md files are markdown
vim.cmd([[au BufRead,BufNewFile *.md set filetype=markdown]])
vim.cmd([[au BufRead,BufNewFile *.md set spell]])
vim.cmd([[au BufRead,BufNewFile *.tex set spell]])

vim.keymap.set('v', 'p', '"_dP"', { noremap = true, silent = true })
vim.keymap.set('', 'x', '"_x', { noremap = true, silent = true })

-- marks
require 'marks'.setup {}

-- barbar
vim.keymap.set('n', '<Leader>q', '<Cmd>BufferClose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>Q', '<Cmd>BufferDelete!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPick<CR>', { noremap = true, silent = true })

-- steal back from vim-unimpaired for tab navigation
vim.keymap.set('n', '[b', ':BufferPrevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', ']b', ':BufferNext<CR>', { noremap = true, silent = true })

-- disable LSP logging (it gets huge)
vim.lsp.set_log_level("off") -- "debug" or "trace"

require 'neodev'.setup { pathStrict = false }
require 'lualine'.setup()
require 'gitsigns'.setup()

-- nvim-tree
require 'nvim-tree'.setup {
  view = { width = 40, preserve_window_proportions = true }
}

vim.keymap.set('n', '<leader>lf', ':NvimTreeFindFile<CR>', { silent = true })

-- lsp
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { silent = true, focusable = false, relative = "cursor" }
)

-- Hovering creates diagnostic floats
vim.diagnostic.config {
  virtual_text = false,
  float = { header = false, border = 'rounded', focusable = false, }
}

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  callback = function()
    vim.diagnostic.open_float(nil, { scope = 'cursor' })
  end
})

vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, {})

-- telescope
local telescope = require 'telescope'
local actions = require 'telescope.actions'
telescope.setup {
  defaults = {
    mappings = { n = { ["<C-[>"] = actions.close, } }
  },

  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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

require 'telescope'.load_extension('fzf')
require 'telescope'.load_extension('live_grep_args')

vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>', { silent = true })
vim.keymap.set('n', '<leader>a',
  function() require 'telescope'.extensions.live_grep_args.live_grep_args() end,
  { silent = true })
vim.keymap.set('n', '<leader>jd',
  function() require 'telescope.builtin'.lsp_definitions() end,
  { silent = true })

vim.keymap.set('n', '<leader>js',
  function()
    require 'telescope.builtin'.lsp_workspace_symbols({ fname_width = 0.5, symbol_width = 0.4, symbol_type_width = 0.1 })
  end,
  { silent = true })

vim.keymap.set('n', '<leader>jr',
  function() require 'telescope.builtin'.lsp_references() end,
  { silent = true })

vim.keymap.set('n', '<leader>jb', ':e#<CR>', { silent = true })

-- hop
require 'hop'.setup {}
vim.keymap.set('n', 'f',
  function()
    require 'hop'.hint_char1({
      direction = require 'hop.hint'.HintDirection.AFTER_CURSOR,
      current_line_only = true
    })
  end,
  {})
vim.keymap.set('n', 'F',
  function()
    require 'hop'.hint_char1({
      direction = require 'hop.hint'.HintDirection.BEFORE_CURSOR,
      current_line_only = true
    })
  end,
  {})
vim.keymap.set('n', '<Leader>h', "<cmd>:HopChar1<cr>", {})

-- treesitter
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },

  indent = {
    enable = true,
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

require('mason').setup()
require('mason-lspconfig').setup {
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
    'ruff',
    'taplo',
    'ts_ls',
    'vimls',
    'yamlls',
    'zls'
  }
}

local util = require("lspconfig/util")

require 'blink.cmp'.setup {
  keymap = {
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  },

  completion = {
    list = { selection = "auto_insert" },
    menu = {
      draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } }, },
      auto_show = function(ctx) return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' end
    }
  }
}

local caps = require 'blink.cmp'.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

require 'mason-lspconfig'.setup_handlers {
  function(server_name) -- default handler (optional)
    if server_name == "tsserver" then
      server_name = "ts_ls"
    end
    require 'lspconfig'[server_name].setup { capabilities = caps }
  end,

  ['clangd'] = function()
    require 'lspconfig'.clangd.setup {
      capabilities = caps,
      filetypes = { "c", "cpp", "objc", "objcpp" }, -- no "proto"
      handlers = {
        ['textDocument/publishDiagnostics'] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            signs = true,         -- false,
            underline = true,     -- false,
            update_in_insert = false,
            virtual_text = false, -- true, -- false,
          }
        ),
      }
    }
  end,

  ['pyright'] = function()
    require 'lspconfig'.pyright.setup {
      capabilities = caps,
      root_dir = function(fname)
        return util.root_pattern("pyrightconfig.json")(fname) or util.find_git_ancestor(fname) or
            util.path.dirname(fname)
      end
    }
  end,

  ['ruff'] = function()
    require 'lspconfig'.ruff.setup {
      capabilities = caps,
      init_options = {
        settings = {
          args = { '--target-version', 'py311' },
        }
      }
    }
  end,

  ['lua_ls'] = function()
    require 'lspconfig'.lua_ls.setup {
      capabilities = caps,
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
              max_line_length = "90",
            },
          },
          diagnostics = {
            globals = { "vim" }
          }
        },
      },
    }
  end
}

vim.keymap.set('n', '<leader>rs', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>F', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>QF', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>t', ':ClangdSwitchSourceHeader<CR>')


vim.api.nvim_create_user_command('DesktopLayout',
  function(opts)
    vim.cmd([[vsp]])
    vim.cmd([[vsp]])
    vim.cmd([[terminal]])
    vim.cmd([[sp]])
    vim.cmd([[terminal]])
    vim.cmd([[sp]])
    vim.cmd([[terminal]])
    vim.cmd([[NvimTreeOpen]])
    vim.cmd([[wincmd l]])
    vim.cmd([[vertical resize 100]])
    vim.cmd([[wincmd l]])
    vim.cmd([[vertical resize 100]])
    vim.cmd([[stopinsert]])
  end,
  {})

vim.api.nvim_create_user_command('LaptopLayout',
  function(opts)
    vim.cmd([[vsp]])
    vim.cmd([[terminal]])
    vim.cmd([[sp]])
    vim.cmd([[terminal]])
    vim.cmd([[NvimTreeOpen]])
    vim.cmd([[wincmd l]])
    vim.cmd([[vertical resize 100]])
    vim.cmd([[stopinsert]])
  end,
  {})
