return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      search = {
        enabled = true,
        multi_window = false
      },
      jump = { autojmp = false },
    },
  }
}
