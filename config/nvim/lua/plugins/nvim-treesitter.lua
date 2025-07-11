return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require "nvim-treesitter.configs".setup({
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

      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
