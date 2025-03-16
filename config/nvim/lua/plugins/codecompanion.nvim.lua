return {
  "olimorris/codecompanion.nvim",
  config = true,

  opts = {
    adapters = {
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          schema = {
            model = {
              default = "gpt-4o",
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "openai",
      },
      inline = {
        adapter = "openai",
      },
    },
  },

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
