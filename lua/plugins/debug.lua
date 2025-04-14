return {
	-- 1. Core DAP Plugin
	{
		"mfussenegger/nvim-dap",
		-- Load only when a DAP keymap is triggered or a DAP command is run.
		-- Removed `event = "VeryLazy"` as `keys` provides more precise lazy-loading.
		dependencies = {
			-- Installs and manages DAP adapters
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "williamboman/mason.nvim" },
				-- Load only when installing/updating or when dap itself loads
				cmd = { "DapInstall", "DapUpdate" },
				opts = {
					-- Automatically install adapters listed below
					automatic_installation = true,
					-- Ensure these adapters are installed by mason-nvim-dap
					ensure_installed = {
						"debugpy", -- Python
						-- Add other adapters like "codelldb", "node-debug2-adapter", etc.
					},
					-- Optional: You can define handlers here if specific setup needed before dap config
					handlers = {},
				},
			},
			-- DAP UI (optional dependency, configured separately for even lazier loading)
			{ "rcarriga/nvim-dap-ui", optional = true },
			-- nvim-nio is often required by adapters for async operations
			{ "nvim-neotest/nvim-nio" },
		},
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<F1>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F2>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F3>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Conditional Breakpoint",
			},
			-- Keybinding for DAP UI toggle moved to the dap-ui plugin spec below
		},
		config = function(_, opts) -- Pass opts from mason-nvim-dap setup if needed
			local dap = require("dap")

			-- Performance: Reduce logging level (WARN is usually sufficient)
			dap.set_log_level("WARN")

			-- === Adapter Configuration ===
			-- Tell nvim-dap HOW to run the adapters installed by Mason.
			-- mason-nvim-dap provides helpers, but explicit setup is clear.

			-- Python (debugpy)
			-- Get the path from mason-nvim-dap or mason.nvim
			local mason_registry = require("mason-registry")
			local debugpy_path = mason_registry.get_package("debugpy"):get_install_path()
			local codelldb_path -- Define if using codelldb

			-- Attempt to get codelldb path safely
			local codelldb_pkg = mason_registry.get_package("codelldb")
			if codelldb_pkg:is_installed() then
				codelldb_path = codelldb_pkg:get_install_path()
			end

			-- Python adapter using debugpy executable (works well for launch)
			dap.adapters.python = {
				type = "executable",
				command = debugpy_path .. "/venv/bin/python", -- Path to python inside debugpy venv
				args = { "-m", "debugpy.adapter" },
				options = {
					source_filetype = "python",
				},
			}

			-- Example: Codelldb (for C, C++, Rust) - uncomment and ensure 'codelldb' in ensure_installed
			-- if codelldb_path then
			--  dap.adapters.codelldb = {
			--      type = 'server',
			--      port = "${port}", -- Let dap figure out the port
			--      executable = {
			--          -- CHANGE THIS path to the codelldb executable!
			--          command = codelldb_path .. '/extension/adapter/codelldb',
			--          args = { "--port", "${port}" },
			--          -- On windows you may need config like this:
			--          -- command = codelldb_path .. '\\extension\\adapter\\codelldb.exe',
			--          -- args = {"--port", "${port}"},
			--      }
			--  }
			-- else
			--  vim.notify("codelldb path not found or not installed via Mason", vim.log.levels.WARN)
			-- end

			-- === Configuration Templates ===
			-- Defines how to launch specific project types

			-- Python Configurations
			dap.configurations.python = {
				{
					type = "python", -- Matches the adapter name
					request = "launch",
					name = "Launch file",
					program = "${file}", -- Debug the current file
					pythonPath = function()
						local cwd = vim.loop.cwd()
						-- Define potential virtual environment directory names relative to cwd
						local venv_names = { ".venv", "venv" } -- Check .venv first, then venv

						for _, name in ipairs(venv_names) do
							local venv_dir = cwd .. "/" .. name
							-- vim.fn.findpython3 looks for common executable names within the path
							-- The '1' argument tells it to look inside {venv_dir}/bin/ (Unix) or {venv_dir}/Scripts/ (Windows)
							local python_executable = vim.fn.findpython3(venv_dir, 1)

							-- Check if findpython3 returned a non-empty string (success)
							if python_executable ~= nil and python_executable ~= "" then
								-- Optional: uncomment to see which python is being used
								-- vim.notify("DAP using Python from: " .. venv_dir, vim.log.levels.INFO)
								return python_executable
							end
						end

						-- Fallback to system python if no virtual environment python found
						local system_python = vim.fn.exepath("python3") or vim.fn.exepath("python")
						if system_python ~= nil and system_python ~= "" then
							-- Optional: uncomment to see which python is being used
							-- vim.notify("DAP using system Python: " .. system_python, vim.log.levels.INFO)
							return system_python
						else
							-- Handle case where no python is found at all
							vim.notify(
								"DAP Error: Could not find any Python executable (.venv, venv, or system)",
								vim.log.levels.ERROR
							)
							return nil -- Or raise an error, depending on desired behavior
						end
					end,
					console = "integratedTerminal", -- Use integrated terminal
					-- justMyCode = false, -- Uncomment to step into library code
				},
				-- Add attach configuration if needed
				-- {
				--     type = 'python',
				--     request = 'attach',
				--     name = 'Attach by Process ID',
				--     processId = require('dap.utils').pick_process,
				--     pythonPath = function() ... end,
				-- },
			}

			-- C/C++/Rust using CodeLLDB (Example) - uncomment if codelldb adapter is configured
			-- dap.configurations.cpp = {
			--  {
			--      name = "Launch file",
			--      type = "codelldb",
			--      request = "launch",
			--      program = function()
			--          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			--      end,
			--      cwd = '${workspaceFolder}',
			--      stopOnEntry = false,
			--  },
			-- }
			-- dap.configurations.c = dap.configurations.cpp -- Use same config for C
			-- dap.configurations.rust = dap.configurations.cpp -- Use same config for Rust

			-- Add configurations for other languages here...

			-- Optional: Load launch.json configurations if present
			-- require('dap.ext.vscode').load_launchjs(nil, {
			--    ['python'] = {'python'}, -- Map vscode 'python' type to our 'python' adapter
			--    ['cppdbg'] = {'codelldb'}, -- Map vscode 'cppdbg' to our 'codelldb' adapter
			-- })

			print("nvim-dap core configured.") -- For debugging setup
		end,
	},

	-- 2. DAP UI Plugin (Loads even *more* lazily)
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		-- Load only when the toggle key is pressed OR when a DAP session starts (via listeners)
		keys = {
			{
				"<F7>",
				function()
					require("dapui").toggle({})
				end,
				desc = "Debug: Toggle UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval(nil, { enter = true })
				end,
				desc = "Debug: Evaluate",
			},
			-- Add other UI-specific keys if desired
		},
		opts = { -- Configure dapui using opts for cleaner separation
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			controls = {
				enabled = true,
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
			layouts = { -- Using default layout structure for simplicity
				{
					elements = {
						{ id = "scopes", size = 0.35 },
						{ id = "breakpoints", size = 0.15 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40, -- % width for vertical layouts
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.6 },
						{ id = "console", size = 0.4 },
					},
					size = 10, -- % height for horizontal layouts
					position = "bottom",
				},
			},
			floating = {
				max_height = 0.9,
				max_width = 0.7,
				border = "rounded",
				mappings = { close = { "q", "<Esc>" } },
			},
			windows = { indent = 1 },
			render = {
				max_value_lines = 100, -- Performance: prevent huge values slowing UI
			},
		},
		config = function(_, opts)
			local dapui = require("dapui")
			local dap = require("dap") -- dap core should be loaded already

			-- Setup UI using opts passed from the plugin spec
			dapui.setup(opts)

			-- Setup listeners to auto-open/close UI *inside* dapui's config
			-- Ensures dapui is loaded before these are called
			dap.listeners.after.event_initialized["dapui_config"] = function()
				require("dapui").open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				require("dapui").close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				require("dapui").close({})
			end
			print("nvim-dap-ui configured.") -- For debugging setup
		end,
	},
}
