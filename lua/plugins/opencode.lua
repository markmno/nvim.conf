return {
  "NickvanDyke/opencode.nvim",
  lazy = true,
  event = "VeryLazy",
  dependencies = {
    { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
  },
  config = function()
    -- Required for `opts.auto_reload`
    vim.opt.autoread = true
  end,
}
