return {
  {
    "https://gn.googlesource.com/gn",
    cond = function(plugin) -- https://github.com/folke/lazy.nvim/issues/1319
      plugin.dir = plugin.dir .. "/misc/vim"
      return true
    end,
  },
}
