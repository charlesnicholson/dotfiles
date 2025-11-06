return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      search = {
        enabled = false,
        multi_window = false
      },
      jump = { autojmp = false },
    },
  }
}
