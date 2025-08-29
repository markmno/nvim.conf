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

    -- 2. Create an autocommand group to ensure our command is not duplicated.
    local neogit_cz_group = vim.api.nvim_create_augroup("NeogitCommitizen", { clear = true })

    -- 3. Create an autocommand that runs AFTER Neogit is fully loaded.
    vim.api.nvim_create_autocmd("FileType", {
      group = neogit_cz_group,
      pattern = "NeogitStatus",
      callback = function(args)
        -- This function runs only when the Neogit status window is opened.

        local function open_commitizen()
          -- We use pcall(require, ...) to safely load Neogit's internal
          -- modules *at runtime*. This prevents the startup error.
          local success, neogit_actions = pcall(require, "neogit.actions")
          if not success then
            vim.notify("Could not load neogit.actions", vim.log.levels.ERROR)
            return
          end

          -- Close the Neogit window before opening the terminal
          neogit_actions.close()

          -- Open Commitizen in a floating terminal
          local Terminal = require("toggleterm.terminal").Terminal
          local cz_term = Terminal:new({
            cmd = "cz commit",
            direction = "float",
            hidden = true,
            on_exit = vim.schedule_wrap(function()
              vim.notify("Commitizen finished. Re-opening Neogit.", vim.log.levels.INFO)
              -- Re-open Neogit using its safe, public API
              neogit.open()
            end),
          })
          cz_term:toggle()
        end

        -- Create the keymap, local to the Neogit buffer
        vim.keymap.set("n", "C", open_commitizen, {
          buffer = args.buf, -- Apply only to this neogit buffer
          noremap = true,
          silent = true,
          desc = "Neogit: Open Commitizen",
        })
      end,
    })

    -- Your optional Telescope sorter can remain here
    neogit.telescope_sorter = function()
      local has_fzf, fzf = pcall(require, "telescope._extensions.fzf.native_fzf_sorter")
      if has_fzf then
        return fzf()
      else
        return require("telescope.config").values.sorter
      end
    end
  end,
  keys = {
    {
      "<leader>gg",
      function() require("neogit").open() end,
      desc = "Open Neogit",
    },
  },
}
