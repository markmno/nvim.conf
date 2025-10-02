return {
  "saghen/blink.cmp",
  lazy = true,
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "Kaiser-Yang/blink-cmp-avante",
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
        "avante",
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
      providers = {
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {},
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
