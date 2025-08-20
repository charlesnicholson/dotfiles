return {
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-unimpaired" },
  { "tpope/vim-surround" },
  { "neovim/nvim-lspconfig" },
  { "nvim-tree/nvim-web-devicons" },
  { "jneen/ragel.vim" },
  { "onsails/lspkind.nvim",       config = true },
  { "stevearc/quicker.nvim",      config = true },
  { "chentoast/marks.nvim",       config = true },
  { "nvim-lualine/lualine.nvim",  config = true },
  { "lewis6991/gitsigns.nvim",    config = true },
  { "mason-org/mason.nvim",       config = true },
  {
    -- The clean module path for require()
    "plugins.local.puml_viewer",

    -- The essential key to specify it's a local plugin
    dir = vim.fn.stdpath('config') .. "/lua/plugins/local/puml_viewer",

    -- The config function to run the setup
    config = function()
      require("plugins.local.puml_viewer").setup()
    end,
  }
}
