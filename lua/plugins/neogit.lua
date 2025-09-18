return {
  "NeogitOrg/neogit",
  lazy = true,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional
    "folke/snacks.nvim",
  },
  config = function()
    -- 1. Standard, minimal setup for Neogit.
    --    This part is simple and correct.
    local neogit = require("neogit")
    neogit.setup({
      integrations = {
        diffview = true,
        -- telescope = true,
        snacks = true,
      },
      -- kind = "floating",
    })
    -- Your optional Telescope sorter can remain here
  end,
}
