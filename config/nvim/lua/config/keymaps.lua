-- Global key mappings. Buffer-local and plugin-specific maps live with their
-- respective autocmds/plugin specs.

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
  "v", "p", "\"_dP", { noremap = true, silent = true, desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "x", "\"_x",
  { noremap = true, silent = true, desc = "Delete to black hole register" })

-- Terminal mode specific key mappings
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("t", "<leader><Esc>", "<Esc>", { silent = true, desc = "Send escape to terminal" })
vim.keymap.set("t", "<S-Backspace>", "<Backspace>", { silent = true })
vim.keymap.set("t", "<S-Space>", "<Space>", { silent = true })
vim.keymap.set("t", "<C-Backspace>", "<Backspace>", { silent = true })
vim.keymap.set("t", "<C-Space>", "<Space>", { silent = true })
