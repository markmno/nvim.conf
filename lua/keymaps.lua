vim.keymap.set("n", "<leader>e", function()
  vim.cmd("vsplit")
  vim.cmd("Oil")
end, { desc = "Open Oil on the right" })
