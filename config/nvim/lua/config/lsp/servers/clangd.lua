return {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--enable-config",
    "--fallback-style=none",
  },

  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = require "lspconfig.util".root_pattern(".clangd", ".git"),
}
