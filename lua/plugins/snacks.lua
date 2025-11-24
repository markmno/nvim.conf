return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
   opts = {
     bufdelete = { enabled = true },
     image = { enabled = true },
     bigfile = { enabled = true },
     explorer = { enabled = true, replace_netrw = true },
     picker = {
       sources = {
         explorer = {
           jump = { close = true },
         },
       },
     },
      profiler = { enabled = true },
      dashboard = {
        enabled = true,
        width = 60,
        pane_gap = 20,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
          },
        },
        formats = {
          header = { "%s", align = "center" },
          terminal = { align = "center" },
          version = { "%s", align = "center" },
        },
        sections = {
          { section = "header" },
          { section = "keys",    title = "Keys", gap = 0, padding = 1, pane = 1 },
          { section = "startup", pane = 1 },
        },
      },
    }
}
