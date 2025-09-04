vim.defer_fn(function()
  vim.lsp.enable({ "lua_ls", "ty", "ruff" })
end, 100)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Enable completion
    if client and client.supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr)
    end

    -- Format on save for LSP servers that support formatting
    if client and client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            timeout_ms = 500,
          })
        end,
      })
    end

    -- Let Neovim use its default LSP keymaps (grr, gra, grn, gri, grt, gO, etc.)
    -- These are set globally by default, no need to override them
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
