-- lua/plugins/lualine.lua
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"SmiteshP/nvim-navic",
		"NeogitOrg/neogit",
	},
	event = "VeryLazy",
	config = function()
		-- 1) Safe-require navic and setup
		local has_navic, navic = pcall(require, "nvim-navic")
		if has_navic then
			navic.setup({
				highlight = true,
				separator = "  ",
				lazy_update_context = true,
				silence = false,
			})
		end

		-- 2) Autocmd to attach navic on LSP attach
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				if not has_navic then
					return
				end
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, args.buf)
				end
			end,
		})

		-- 3) Filetypes for which we disable statusline/winbar
		local sidebar_filetypes = {
			"NvimTree",
			"undotree",
			"Trouble",
			"snacks_layout_box",
			"snacks_dashboard",
			-- "NeogitStatus",
			-- "NeogitCommitMessage",
			-- "NeogitPopup",
			"Avante",
			"AvanteSelectedFiles",
			"AvanteInput",
		}

		-- 4) Lualine setup with winbar under `sections`
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = {
					statusline = sidebar_filetypes,
					winbar = sidebar_filetypes,
				},
			},

			-- statusline (bottom)
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "buffers" },
				lualine_c = {},
				lualine_x = { "diagnostics", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },

				-- winbar (top)
				winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						"navic",
						{
							navic.get_location,
							cond = function()
								return has_navic and navic.is_available()
							end,
							on_click = function()
								vim.cmd("Telescope lsp_document_symbols")
							end,
						},
					},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},

				inactive_winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			},

			-- per-filetype lualine extensions
			extensions = {
				{
					filetypes = { "NeogitStatus", "NeogitCommitMessage", "NeogitPopup" },
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch" },
						lualine_c = { "filename" },
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = { "branch" },
						lualine_c = { "filename" },
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
				},
				"fugitive",
				"quickfix",
				"nvim-dap-ui",
			},
		})

		-- 5) Hide native tabline (optional)
		vim.opt.showtabline = 0
	end,
}
