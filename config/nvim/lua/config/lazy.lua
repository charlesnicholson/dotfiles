-- lazy bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

vim.g.c_syntax_for_h = 1
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.mapleader = ","
vim.g.python3_host_prog = 'python3.11'
vim.g.terminal_scrollback_buffer_size = 100000

vim.opt.rtp:prepend(lazypath)

--vim.opt.background = "dark"
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.clipboard = 'unnamed'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.directory['.'] = nil
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- cursor shapes
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
vim.opt.termguicolors = true
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

vim.keymap.set('v', 'p', '"_dP"', { noremap = true, silent = true })
vim.keymap.set('', 'x', '"_x', { noremap = true, silent = true })

-- terminal config
vim.keymap.set('t', '<C-[>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('t', '<S-Backspace>', '<Backspace>', { silent = true })
vim.keymap.set('t', '<S-Space>', '<Space>', { silent = true })
vim.keymap.set('t', '<C-Backspace>', '<Backspace>', { silent = true })
vim.keymap.set('t', '<C-Space>', '<Space>', { silent = true })

-- lsp
vim.keymap.set('n', '<leader>rs', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>F', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>QF', vim.lsp.buf.code_action)

-- Flash highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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

-- layout functions
vim.api.nvim_create_user_command('DesktopLayout',
  function()
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
  function()
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

-- md files are markdown
vim.cmd([[au BufRead,BufNewFile *.md set filetype=markdown]])
vim.cmd([[au BufRead,BufNewFile *.md set spell]])
vim.cmd([[au BufRead,BufNewFile *.tex set spell]])

-- lazy
require("lazy").setup({
  spec = {
    { "nvim-lua/plenary.nvim" },
    {
      "rebelot/kanagawa.nvim",
      config = function() vim.cmd.colorscheme("kanagawa") end
    },
    { "tpope/vim-unimpaired" },
    { "tpope/vim-surround" },
    { "kyazdani42/nvim-web-devicons" },
    { "onsails/lspkind.nvim" },
    { "stevearc/dressing.nvim" },
    { "luochen1990/rainbow", config = function() vim.g.rainbow_active = 1 end },
    { "chentoast/marks.nvim" },
    { "nvim-lualine/lualine.nvim",   config = true },
    { "lewis6991/gitsigns.nvim",     config = true },
    {
      "kyazdani42/nvim-tree.lua",
      opts = { view = { width = 40, preserve_window_proportions = true } }
    },
    {
      "https://gn.googlesource.com/gn",
      config = function(plugin) vim.opt.rtp:append(plugin.dir .. "misc/vim") end
    },
    { "williamboman/mason.nvim", config = true },
    { import = "plugins" },
    { "neovim/nvim-lspconfig" },
  },

  checker = { enabled = true },
})
