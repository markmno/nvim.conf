return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				offsets = {
					{
						filetype = "NvimTree",
						text = "Explorer",
						separator = true,
						text_align = "left",
					},
				},
			},
		})
		vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
		vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { silent = true })
	end,
}
