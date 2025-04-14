return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" }, -- Load gitsigns efficiently
		opts = {
			-- Sign configuration (unchanged)
			signs = {
				add = { text = "|" },
				change = { text = "|" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			-- Other gitsigns options can be added here, e.g.:
			-- numhl = true, -- Highlight line number
			-- linehl = false, -- Highlight background of line
			-- current_line_blame = false, -- Don't show blame unless toggled
			-- signcolumn = true, -- Always draw signs (use 'auto' to hide if no signs)
			-- update_debounce = 100,

			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				-- Define the prefix specifically for gitsigns mappings within this on_attach
				local gs_prefix = "<leader>gs"

				-- Helper function for setting buffer-local keymaps
				local function map(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.buffer = bufnr
					opts.noremap = true -- Set noremap explicitly
					opts.silent = true -- Make mappings silent by default
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				-- ========== Navigation ==========
				-- Keep standard ]c and [c, as they handle diff mode correctly
				map("n", "]c", function()
					if vim.wo.diff then
						-- Use vim's built-in ]c in diff mode
						vim.cmd.normal({ "]c", bang = true })
					else
						-- Use gitsigns navigation outside diff mode
						gitsigns.nav_hunk("next")
					end
				end, { silent = false, desc = "Go to Next Git Hunk or Diff Change" }) -- Allow echo for normal command

				map("n", "[c", function()
					if vim.wo.diff then
						-- Use vim's built-in [c in diff mode
						vim.cmd.normal({ "[c", bang = true })
					else
						-- Use gitsigns navigation outside diff mode
						gitsigns.nav_hunk("prev")
					end
				end, { silent = false, desc = "Go to Previous Git Hunk or Diff Change" }) -- Allow echo for normal command

				-- ========== Actions (Prefixed with <leader>gs) ==========
				-- Staging
				map({ "n", "v" }, gs_prefix .. "s", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns: Stage Hunk" }) -- Use command for visual+normal consistency
				map("n", gs_prefix .. "S", gitsigns.stage_buffer, { desc = "Gitsigns: Stage Buffer" })
				map("n", gs_prefix .. "u", gitsigns.undo_stage_hunk, { desc = "Gitsigns: Undo Stage Hunk" })

				-- Resetting
				map({ "n", "v" }, gs_prefix .. "r", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns: Reset Hunk" }) -- Use command for visual+normal consistency
				map("n", gs_prefix .. "R", gitsigns.reset_buffer, { desc = "Gitsigns: Reset Buffer" })

				-- Diffing & Previewing
				map("n", gs_prefix .. "p", gitsigns.preview_hunk, { desc = "Gitsigns: Preview Hunk" })
				map("n", gs_prefix .. "d", gitsigns.diffthis, { desc = "Gitsigns: Diff Against Index" })
				map("n", gs_prefix .. "D", function()
					gitsigns.diffthis("~")
				end, { desc = "Gitsigns: Diff Against Last Commit" }) -- Use ~ for HEAD usually

				-- Blame
				map("n", gs_prefix .. "b", gitsigns.blame_line, { desc = "Gitsigns: Blame Line" })
				map("n", gs_prefix .. "B", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Gitsigns: Blame Line (Full)" }) -- Add full blame option

				-- ========== Toggles (Prefixed with <leader>gs) ==========
				map(
					"n",
					gs_prefix .. "tb",
					gitsigns.toggle_current_line_blame,
					{ desc = "Gitsigns: Toggle Line Blame" }
				) -- Renamed 't' for toggle
				map("n", gs_prefix .. "td", gitsigns.toggle_deleted, { desc = "Gitsigns: Toggle Deleted Hunks" }) -- Renamed 't' for toggle, 'd' for deleted
				map("n", gs_prefix .. "tn", gitsigns.toggle_numhl, { desc = "Gitsigns: Toggle Number Highlight" }) -- Add toggle for numhl if used
				map("n", gs_prefix .. "tl", gitsigns.toggle_linehl, { desc = "Gitsigns: Toggle Line Highlight" }) -- Add toggle for linehl if used
				map("n", gs_prefix .. "ts", gitsigns.toggle_signs, { desc = "Gitsigns: Toggle Signs Column" }) -- Add toggle for signs

				-- ========== Text Object ==========
				-- These are less likely to conflict but could be prefixed too if desired (e.g., <leader>gsih)
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Inner Git Hunk" })
				-- Example prefixing:
				-- map({"o", "x"}, gs_prefix .. "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns: Select Inner Hunk" })
			end, -- end on_attach
		},
	},
	-- Optional: Add Neogit if you want a Magit-like interface
	-- {
	--   "NeogitOrg/neogit",
	--   dependencies = {
	--     "nvim-lua/plenary.nvim", -- required
	--     "sindrets/diffview.nvim", -- optional
	--     "nvim-telescope/telescope.nvim", -- optional
	--   },
	--   config = true, -- Enable default config
	--   -- Example keymap for Neogit (outside gitsigns on_attach)
	--   keys = {
	--      { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" }
	--   }
	-- }
}
-- vim: ts=2 sts=2 sw=2 et
