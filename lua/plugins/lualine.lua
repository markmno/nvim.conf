-- Example configuration using a package manager like lazy.nvim
-- Put this structure within your plugins setup file (e.g., plugins/lualine.lua)

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Define sidebar filetypes (still needed for disabling statusline/winbar)
		local sidebar_filetypes = {
			"NvimTree",
			-- "snacks_layout_box", -- <-- REPLACE with actual filetype if different
			"undotree",
			"Trouble",
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = sidebar_filetypes, -- Disable statusline for sidebars
					winbar = sidebar_filetypes, -- Disable winbar for sidebars
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true, -- Recommended false for buffer list in statusline
				-- refresh = {
				-- 	statusline = 1000,
				-- 	-- tabline refresh rate is irrelevant now
				-- 	winbar = 1000,
				-- },
			},
			-- STATUSLINE sections (bottom bar)
			sections = {
				lualine_a = { "mode" },
				-- Put buffers here, maybe alongside branch? Adjust as needed.
				lualine_b = { "branch", "buffers" }, -- ADDED 'buffers' HERE
				-- You might remove 'diff' or 'diagnostics' if it gets too crowded
				lualine_c = {},
				lualine_x = { "diagnostics", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				-- Show inactive filename and location
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
				-- Note: Buffers usually only show for the active statusline
			},

			-- TABLINE section is now empty or removed - Lualine won't manage the top bar
			tabline = {},

			-- WINBAR sections (optional, per-window header)
			winbar = {},
			inactive_winbar = {},

			-- EXTENSIONS
			extensions = { "fugitive", "nvim-dap-ui", "quickfix" },
		})

		-- Ensure Neovim's native tabline is shown if you still want tabs (0=never, 1=auto, 2=always)
		vim.opt.showtabline = 1 -- Or 2 if you use native tabs often
		print("Lualine configured with buffers in the statusline.")
	end, -- end config function
}
