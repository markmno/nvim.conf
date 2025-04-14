return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				options = {
					separator_style = "thin",
				},
				highlights = require("nord.plugins.bufferline").akinsho(),
				offsets = {
					{
						filetype = "NvimTree",
						text = "Explorer",
						separator = true,
						text_align = "left",
					},

					{
						filetype = "snacks_layout_box",
						text = "󰙅  File Explorer",
						separator = false,
					},
				},
			},
		})
		vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
		vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { silent = true })
	end,
}
