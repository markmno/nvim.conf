return {
  "NickvanDyke/opencode.nvim",
  lazy = true,
  event = "VeryLazy",
  dependencies = {
    -- Recommended for better prompt input, and required to use opencode.nvim's embedded terminal — otherwise optional
    -- { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
  },
  ---@type opencode.Opts
  opts = {
    on_opencode_not_found = function()
      vim.system({ "tmux", "split-window", "-h", "-p", "30", "opencode" }, { cwd = vim.fn.getcwd() }):wait()
      return true
    end, -- Your configuration, if any — see lua/opencode/config.lua
  },
}
