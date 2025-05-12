for _, server in ipairs(require "mason-lspconfig".get_installed_servers()) do
  local ok, server_opts = pcall(require, "config.lsp.servers." .. server)
  local opts = ok and server_opts or {}
  require "lspconfig"[server].setup(opts)
end

vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<leader>rs", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>QF", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>t", function() vim.cmd("ClangdSwitchSourceHeader") end)

vim.lsp.set_log_level("off") -- "debug" or "trace"

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { silent = true, focusable = false, relative = "cursor" }
)
