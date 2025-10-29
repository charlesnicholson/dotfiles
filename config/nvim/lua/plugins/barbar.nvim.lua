return {
  "romgrk/barbar.nvim",

  config = function()
    require "barbar".setup {}

    vim.keymap.set("n", "<Leader>q", "<Cmd>BufferClose<CR>",
      { noremap = true, silent = true })
    vim.keymap.set("n", "<Leader>Q", "<Cmd>BufferDelete!<CR>",
      { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPick<CR>",
      { noremap = true, silent = true })
    vim.keymap.set("n", "[b", ":BufferPrevious<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "]b", ":BufferNext<CR>", { noremap = true, silent = true })
  end,
}
