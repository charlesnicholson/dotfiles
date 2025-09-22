return {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--enable-config",
    "--fallback-style=none",
  },

  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = function(fname)
    return vim.fs.root(fname, { ".clangd", ".git" })
  end,
}
