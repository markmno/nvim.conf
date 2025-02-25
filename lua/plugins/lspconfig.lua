return {
	{
		"williamboman/mason.nvim",
		-- event = "VimEnter",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Configure diagnostics with virtual text
			vim.diagnostic.config({
				virtual_text = {
					source = "if_many",
					prefix = "●",
					spacing = 4,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
				},
			})

			-- Customize virtual text appearance
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#db4b4b" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#e0af68" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#0db9d7" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#10B981" })

			-- Configure LSP capabilities
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Common on_attach function
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }
				local keymap = vim.keymap.set

				-- Diagnostic keymaps
				keymap("n", "[d", vim.diagnostic.goto_prev, opts)
				keymap("n", "]d", vim.diagnostic.goto_next, opts)
				keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
				keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)

				-- LSP keymaps
				keymap("n", "gD", vim.lsp.buf.declaration, opts)
				keymap("n", "gd", vim.lsp.buf.definition, opts)
				keymap("n", "K", vim.lsp.buf.hover, opts)
				keymap("n", "gi", vim.lsp.buf.implementation, opts)
				keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
				keymap("n", "gr", vim.lsp.buf.references, opts)
			end

			-- Server configurations
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				ruff = {
					init_options = {
						settings = {
							lint = { enable = true },
							format = { enable = true },
						},
					},
				},
				pyright = {
					settings = {
						pyright = { disableOrganizeImports = true },
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy" },
				},
			}

			-- Setup Mason LSP config
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					function(server_name)
						local config = vim.tbl_deep_extend("force", {
							capabilities = capabilities,
							on_attach = on_attach,
						}, servers[server_name] or {})

						require("lspconfig")[server_name].setup(config)
					end,
				},
			})
		end,
	},
}
