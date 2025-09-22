return {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--enable-config",
    "--fallback-style=none",
  },

  filetypes = { "c", "cpp", "objc", "objcpp" }
}
