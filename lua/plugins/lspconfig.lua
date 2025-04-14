-- Choose a prefix for LSP-related keymaps
local lsp_prefix = "<leader>l" -- Example: <leader>l for "LSP"

return {
	{
		"williamboman/mason.nvim",
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
					source = "if_many", -- Show virtual text if there are multiple sources
					prefix = "●", -- Prefix character
					spacing = 4, -- Spaces before virtual text
				},
				signs = true, -- Show diagnostic signs in the sign column
				underline = true, -- Underline diagnostics
				update_in_insert = false, -- Don't update diagnostics in insert mode
				severity_sort = true, -- Sort diagnostics by severity
				float = {
					border = "rounded", -- Style of the diagnostic float window border
					source = "always", -- Show the source (LSP server name) in the float window
					header = "", -- Optional header for the float window
				},
			})

			-- Customize virtual text appearance (colors match your Nord theme?)
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#bf616a" }) -- Red
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ebcb8b" }) -- Yellow/Orange (Adjusted from your original purple)
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#81a1c1" }) -- Blue
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a3be8c" }) -- Green (Adjusted from your original yellow)

			-- Setup LSP capabilities for autocompletion using nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- Enable snippet support if your completion engine uses it
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Common on_attach function: This runs whenever an LSP attaches to a buffer
			local on_attach = function(client, bufnr)
				-- Create buffer-local mappings using vim.keymap.set
				-- 'n' for normal mode, 'opts' restricts mapping to the current buffer
				local opts = { buffer = bufnr, noremap = true, silent = true } -- silent=true prevents cmdline echo
				local keymap = vim.keymap.set -- Shorthand

				-- Diagnostic keymaps
				-- These are fairly standard, leaving them unprefixed for now.
				keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Previous Diagnostic", buffer = bufnr })
				keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic", buffer = bufnr })
				-- Prefixing diagnostic float and loclist commands
				keymap(
					"n",
					lsp_prefix .. "e",
					vim.diagnostic.open_float,
					{ desc = "LSP: Show Line Diagnostics", buffer = bufnr }
				)
				keymap(
					"n",
					lsp_prefix .. "q",
					vim.diagnostic.setloclist,
					{ desc = "LSP: Show Diagnostics in Loclist", buffer = bufnr }
				)

				-- LSP keymaps (using lsp_prefix where appropriate)
				-- Keep highly standard mappings unprefixed (personal preference, can be prefixed too)
				keymap("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", buffer = bufnr })
				keymap("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go To Implementation", buffer = bufnr })
				keymap("n", "gr", vim.lsp.buf.references, { desc = "LSP: Go To References", buffer = bufnr })

				-- Prefix less standard or potentially conflicting mappings
				keymap(
					"n",
					lsp_prefix .. "D",
					vim.lsp.buf.declaration,
					{ desc = "LSP: Go To Declaration", buffer = bufnr }
				) -- Note: Original had gD prefixed
				keymap(
					"n",
					lsp_prefix .. "d",
					vim.lsp.buf.definition,
					{ desc = "LSP: Go To Definition", buffer = bufnr }
				) -- Note: Original had gd prefixed
				keymap(
					"n",
					lsp_prefix .. "s",
					vim.lsp.buf.signature_help,
					{ desc = "LSP: Signature Help", buffer = bufnr }
				) -- Changed from <C-k>
				keymap("n", lsp_prefix .. "a", vim.lsp.buf.code_action, { desc = "LSP: Code Action", buffer = bufnr }) -- Changed from <leader>ca
				keymap(
					{ "n", "v" },
					lsp_prefix .. "A",
					vim.lsp.buf.code_action,
					{ desc = "LSP: Code Action (Visual)", buffer = bufnr }
				) -- Added visual mode mapping too
				keymap("n", lsp_prefix .. "r", vim.lsp.buf.rename, { desc = "LSP: Rename", buffer = bufnr }) -- Changed from <leader>rn
				keymap("n", lsp_prefix .. "f", function()
					vim.lsp.buf.format({ async = true })
				end, { desc = "LSP: Format Document", buffer = bufnr }) -- Add format mapping if desired
				keymap(
					"n",
					lsp_prefix .. "w",
					vim.lsp.buf.workspace_symbol,
					{ desc = "LSP: Workspace Symbols", buffer = bufnr }
				) -- Add workspace symbol search

				-- Optional: Add workspace folder management if needed
				keymap(
					"n",
					lsp_prefix .. "wa",
					vim.lsp.buf.add_workspace_folder,
					{ desc = "LSP: Add Workspace Folder", buffer = bufnr }
				)
				keymap(
					"n",
					lsp_prefix .. "wr",
					vim.lsp.buf.remove_workspace_folder,
					{ desc = "LSP: Remove Workspace Folder", buffer = bufnr }
				)
				keymap("n", lsp_prefix .. "wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, { desc = "LSP: List Workspace Folders", buffer = bufnr })

				-- Set statusline (if using default statusline or a compatible one)
				-- Example: Show client name attached to buffer
				-- vim.api.nvim_buf_set_var(bufnr, 'lsp_status_string', client.name)

				-- Add highlighting for document symbols on hover (optional, requires Neovim 0.6+)
				if client.supports_method("textDocument/documentHighlight") then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end -- end on_attach

			-- Server-specific settings (unchanged from your original)
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
					-- Note: Ruff LSP typically handles both linting and formatting now.
					-- Configuration might be simpler or handled via ruff.toml / pyproject.toml
					-- init_options can still be used for specific overrides if needed.
					-- Ensure you don't have conflicting formatters enabled elsewhere.
					settings = { -- Example using standard settings structure
						args = {}, -- Add any specific CLI args for ruff-lsp if needed
					},
				},
				pyright = {
					on_new_config = function(new_config, _)
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							new_config.settings.python = new_config.settings.python or {}
							local python_executable = venv .. "/bin/python"
							-- Check if the python executable actually exists before setting it
							if vim.fn.executable(python_executable) == 1 then
								new_config.settings.python.pythonPath = python_executable
							end

							-- Correctly determine site-packages path
							-- This is more robust than hardcoding python3.x
							local site_packages_path =
								vim.fn.globpath(venv .. "/lib", "python*/site-packages", true, true)
							if site_packages_path and site_packages_path ~= "" then
								new_config.settings.python.analysis = new_config.settings.python.analysis or {}
								new_config.settings.python.analysis.extraPaths = new_config.settings.python.analysis.extraPaths
									or {}
								table.insert(new_config.settings.python.analysis.extraPaths, site_packages_path)
							end
						end
					end,
					settings = {
						pyright = { disableOrganizeImports = true },
						python = {
							analysis = {
								typeCheckingMode = "basic", -- or "strict"
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								-- extraPaths are added by on_new_config if VIRTUAL_ENV is set
							},
						},
					},
				},
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy" },
					-- filetypes = { "c", "cpp", "objc", "objcpp", "cuda" } -- Define if not default
				},
				-- Add other servers here...
				-- Example: tsserver for TypeScript/JavaScript
				-- tsserver = {},
				-- Example: gopls for Go
				-- gopls = {},
				-- Example: rust_analyzer for Rust
				-- rust_analyzer = {
				--   settings = {
				--     ["rust-analyzer"] = {
				--       check = { command = "clippy" }
				--     }
				--   }
				-- }
			}

			-- Setup Mason LSP config to manage LSP servers
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers), -- Automatically install servers listed above
				handlers = {
					-- Default handler: Sets up servers with common settings
					function(server_name)
						local server_opts = servers[server_name] or {} -- Get server-specific settings
						local config = vim.tbl_deep_extend("force", {
							-- Merge defaults with server-specific options
							capabilities = capabilities, -- Pass capabilities from cmp-nvim-lsp
							on_attach = on_attach, -- Attach keymaps and other setup
						}, server_opts) -- Server-specific settings override defaults

						require("lspconfig")[server_name].setup(config)
					end,
					-- Custom handler example for a specific server if needed
					-- ["pylsp"] = function() -- Example: Different setup for pylsp
					--   require("lspconfig").pylsp.setup({
					--       capabilities = capabilities,
					--       on_attach = on_attach,
					--       settings = { pylsp = { plugins = { ... } } }
					--   })
					-- end,
				},
			})
		end, -- end config function
	},
}
