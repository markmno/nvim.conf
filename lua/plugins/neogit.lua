return {
	"NeogitOrg/neogit",
	-- lazy = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = true,
	keys = {
		{
			"<leader>gg",
			function()
				require("neogit").open()
			end,
			desc = "Neogit",
		},
	},
}
