return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"b0o/nvim-tree-preview.lua",
	},
	opts = { silent = true },
	config = function()
		require("nvim-tree").setup(opts)
		vim.keymap.set("n", "\\", ":NvimTreeToggle<CR>", {})
		vim.keymap.set("n", "<leader>\\", ":NvimTreeFocus<CR>", {})
	end,
}
