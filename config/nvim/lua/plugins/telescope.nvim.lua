return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",

    config = function()
      require "telescope".setup {
        defaults = {
          mappings = { n = { ["<C-[>"] = require "telescope.actions".close, } }
        },

        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          }
        },

        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            layout_config = {
              height = 0.7,
              width = 0.4,
            }
          }
        }
      }

      require "telescope".load_extension("fzf")
      require "telescope".load_extension("live_grep_args")

      vim.keymap.set(
        'n', '<leader>f', require "telescope.builtin".find_files, { silent = true })

      vim.keymap.set("n", "<leader>a",
        function() require "telescope".extensions.live_grep_args.live_grep_args() end,
        { silent = true })

      vim.keymap.set("n", "<leader>js",
        function()
          require "telescope.builtin".lsp_workspace_symbols({
            fname_width = 0.5,
            symbol_width = 0.4,
            symbol_type_width = 0.1
          })
        end,
        { silent = true })

      vim.keymap.set("n", "<leader>jr",
        function() require "telescope.builtin".lsp_references() end,
        { silent = true })

      vim.keymap.set("n", "<leader>jq",
        function() require "telescope.builtin".quickfix() end,
        { silent = true })
    end,
  },

  { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
}
