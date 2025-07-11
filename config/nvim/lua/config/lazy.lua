require("config.python_venv").setup()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

vim.opt.rtp:prepend(lazypath)

-- Basic global settings
vim.g.c_syntax_for_h = 1
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.mapleader = ","
-- FIX: Removed hardcoded python version (vim.g.python3_host_prog).
-- Neovim is excellent at auto-detecting a valid python3 host.
-- FIX: Removed g.terminal_scrollback_buffer_size; it's redundant with vim.opt.scrollback.

-- Set various Neovim options
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.clipboard = "unnamed"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.expandtab = true
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- cursor shapes
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "▫" }
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
vim.opt.wildignore = { "node_modules/**", "__pycache__", "*.o", "*.a" }
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.whichwrap:append(
  { ["<"] = true, [">"] = true, h = true, l = true, ["["] = true, ["]"] = true })

-- Conditional navigation for wrapped lines
vim.keymap.set({ "n", "v" }, "j", function()
  return vim.v.count > 0 and "j" or "gj"
end, { expr = true, silent = true, desc = "Move down (handles wrapped lines)" })
vim.keymap.set({ "n", "v" }, "k", function()
  return vim.v.count > 0 and "k" or "gk"
end, { expr = true, silent = true, desc = "Move up (handles wrapped lines)" })

-- Key mappings for navigating between splits
vim.keymap.set(
  "n", "<C-j>", "<C-w>j", { silent = true, noremap = true, desc = "Move to split below" })
vim.keymap.set(
  "n", "<C-k>", "<C-w>k", { silent = true, noremap = true, desc = "Move to split above" })
vim.keymap.set(
  "n", "<C-h>", "<C-w>h", { silent = true, noremap = true, desc = "Move to split left" })
vim.keymap.set(
  "n", "<C-l>", "<C-w>l", { silent = true, noremap = true, desc = "Move to split right" })

-- Clear search buffer with double-escape
vim.keymap.set(
  "n", "<Esc><Esc>", ":let @/ = \"\"<CR>", { silent = true, desc = "Clear search pattern" })

-- Toggle highlighting with space
vim.keymap.set(
  "n", "<Space>", ":set hlsearch!<CR>", { silent = true, desc = "Toggle search highlight" })

-- Overwrite default paste behavior in visual mode
vim.keymap.set(
  "v", "p", "\"_dP\"", { noremap = true, silent = true, desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "x", "\"_x",
  { noremap = true, silent = true, desc = "Delete to black hole register" })

-- Terminal mode specific key mappings
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("t", "<S-Backspace>", "<Backspace>", { silent = true })
vim.keymap.set("t", "<S-Space>", "<Space>", { silent = true })
vim.keymap.set("t", "<C-Backspace>", "<Backspace>", { silent = true })
vim.keymap.set("t", "<C-Space>", "<Space>", { silent = true })

-- Delete items from quickfix list
local function delete_qf_items()
  local mode = vim.api.nvim_get_mode()['mode']
  local start_idx
  local count

  if mode == 'n' then -- Normal mode
    start_idx = vim.fn.line('.')
    count = vim.v.count > 0 and vim.v.count or 1
  else -- Visual mode
    local v_start_idx = vim.fn.line('v')
    local v_end_idx = vim.fn.line('.')
    start_idx = math.min(v_start_idx, v_end_idx)
    count = math.abs(v_end_idx - v_start_idx) + 1
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', false)
  end

  local qflist = vim.fn.getqflist()
  for _ = 1, count, 1 do
    table.remove(qflist, start_idx)
  end
  vim.fn.setqflist(qflist, 'r')
  vim.fn.cursor(start_idx, 1)
end

-- Quickfix window adjustments and key mappings
local quickfix_group = vim.api.nvim_create_augroup('quickfix', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = quickfix_group,
  pattern = 'qf',
  callback = function()
    vim.bo.buflisted = false -- Don't list quickfix in buffers.
    vim.keymap.set('n', '<ESC>', '<CMD>cclose<CR>',
      { buffer = true, silent = true, desc = "Close quickfix window" })
    vim.keymap.set({ 'n', 'x' }, 'd', delete_qf_items,
      { buffer = true, silent = true, desc = "Delete item from quickfix" })
  end,
  desc = 'Quickfix window tweaks',
})

-- Flash highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Highlight cursor row/column when entering or leaving window
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = true
    vim.opt.cursorcolumn = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = false
    vim.opt.cursorcolumn = false
  end,
})

-- Clean up terminal gutter on terminal open
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.bo.buflisted = false
    vim.cmd("Gitsigns detach")
  end,
})

local ft_group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = ft_group,
  pattern = { "*.md", "*.tex" },
  callback = function()
    vim.opt_local.spell = true
  end,
  desc = "Enable spell check for Markdown and TeX",
})

-- Diagnostic configuration
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = false,
  float = { header = false, border = "rounded", focusable = false }
}

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor", focusable = false })
  end,
})

-- Define custom layout commands
vim.api.nvim_create_user_command("DesktopLayout", function()
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
end, {})

vim.api.nvim_create_user_command("LaptopLayout", function()
  vim.cmd([[vsp]])
  vim.cmd([[terminal]])
  vim.cmd([[sp]])
  vim.cmd([[terminal]])
  vim.cmd([[NvimTreeOpen]])
  vim.cmd([[wincmd l]])
  vim.cmd([[vertical resize 100]])
  vim.cmd([[stopinsert]])
end, {})

-- Configure lazy plugin manager
require("lazy").setup({
  spec = { { import = "plugins" } },
  change_detection = { notify = false },
  checker = { enabled = true, notify = false },
})
