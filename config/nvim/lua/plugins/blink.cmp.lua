return {
  { "Saghen/blink.cmp",
    version = "0.8.2",
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
        list = { selection = "auto_insert" },
        menu = {
          draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } }, },
          auto_show = function() return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' end
        }
      }
    }
  }
}

