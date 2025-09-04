-- Telescope keymaps
local telescope_prefix = "<leader>f"

-- Telescope keymaps (require telescope to be loaded)
vim.keymap.set("n", telescope_prefix .. "f", function()
  pcall(function() require("telescope.builtin").find_files() end)
end, { desc = "Find Files" })

vim.keymap.set("n", telescope_prefix .. "/", function()
  pcall(function() require("telescope.builtin").live_grep() end)
end, { desc = "Live Grep" })

vim.keymap.set("n", telescope_prefix .. "b", function()
  pcall(function() require("telescope.builtin").buffers() end)
end, { desc = "Buffers" })

vim.keymap.set("n", telescope_prefix .. "h", function()
  pcall(function() require("telescope.builtin").help_tags() end)
end, { desc = "Help Tags" })

vim.keymap.set("n", telescope_prefix .. "o", function()
  pcall(function() require("telescope.builtin").oldfiles() end)
end, { desc = "Old Files" })

vim.keymap.set("n", telescope_prefix .. "z", function()
  pcall(function() require("telescope.builtin").current_buffer_fuzzy_find() end)
end, { desc = "Fuzzy Find in Buffer" })

-- Git integration with Telescope
vim.keymap.set("n", telescope_prefix .. "g", function()
  pcall(function() require("telescope.builtin").git_files() end)
end, { desc = "Git Files" })

vim.keymap.set("n", telescope_prefix .. "s", function()
  pcall(function() require("telescope.builtin").git_status() end)
end, { desc = "Git Status" })

vim.keymap.set("n", telescope_prefix .. "c", function()
  pcall(function() require("telescope.builtin").git_commits() end)
end, { desc = "Git Commits" })

vim.keymap.set("n", telescope_prefix .. "B", function()
  pcall(function() require("telescope.builtin").git_branches() end)
end, { desc = "Git Branches" })

vim.keymap.set("n", telescope_prefix .. "H", function()
  pcall(function() require("telescope").extensions.git_file_history.git_file_history() end)
end, { desc = "Git File History" })

vim.keymap.set("n", telescope_prefix .. "G", function()
  pcall(function() require("telescope").extensions.advanced_git_search.search_log_content() end)
end, { desc = "Advanced Git Search" })

-- Git Integration
-- Gitsigns keymaps
_G.setup_gitsigns_keymaps = function(bufnr)
  if not bufnr or type(bufnr) ~= "number" then
    return
  end

  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    return
  end
  -- Define the prefix specifically for gitsigns mappings within this on_attach
  local gs_prefix = "<leader>gs"

  -- Helper function for setting buffer-local keymaps
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.noremap = true -- Set noremap explicitly
    opts.silent = true -- Make mappings silent by default
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- ========== Navigation ==========
  -- Keep standard ]c and [c, as they handle diff mode correctly
  map("n", "]c", function()
    if vim.wo.diff then
      -- Use vim's built-in ]c in diff mode
      vim.cmd.normal({ "]c", bang = true })
    else
      -- Use gitsigns navigation outside diff mode
      gitsigns.nav_hunk("next")
    end
  end, { silent = false, desc = "Go to Next Git Hunk or Diff Change" }) -- Allow echo for normal command

  map("n", "[c", function()
    if vim.wo.diff then
      -- Use vim's built-in [c in diff mode
      vim.cmd.normal({ "[c", bang = true })
    else
      -- Use gitsigns navigation outside diff mode
      gitsigns.nav_hunk("prev")
    end
  end, { silent = false, desc = "Go to Previous Git Hunk or Diff Change" }) -- Allow echo for normal command

  -- ========== Actions (Prefixed with <leader>gs) ==========
  -- Staging
  map({ "n", "v" }, gs_prefix .. "s", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns: Stage Hunk" }) -- Use command for visual+normal consistency
  map("n", gs_prefix .. "S", gitsigns.stage_buffer, { desc = "Gitsigns: Stage Buffer" })
  map("n", gs_prefix .. "u", gitsigns.undo_stage_hunk, { desc = "Gitsigns: Undo Stage Hunk" })

  -- Resetting
  map({ "n", "v" }, gs_prefix .. "r", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns: Reset Hunk" }) -- Use command for visual+normal consistency
  map("n", gs_prefix .. "R", gitsigns.reset_buffer, { desc = "Gitsigns: Reset Buffer" })

  -- Diffing & Previewing
  map("n", gs_prefix .. "p", gitsigns.preview_hunk, { desc = "Gitsigns: Preview Hunk" })
  map("n", gs_prefix .. "d", gitsigns.diffthis, { desc = "Gitsigns: Diff Against Index" })
  map("n", gs_prefix .. "D", function()
    gitsigns.diffthis("~")
  end, { desc = "Gitsigns: Diff Against Last Commit" }) -- Use ~ for HEAD usually

  -- Blame
  map("n", gs_prefix .. "b", gitsigns.blame_line, { desc = "Gitsigns: Blame Line" })
  map("n", gs_prefix .. "B", function()
    gitsigns.blame_line({ full = true })
  end, { desc = "Gitsigns: Blame Line (Full)" }) -- Add full blame option

  -- ========== Toggles (Prefixed with <leader>gs) ==========
  map("n", gs_prefix .. "tb", gitsigns.toggle_current_line_blame, { desc = "Gitsigns: Toggle Line Blame" }) -- Renamed 't' for toggle
  map("n", gs_prefix .. "td", gitsigns.toggle_deleted, { desc = "Gitsigns: Toggle Deleted Hunks" })        -- Renamed 't' for toggle, 'd' for deleted
  map("n", gs_prefix .. "tn", gitsigns.toggle_numhl, { desc = "Gitsigns: Toggle Number Highlight" })       -- Add toggle for numhl if used
  map("n", gs_prefix .. "tl", gitsigns.toggle_linehl, { desc = "Gitsigns: Toggle Line Highlight" })        -- Add toggle for linehl if used
  map("n", gs_prefix .. "ts", gitsigns.toggle_signs, { desc = "Gitsigns: Toggle Signs Column" })           -- Add toggle for signs

  -- ========== Text Object ==========
  -- These are less likely to conflict but could be prefixed too if desired (e.g., <leader>gsih)
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Inner Git Hunk" })
  -- Example prefixing:
  -- map({"o", "x"}, gs_prefix .. "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns: Select Inner Hunk" })
end

-- File Explorer
-- Yazi keymaps
vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>Yazi cwd<cr>", { desc = "Open yazi at the current file" })
vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })

-- Code Actions
-- Native LSP formatting (no plugin needed)
vim.keymap.set("n", "<leader>cf", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- AI Assistant
-- Opencode keymaps
vim.keymap.set("n", "<leader>oA", function()
  pcall(function() require("opencode").ask() end)
end, { desc = "Ask opencode" })
vim.keymap.set("n", "<leader>oa", function()
  pcall(function() require("opencode").ask("@cursor: ") end)
end, { desc = "Ask opencode about this" })
vim.keymap.set("v", "<leader>oa", function()
  pcall(function() require("opencode").ask("@selection: ") end)
end, { desc = "Ask opencode about selection" })
vim.keymap.set("n", "<leader>ot", function()
  pcall(function() require("opencode").toggle() end)
end, { desc = "Toggle embedded opencode" })
vim.keymap.set("n", "<leader>on", function()
  pcall(function() require("opencode").command("session_new") end)
end, { desc = "New session" })
vim.keymap.set("n", "<leader>oy", function()
  pcall(function() require("opencode").command("messages_copy") end)
end, { desc = "Copy last message" })
vim.keymap.set("n", "<S-C-u>", function()
  pcall(function() require("opencode").command("messages_half_page_up") end)
end, { desc = "Scroll messages up" })
vim.keymap.set("n", "<S-C-d>", function()
  pcall(function() require("opencode").command("messages_half_page_down") end)
end, { desc = "Scroll messages down" })
vim.keymap.set({ "n", "v" }, "<leader>op", function()
  pcall(function() require("opencode").select_prompt() end)
end, { desc = "Select prompt" })
vim.keymap.set("n", "<leader>oe", function()
  pcall(function() require("opencode").prompt("Explain @cursor and its context") end)
end, { desc = "Explain code near cursor" })

-- Debugging
-- Debug (DAP) keymaps - Following Neovim 0.11.3 best practices
vim.keymap.set("n", "<F5>", function()
  pcall(function() require("dap").continue() end)
end, { desc = "Debug: Start/Continue" })

vim.keymap.set("n", "<F10>", function()
  pcall(function() require("dap").step_over() end)
end, { desc = "Debug: Step Over" })

vim.keymap.set("n", "<F11>", function()
  pcall(function() require("dap").step_into() end)
end, { desc = "Debug: Step Into" })

vim.keymap.set("n", "<F12>", function()
  pcall(function() require("dap").step_out() end)
end, { desc = "Debug: Step Out" })

vim.keymap.set("n", "<leader>db", function()
  pcall(function() require("dap").toggle_breakpoint() end)
end, { desc = "Debug: Toggle Breakpoint" })

vim.keymap.set("n", "<leader>dB", function()
  pcall(function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
end, { desc = "Debug: Set Conditional Breakpoint" })

vim.keymap.set("n", "<leader>dbc", function()
  pcall(function() require("dap").clear_breakpoints() end)
end, { desc = "Debug: Clear All Breakpoints" })

vim.keymap.set("n", "<leader>dbl", function()
  pcall(function() require("dap").list_breakpoints() end)
end, { desc = "Debug: List Breakpoints" })

vim.keymap.set("n", "<leader>dl", function()
  pcall(function() require("dap").run_last() end)
end, { desc = "Debug: Run Last" })

vim.keymap.set("n", "<leader>dt", function()
  pcall(function() require("dapui").toggle() end)
end, { desc = "Debug: Toggle UI" })

vim.keymap.set("n", "<leader>de", function()
  pcall(function() require("dapui").eval() end)
end, { desc = "Debug: Evaluate Expression" })

vim.keymap.set("n", "<leader>dw", function()
  pcall(function() require("dapui").elements.watches.add() end)
end, { desc = "Debug: Add Watch" })

vim.keymap.set("n", "<leader>dr", function()
  pcall(function() require("dap").repl.toggle() end)
end, { desc = "Debug: Toggle REPL" })

vim.keymap.set("n", "<leader>dc", function()
  pcall(function() require("dap").run_to_cursor() end)
end, { desc = "Debug: Run to Cursor" })

vim.keymap.set("n", "<leader>dp", function()
  pcall(function() require("dap").pause() end)
end, { desc = "Debug: Pause" })

vim.keymap.set("n", "<leader>dx", function()
  pcall(function() require("dap").terminate() end)
end, { desc = "Debug: Terminate" })

vim.keymap.set("n", "<leader>dq", function()
  pcall(function() require("dap").close() end)
end, { desc = "Debug: Quit" })

-- Visual mode debugging
vim.keymap.set("v", "<leader>de", function()
  pcall(function() require("dapui").eval() end)
end, { desc = "Debug: Evaluate Selection" })

-- Git UI
-- Neogit keymaps
vim.keymap.set("n", "<leader>gg", function()
  pcall(function() require("neogit").open() end)
end, { desc = "Open Neogit" })

-- Diagnostics and LSP
-- Native diagnostic and LSP keymaps (replacing Trouble)
vim.keymap.set("n", "<leader>xx", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })
vim.keymap.set("n", "<leader>xX", function() vim.diagnostic.setqflist({ bufnr = 0 }) end, { desc = "Buffer diagnostics to quickfix" })
vim.keymap.set("n", "<leader>cs", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>cws", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>xl", ":lopen<CR>", { desc = "Open location list" })
vim.keymap.set("n", "<leader>xq", ":copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>xc", ":cclose<CR>:lclose<CR>", { desc = "Close quickfix/location lists" })

-- Additional native diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>xL", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Todo Comments
-- Todo-comments keymaps
vim.keymap.set("n", "]t", function()
  pcall(function() require("todo-comments").jump_next() end)
end, { desc = "Next Todo Comment" })
vim.keymap.set("n", "[t", function()
  pcall(function() require("todo-comments").jump_prev() end)
end, { desc = "Previous Todo Comment" })
vim.keymap.set("n", "<leader>xt", ":TodoLocList<CR>", { desc = "Todo location list" })
vim.keymap.set("n", "<leader>xT", ":TodoQuickFix<CR>", { desc = "Todo quickfix" })
vim.keymap.set("n", "<leader>ft", function()
  pcall(function() vim.cmd("TodoTelescope") end)
end, { desc = "Todo" })
vim.keymap.set("n", "<leader>fT", function()
  pcall(function() vim.cmd("TodoTelescope keywords=TODO,FIX,FIXME") end)
end, { desc = "Todo/Fix/Fixme" })
