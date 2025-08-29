return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "nvim-telescope/telescope.nvim", -- optional, for Telescope integration
    "sindrets/diffview.nvim",        -- optional, Diffview integration
    "akinsho/toggleterm.nvim",       -- recommended for commitizen integration
  },
  config = function()
    local neogit = require("neogit")

    neogit.setup({
      integrations = {
        diffview = true,
        telescope = true,
      },
    })

    -- 1. Create a reusable function to open Commitizen in a floating terminal
    local function open_commitizen()
      -- Close Neogit window before opening the terminal
      neogit.close()

      -- Create a new floating terminal running 'cz commit'
      local Terminal = require("toggleterm.terminal").Terminal
      local cz_term = Terminal:new({
        cmd = "cz commit",
        direction = "float",
        hidden = true, -- Hide terminal from buffer list
        -- Close the terminal when the commit process exits
        on_exit = function(term, job_id, exit_code, name)
          if exit_code == 0 then
            vim.notify("Commit successful!", vim.log.levels.INFO)
            -- Automatically refresh neogit status after commit
            require("neogit").open({ "status" })
          else
            vim.notify("Commit failed or was cancelled.", vim.log.levels.ERROR)
          end
          -- Close the terminal window
          term:close()
        end,
      })
      cz_term:toggle()
    end

    -- 2. Create an autocommand to map the key in the Neogit commit buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitMessage",
      callback = function(args)
        -- Map 'c' to open commitizen.
        -- <buffer> makes it local to this buffer only.
        -- <silent> prevents the command from being echoed.
        -- <noremap> ensures it's not a recursive mapping.
        vim.keymap.set("n", "c", open_commitizen, {
          buffer = args.buf,
          silent = true,
          noremap = true,
          desc = "Open Commitizen",
        })
      end,
    })

    -- =================================================================
    -- ===== END: Commitizen and Pre-commit Integration ================
    -- =================================================================
  end,
  keys = {
    {
      "<leader>gg",
      function() require("neogit").open() end,
      desc = "Open Neogit",
    },
  },
}
