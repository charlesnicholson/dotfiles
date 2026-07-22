return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    -- Parsers to keep installed. `install` is async and a no-op for parsers
    -- that are already present, so it doubles as fresh-machine bootstrap.
    ts.install({
      "bash",
      "c",
      "cmake",
      "cpp",
      "dockerfile",
      "gn",
      "graphql",
      "html",
      "javascript",
      "json", -- jsonc filetype maps to the json parser; no separate jsonc parser
      "lua",
      "python",
      "scss",
      "typescript",
      "yaml",
      "zig",
    })

    -- Set of parsers nvim-treesitter can actually build. Used to skip plugin UI
    -- buffers (mason, lazy, ...) whose filetype is not a real language, which
    -- would otherwise warn "skipping unsupported language".
    local available = {}
    for _, lang in ipairs(ts.get_available()) do
      available[lang] = true
    end

    -- The `main` branch does not auto-enable highlighting or auto-install the
    -- way the old `master` branch's `highlight`/`auto_install` options did.
    -- Do it here: on every buffer, start treesitter highlighting if the parser
    -- is present, otherwise install it and start once it lands.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local buf = ev.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang or not available[lang] then
          return
        end
        if pcall(vim.treesitter.start, buf, lang) then
          return
        end
        ts.install(lang):await(function()
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              pcall(vim.treesitter.start, buf, lang)
            end
          end)
        end)
      end,
    })
  end,
}
