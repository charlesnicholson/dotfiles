return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = {
        enable = true,
        disable = {},
      },

      indent = {
        enable = true,
        disable = {},
      },

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
    }
  }
}
