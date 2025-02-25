return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim", -- added as a dependency
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					file_ignore_patterns = { "node_modules", ".git/" },
					prompt_prefix = "   ",
					selection_caret = " ",
					winblend = 0, -- no transparency blending; adjust if needed
				},
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			telescope.load_extension("ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>sw", builtin.live_grep, { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "Old Files" })
			vim.keymap.set("n", "<leader>sz", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })
		end,
	},
}
