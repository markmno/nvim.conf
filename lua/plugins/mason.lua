return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  { "williamboman/mason-lspconfig.nvim", lazy = true, event = "VeryLazy" },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "VeryLazy",
  },
  {
    "williamboman/mason.nvim", -- Duplicate to ensure mason-tool-installer loads after mason
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "stylua",   -- Lua formatter
          "ruff",     -- Python formatter/linter
          "prettier", -- Prettier for markdown/json/yaml/toml
          -- Debuggers
          "debugpy",  -- Python debugger (required for DAP)
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },
}
