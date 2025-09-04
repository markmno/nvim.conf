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
				if type(bufnr) == "number" then
					_G.setup_gitsigns_keymaps(bufnr)
				end
			end, -- end on_attach
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
