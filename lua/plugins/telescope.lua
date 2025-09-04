return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "isak102/telescope-git-file-history.nvim",
      "aaronhallaert/advanced-git-search.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          file_ignore_patterns = { "node_modules", ".git/" },
          prompt_prefix = "   ",
          selection_caret = " ",
          winblend = 0,
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
          git_file_history = {
            git_command = { "git", "log", "--oneline", "--follow", "--" }
          },
          advanced_git_search = {
            diff_plugin = "diffview",
            git_flags = {},
            git_diff_flags = {},
          },
        },
      })

      -- Load extensions
      telescope.load_extension("ui-select")
      telescope.load_extension("git_file_history")
      telescope.load_extension("advanced_git_search")

      -- Load fzf-native if available
      pcall(function()
        telescope.load_extension("fzf")
      end)
    end,
  },
}
