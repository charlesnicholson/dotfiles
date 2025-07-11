return {
  "nvim-tree/nvim-tree.lua",

  config = function()
    require "nvim-tree".setup {
      view = { width = 40, preserve_window_proportions = true },
      actions = { remove_file = { close_window = false } },
    }
    vim.keymap.set("n", "<leader>lf", ":NvimTreeFindFile<CR>", { silent = true })
  end
}
