return {
  { "williamboman/mason-lspconfig.nvim",
    config = function(self, ops)
      require('mason-lspconfig').setup {
        ensure_installed = {
          'bashls',
          'clangd',
          'cmake',
          'dockerls',
          'graphql',
          'html',
          'jsonls',
          'lua_ls',
          'pyright',
          'ruff',
          'taplo',
          'ts_ls',
          'vimls',
          'yamlls',
          'zls'
        }
      }

      local caps = require 'blink.cmp'.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
      local util = require("lspconfig/util")

      require 'mason-lspconfig'.setup_handlers {
        function(server_name) -- default handler (optional)
          if server_name == "tsserver" then
            server_name = "ts_ls"
          end
          require 'lspconfig'[server_name].setup { capabilities = caps }
        end,

        ['clangd'] = function()
          require 'lspconfig'.clangd.setup {
            capabilities = caps,
            filetypes = { "c", "cpp", "objc", "objcpp" }, -- no "proto"
            handlers = {
              ['textDocument/publishDiagnostics'] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                  signs = true,         -- false,
                  underline = true,     -- false,
                  update_in_insert = false,
                  virtual_text = false, -- true, -- false,
                }
              ),
            }
          }
        end,

        ['pyright'] = function()
          require 'lspconfig'.pyright.setup {
            capabilities = caps,
            root_dir = function(fname)
              return util.root_pattern("pyrightconfig.json")(fname) or util.find_git_ancestor(fname) or
                  util.path.dirname(fname)
            end
          }
        end,

        ['ruff'] = function()
          require 'lspconfig'.ruff.setup {
            capabilities = caps,
            init_options = {
              settings = {
                args = { '--target-version', 'py311' },
              }
            }
          }
        end,

        ['lua_ls'] = function()
          require 'lspconfig'.lua_ls.setup {
            capabilities = caps,
            settings = {
              Lua = {
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                    max_line_length = "90",
                  },
                },
                diagnostics = {
                  globals = { "vim" }
                }
              },
            },
          }
        end
      }

      vim.keymap.set('n', '<leader>t', ':ClangdSwitchSourceHeader<CR>')
    end
  }
}
