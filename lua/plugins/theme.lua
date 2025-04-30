return {
<<<<<<< HEAD
	-- "gbprod/nord.nvim",
	"shaunsingh/nord.nvim",
=======
	"shaunsingh/nord.nvim",
	-- "shaunsingh/nord.nvim",
>>>>>>> b301602 (minor commits)
	lazy = false,
	name = "nord",
	priority = 1001,
	config = function()
		vim.cmd.colorscheme("nord")
		vim.g.nord_contrast = true
	end,
}
-- --
-- return {
-- 	"gbprod/nord.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("nord").setup({})
-- 		vim.cmd.colorscheme("nord")
-- 	end,
-- }
