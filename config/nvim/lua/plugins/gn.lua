return {
  {
    "https://gn.googlesource.com/gn",
    branch = "main",
    lazy = false,
    ft = "gn",
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/misc/vim")
      require("lazy.core.loader").packadd(plugin.dir .. "/misc/vim")
    end,
    init = function(plugin)
      require("lazy.core.loader").ftdetect(plugin.dir .. "/misc/vim")
    end,
  }
}
