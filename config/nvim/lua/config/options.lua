-- Editor options, global variables, and providers.
-- Loaded before `lazy.setup` so `mapleader` is set before any plugin `keys` spec.

vim.filetype.add({ extension = { rl = "ragel" } })

vim.g.c_syntax_for_h = 1
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.mapleader = ","

vim.opt.clipboard = vim.fn.has("mac") == 1 and "unnamed" or "unnamedplus"
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.expandtab = true
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- cursor shapes
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "▫" }
vim.opt.number = true
vim.opt.pumheight = 20
vim.opt.relativenumber = true
vim.opt.scrollback = 100000
vim.opt.scrolloff = 3
vim.opt.shortmess:append({ c = true })
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
vim.opt.wildignore = { "node_modules/**", "__pycache__", "*.o", "*.a" }
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.whichwrap:append(
  { ["<"] = true, [">"] = true, h = true, l = true, ["["] = true, ["]"] = true })

-- Diagnostics
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = false,
  float = { header = false, border = "rounded", focusable = false },
}
