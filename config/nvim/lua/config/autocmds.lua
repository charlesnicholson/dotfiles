-- Autocommands and user commands.

-- Delete items from quickfix list
local function delete_qf_items()
  local mode = vim.api.nvim_get_mode()["mode"]
  local start_idx
  local count

  if mode == "n" then -- Normal mode
    start_idx = vim.fn.line(".")
    count = vim.v.count > 0 and vim.v.count or 1
  else -- Visual mode
    local v_start_idx = vim.fn.line("v")
    local v_end_idx = vim.fn.line(".")
    start_idx = math.min(v_start_idx, v_end_idx)
    count = math.abs(v_end_idx - v_start_idx) + 1
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", false)
  end

  local qflist = vim.fn.getqflist()
  for _ = 1, count, 1 do
    table.remove(qflist, start_idx)
  end
  vim.fn.setqflist(qflist, "r")
  vim.fn.cursor(start_idx, 1)
end

-- Quickfix window adjustments and key mappings
local quickfix_group = vim.api.nvim_create_augroup("quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = quickfix_group,
  pattern = "qf",
  callback = function()
    vim.bo.buflisted = false -- Don't list quickfix in buffers.
    vim.keymap.set("n", "<ESC>", "<CMD>cclose<CR>",
      { buffer = true, silent = true, desc = "Close quickfix window" })
    vim.keymap.set({ "n", "x" }, "d", delete_qf_items,
      { buffer = true, silent = true, desc = "Delete item from quickfix" })
  end,
  desc = "Quickfix window tweaks",
})

-- Flash highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Highlight cursor row/column when entering or leaving window
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  callback = function()
    vim.wo.cursorline = true
    vim.wo.cursorcolumn = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  callback = function()
    vim.wo.cursorline = false
    vim.wo.cursorcolumn = false
  end,
})

-- Clean up terminal gutter on terminal open
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.bo.buflisted = false
    local ok, gs = pcall(require, "gitsigns")
    if ok then gs.detach() end
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

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float({ scope = "cursor", focusable = false })
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
