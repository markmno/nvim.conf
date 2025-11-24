return {
  "saghen/blink.cmp",
  lazy = true,
  event = "InsertEnter",
   dependencies = {
     "rafamadriz/friendly-snippets",
     {
       "saghen/blink.compat",
       optional = true,
       version = "*",
     },
   },
  version = "1.*",
   opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = {
          border = "rounded",
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      sources = {
       default = {
         "lsp",
         "path",
         "snippets",
         "buffer",
       },
     },
     terminal = { enabled = true }, -- Enable terminal completion for Neovim 0.11+
   },
  opts_extend = { "sources.default" },
}
