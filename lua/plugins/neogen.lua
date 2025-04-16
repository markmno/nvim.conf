-- In your lazy.nvim setup (e.g., lua/plugins/neogen.lua)
local neogen_prefix = "<leader>" -- Example: <leader>l for "LSP"

return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter", -- Essential dependency
	config = function()
		require("neogen").setup({
			-- Configuration options go here
			enabled = true, -- Enable Neogen

			-- Snippet engine integration (optional, requires `luasnip` or `vsnip`)
			-- snippet_engine = "luasnip",

			-- Language-specific annotation preferences
			languages = {
				python = {
					template = {
						annotation_convention = "google_docstrings", -- Or "numpy", "restructuredtext", etc.
					},
				},
				cpp = {
					template = {
						annotation_convention = "doxygen", -- Common choice for C++
					},
				},
				c = {
					template = {
						annotation_convention = "doxygen",
					},
				},
				-- Add other languages as needed
				-- rust = { ... }
				-- lua = { ... }
			},
		})
	end,
	-- Optional: Add keymaps for convenience
	-- Setting the version is recommended for stability
	-- version = "*" -- Or pin to a specific tag/commit
	keys = {
		{
			neogen_prefix .. "g",
			function()
				require("neogen").generate()
			end,
			desc = "Neogen Generate",
		},
		-- You might want more specific keymaps, e.g., for generating different types
		{
			neogen_prefix .. "f",
			function()
				require("neogen").generate({ type = "func" })
			end,
			desc = "Neogen Function",
		},
		{
			neogen_prefix .. "c",
			function()
				require("neogen").generate({ type = "class" })
			end,
			desc = "Neogen Class",
		},
	},
}
