return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		event = "VeryLazy",
		dependencies = {
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = { "williamboman/mason.nvim" },
			config = function(_, opts)
				require("mason-nvim-dap").setup(opts)
			end,
			opts = {
				automatic_installation = true,
				ensure_installed = { "debugpy" },
			},
		},
			{ "rcarriga/nvim-dap-ui", optional = true },
		},
		config = function()
			local dap = require("dap")
			dap.set_log_level("WARN")

			-- Python configuration
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						local venv_names = { ".venv", "venv" }
						for _, name in ipairs(venv_names) do
							local venv_dir = vim.loop.cwd() .. "/" .. name
							local python_exe = venv_dir .. "/bin/python"
							if vim.fn.executable(python_exe) == 1 then
								return python_exe
							end
						end
						return vim.fn.exepath("python3") or vim.fn.exepath("python")
					end,
					console = "integratedTerminal",
				},
			}
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{ "<leader>dt", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
			{ "<leader>de", function() require("dapui").eval() end, desc = "Debug: Evaluate" },
		},
		opts = {
			controls = { enabled = true },
			layouts = {
				{
					elements = { "scopes", "breakpoints", "stacks", "watches" },
					size = 40,
					position = "left",
				},
				{
					elements = { "repl", "console" },
					size = 10,
					position = "bottom",
				},
			},
		},
		config = function(_, opts)
			local dapui = require("dapui")
			local dap = require("dap")

			dapui.setup(opts)

			dap.listeners.after.event_initialized["dapui"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui"] = function()
				dapui.close()
			end
		end,
	},
}
