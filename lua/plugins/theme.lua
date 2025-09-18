return {
  "markmno/nord.nvim",
  lazy = false,
  name = "nord",
  priority = 1001,
  config = function()
    vim.cmd.colorscheme("nord")
    -- vim.g.nord_contrast = true
  end,
}
