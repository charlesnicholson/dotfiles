return {
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
        globals = { "vim" },
      },
    },
  },
}

