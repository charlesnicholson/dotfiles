return {
  {
    "Saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },

      completion = {
        list = {
          selection = { preselect = function(ctx) return ctx.mode ~= 'cmdline' end }
        },

        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or
                not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          end,

          draw = {
            columns = {
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind" }
            },
          },
        }
      },
    }
  }
}
