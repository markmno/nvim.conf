return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "|" },
        change = { text = "|" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      numhl = true,
      linehl = false,
      current_line_blame = false,
      signcolumn = true,
      update_debounce = 100,

      on_attach = function(bufnr)
        if type(bufnr) == "number" then
          _G.setup_gitsigns_keymaps(bufnr)
        end
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
