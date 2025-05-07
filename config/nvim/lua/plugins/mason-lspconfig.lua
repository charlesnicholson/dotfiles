return {
  {
    "mason-org/mason-lspconfig.nvim",

    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "Saghen/blink.cmp",
    },

    config = function()
      require "mason-lspconfig".setup { ensure_installed = require "config.lsp.servers" }
      require "config.lsp" -- This loads all of the per-server details
    end
  }
}
