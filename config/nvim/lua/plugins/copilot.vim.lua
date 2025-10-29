return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_enabled = false
    vim.keymap.set("i", "<C-p>", "<Plug>(copilot-suggest)",
      { noremap = false, silent = true })
  end
}
