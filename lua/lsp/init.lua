vim.lsp.enable({ "lua_ls", "ty", "ruff" })
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf)
    end
  end,
})
vim.diagnostic.config({
  -- virtual_text = { source = 'if_many', prefix = '●', spacing = 4 },
  virtual_lines = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
})
