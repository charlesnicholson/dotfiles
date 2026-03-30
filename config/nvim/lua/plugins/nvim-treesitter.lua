return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "dockerfile",
        "gn",
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
    })
  end
}
