return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional
    "nvim-telescope/telescope.nvim", -- optional
    "akinsho/toggleterm.nvim",       -- required for this solution
  },
  config = function()
    -- 1. Standard, minimal setup for Neogit.
    --    This part is simple and correct.
    local neogit = require("neogit")
    neogit.setup({
      integrations = {
        diffview = true,
        telescope = true,
      },
    })

    -- Your optional Telescope sorter can remain here
  end,
  keys = {
    {
      "<leader>gg",
      function() require("neogit").open() end,
      desc = "Open Neogit",
    },
  },
}
