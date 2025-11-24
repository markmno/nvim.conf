return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- Use main branch for Neovim 0.11.4 compatibility
  lazy = true,
  event = "BufReadPost",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = { "lua", "python", "markdown", "markdown_inline", "yaml", "toml" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
