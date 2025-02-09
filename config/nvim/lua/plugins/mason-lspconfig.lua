return {
  {
    "williamboman/mason-lspconfig.nvim",

    config = function()
      require "mason-lspconfig".setup {
        ensure_installed = {
          "bashls",
          "clangd",
          "cmake",
          "dockerls",
          "graphql",
          "html",
          "jsonls",
          "lua_ls",
          "pyright",
          "ruff",
          "taplo",
          "ts_ls",
          "vimls",
          "yamlls",
          "zls"
        }
      }

      local caps = require "blink.cmp".get_lsp_capabilities(
        vim.lsp.protocol.make_client_capabilities())
      local util = require "lspconfig/util"

      require "mason-lspconfig".setup_handlers {
        function(server_name) -- default handler
          if server_name == "tsserver" then
            server_name = "ts_ls"
          end
          require "lspconfig"[server_name].setup { capabilities = caps }
        end,

        ["clangd"] = function()
          require "lspconfig".clangd.setup {
            capabilities = caps,
            filetypes = { "c", "cpp", "objc", "objcpp" }, -- no "proto"
          }
        end,

        ["pyright"] = function()
          require "lspconfig".pyright.setup {
            capabilities = caps,
            root_dir = function(fname)
              return util.root_pattern("pyrightconfig.json")(fname) or
                  util.find_git_ancestor(fname) or
                  util.path.dirname(fname)
            end
          }
        end,

        ["ruff"] = function()
          require "lspconfig".ruff.setup {
            capabilities = caps,
            init_options = {
              settings = {
                configuration = "~/.config/ruff.toml"
              }
            }
          }
        end,

        ["lua_ls"] = function()
          require "lspconfig".lua_ls.setup {
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

      vim.keymap.set("n", "<leader>t", ":ClangdSwitchSourceHeader<CR>")
      vim.keymap.set("n", "<leader>rs", vim.lsp.buf.rename)
      vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)
      vim.keymap.set("n", "<leader>QF", vim.lsp.buf.code_action)
      vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, {})

      vim.lsp.set_log_level("off") -- "debug" or "trace"

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { silent = true, focusable = false, relative = "cursor" }
      )

      vim.diagnostic.config { -- Hovering creates diagnostic floats
        virtual_text = false,
        update_in_insert = false,
        float = { header = false, border = "rounded", focusable = false }
      }

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        pattern = "*",
        callback = function()
          vim.diagnostic.open_float(nil, { scope = "cursor", focusable = false })
        end
      })
    end
  }
}
