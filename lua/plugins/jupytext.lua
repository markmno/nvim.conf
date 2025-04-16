return {
	"GCBallesteros/jupytext.nvim",
	lazy = "VeryLazy",
	config = function()
		require("jupytext").setup({
			style = "markdown",
			output_extension = "md",
			force_ft = "markdown",
		})
	end,
}
