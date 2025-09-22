local lsp_attach_group = vim.api.nvim_create_augroup('lsp-attach', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_attach_group,

  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>rs", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>QF", vim.lsp.buf.code_action, opts)
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format { async = true } end, opts)

    if client and client.name == "clangd" then
      vim.keymap.set("n", "<leader>t", "<cmd>LspClangdSwitchSourceHeader<CR>", opts)
    end
  end,
})

for _, server in ipairs(require "mason-lspconfig".get_installed_servers()) do
  local ok, server_opts = pcall(require, "config.lsp.servers." .. server)
  local opts = ok and server_opts or {}
  vim.lsp.config(server, opts)
  vim.lsp.enable(server)
end

vim.lsp.set_log_level("off") -- "debug" or "trace"

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { silent = true, focusable = false, relative = "cursor" }
)
