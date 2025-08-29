-- lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "NeogitOrg/neogit",
  },
  event = "VeryLazy",
  config = function()
    -- Sidebar / special filetypes without lualine
    local sidebar_filetypes = {
      "NvimTree",
      "undotree",
      "Trouble",
      "snacks_layout_box",
      "snacks_dashboard",
      "Avante",
      "AvanteSelectedFiles",
      "AvanteInput",
    }

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto", -- keep auto theme for speed, avoids constant highlight recompute
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true, -- single statusline for all windows (saves redraw cost)
        disabled_filetypes = {
          statusline = sidebar_filetypes,
          winbar = sidebar_filetypes,
        },
        always_divide_middle = false, -- small perf gain: avoids frequent resize calc
        refresh = {
          statusline = 100,           -- update interval in ms (higher = fewer redraws)
          tabline = 100,
          winbar = 100,
        },
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "buffers" }, -- keep buffers, no change
        lualine_c = {},
        lualine_x = { "diagnostics", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },

      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },

      extensions = {
        {
          filetypes = { "NeogitStatus", "NeogitCommitMessage", "NeogitPopup" },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch" },
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = { "branch" },
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
          },
        },
        "fugitive",
        "quickfix",
        "nvim-dap-ui",
      },
    })

    -- Hide native tabline (saves redraws if you don’t need it)
    vim.opt.showtabline = 0
  end,
}
