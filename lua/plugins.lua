require("lazy").setup({
  -- require("plugins/avante"),
  require("plugins/blink"),
  require("plugins/trouble"),
  require("plugins/conform"),
  -- require("plugins/debug"),
  -- require("plugins/garbage-day"),
  require("plugins/gitsigns"),
  require("plugins/mason"),
  require("plugins/lualine"),
  require("plugins/neogit"),
  -- require("plugins/neotest"),
  require("plugins/noice"),
  require("plugins/rainbow-csv"),
  require("plugins/telescope"),
  require("plugins/theme"),
  require("plugins/todo-comments"),
  require("plugins/treesitter"),
  require("plugins/which"),
  require("plugins/hardtime"),
  require("plugins/vimbegood"),
  require("plugins/opencode"),
  -- require("plugins/image"),
  -- require("plugins/jupytext"),
  -- require("plugins/molten"),
  -- require("plugins/quarto"),
  -- require("plugins/snacks")
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
})
-- vim: ts=2 sts=2 sw=2 et
