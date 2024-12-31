return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'

      telescope.setup {
        defaults = {
          mappings = { n = { ["<C-[>"] = actions.close, } }
        },

        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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

      require 'telescope'.load_extension('fzf')
      require 'telescope'.load_extension('live_grep_args')

      vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>', { silent = true })
      vim.keymap.set('n', '<leader>a',
        function() require 'telescope'.extensions.live_grep_args.live_grep_args() end,
        { silent = true })
      vim.keymap.set('n', '<leader>jd',
        function() require 'telescope.builtin'.lsp_definitions() end,
        { silent = true })

      vim.keymap.set('n', '<leader>js',
        function()
          require 'telescope.builtin'.lsp_workspace_symbols({ fname_width = 0.5, symbol_width = 0.4, symbol_type_width = 0.1 })
        end,
        { silent = true })

      vim.keymap.set('n', '<leader>jr',
        function() require 'telescope.builtin'.lsp_references() end,
        { silent = true })

      vim.keymap.set('n', '<leader>jb', ':e#<CR>', { silent = true })


    end,
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
  },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
}
