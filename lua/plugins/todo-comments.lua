return {
  "folke/todo-comments.nvim",
  lazy = true,
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "TodoTrouble", "TodoTelescope" },
  opts = { signs = false },
  -- stylua: ignore
}
