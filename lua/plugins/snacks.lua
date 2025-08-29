local snacks_prefix = "<leader>s" -- Example: <leader>sn for "snacks"

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = {
      enabled = true,
      diagnostics_open = true,
      git_untracked = false,
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  -- We define the prefix locally above and apply it explicitly in keys
  -- prefix = snacks_prefix, -- Avoid using the global prefix option if applying manually

  keys = {
    -- ========== Pickers & Explorer (under <leader>sn) ==========
    {
      snacks_prefix .. "<space>", -- Was <leader>s<space>
      function()
        Snacks.picker.smart()
      end,
      desc = "Snacks: Smart Find Files",
    },
    {
      snacks_prefix .. ",", -- Was <leader>s,
      function()
        Snacks.picker.buffers()
      end,
      desc = "Snacks: Buffers",
    },
    {
      snacks_prefix .. "/", -- Was <leader>s/
      function()
        Snacks.picker.grep()
      end,
      desc = "Snacks: Grep",
    },
    {
      snacks_prefix .. ":", -- Was <leader>:
      function()
        Snacks.picker.command_history()
      end,
      desc = "Snacks: Command History",
    },
    {
      snacks_prefix .. "N", -- Was <leader>n (conflicted with other <leader>n)
      function()
        Snacks.picker.notifications()
      end,
      desc = "Snacks: Notification History Picker",
    },
    {
      snacks_prefix .. "e", -- Was <leader>se
      function()
        Snacks.explorer()
      end,
      desc = "Snacks: File Explorer",
    },

    -- ========== Find (under <leader>snf) ==========
    {
      snacks_prefix .. "fb", -- Was <leader>fb
      function()
        Snacks.picker.buffers()
      end,
      desc = "Snacks: Find Buffers", -- Renamed desc for clarity
    },
    {
      snacks_prefix .. "fc", -- Was <leader>fc
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Snacks: Find Config File",
    },
    {
      snacks_prefix .. "ff", -- Was <leader>ff
      function()
        Snacks.picker.files()
      end,
      desc = "Snacks: Find Files",
    },
    {
      snacks_prefix .. "fg", -- Was <leader>fg
      function()
        Snacks.picker.git_files()
      end,
      desc = "Snacks: Find Git Files",
    },
    {
      snacks_prefix .. "fp", -- Was <leader>fp
      function()
        Snacks.picker.projects()
      end,
      desc = "Snacks: Find Projects", -- Renamed desc
    },
    {
      snacks_prefix .. "fr", -- Was <leader>fr
      function()
        Snacks.picker.recent()
      end,
      desc = "Snacks: Find Recent", -- Renamed desc
    },

    -- ========== Git (under <leader>sng) ==========
    {
      snacks_prefix .. "gb", -- Was <leader>gb
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Snacks: Git Branches",
    },
    {
      snacks_prefix .. "gl", -- Was <leader>gl
      function()
        Snacks.picker.git_log()
      end,
      desc = "Snacks: Git Log",
    },
    {
      snacks_prefix .. "gL", -- Was <leader>gL
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Snacks: Git Log Line",
    },
    {
      snacks_prefix .. "gs", -- Was <leader>gs
      function()
        Snacks.picker.git_status()
      end,
      desc = "Snacks: Git Status",
    },
    {
      snacks_prefix .. "gS", -- Was <leader>gS
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Snacks: Git Stash",
    },
    {
      snacks_prefix .. "gd", -- Was <leader>gd
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Snacks: Git Diff (Hunks)",
    },
    {
      snacks_prefix .. "gf", -- Was <leader>gf
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Snacks: Git Log File",
    },
    {
      snacks_prefix .. "gB", -- Was <leader>gB
      function()
        Snacks.gitbrowse()
      end,
      desc = "Snacks: Git Browse",
      mode = { "n", "v" },
    },
    {
      snacks_prefix .. "gg", -- Was <leader>gg
      function()
        Snacks.lazygit()
      end,
      desc = "Snacks: Lazygit",
    },

    -- ========== Grep (under <leader>sn/) ==========
    -- Note: Using '/' suffix similar to default search
    {
      snacks_prefix .. "/b", -- Was <leader>sb and <leader>sb (duplicate)
      function()
        Snacks.picker.lines()
      end,
      desc = "Snacks: Grep Buffer Lines",
    },
    {
      snacks_prefix .. "/B", -- Was <leader>sB
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Snacks: Grep Open Buffers",
    },
    {
      snacks_prefix .. "//", -- Was <leader>sg (and <leader>s/ above)
      function()
        Snacks.picker.grep()
      end,
      desc = "Snacks: Grep Project", -- More specific desc
    },
    {
      snacks_prefix .. "/w", -- Was <leader>sw
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Snacks: Grep Word/Selection", -- More specific desc
      mode = { "n", "x" },
    },

    -- ========== Search Pickers (under <leader>sns) ==========
    {
      snacks_prefix .. 's"', -- Was <leader>s"
      function()
        Snacks.picker.registers()
      end,
      desc = "Snacks: Search Registers",
    },
    {
      snacks_prefix .. "s/", -- Was <leader>s/
      function()
        Snacks.picker.search_history()
      end,
      desc = "Snacks: Search History",
    },
    {
      snacks_prefix .. "sa", -- Was <leader>sa
      function()
        Snacks.picker.autocmds()
      end,
      desc = "Snacks: Search Autocmds",
    },
    -- <leader>sb used above for Buffer Lines Grep (<leader>sn/b)
    {
      snacks_prefix .. "sc", -- Was <leader>sc
      function()
        Snacks.picker.command_history()
      end,
      desc = "Snacks: Search Command History",
    },
    {
      snacks_prefix .. "sC", -- Was <leader>sC
      function()
        Snacks.picker.commands()
      end,
      desc = "Snacks: Search Commands",
    },
    {
      snacks_prefix .. "sd", -- Was <leader>sd
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Snacks: Search Diagnostics",
    },
    {
      snacks_prefix .. "sD", -- Was <leader>sD
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Snacks: Search Buffer Diagnostics",
    },
    {
      snacks_prefix .. "sh", -- Was <leader>sh
      function()
        Snacks.picker.help()
      end,
      desc = "Snacks: Search Help Pages",
    },
    {
      snacks_prefix .. "sH", -- Was <leader>sH
      function()
        Snacks.picker.highlights()
      end,
      desc = "Snacks: Search Highlights",
    },
    {
      snacks_prefix .. "si", -- Was <leader>si
      function()
        Snacks.picker.icons()
      end,
      desc = "Snacks: Search Icons",
    },
    {
      snacks_prefix .. "sj", -- Was <leader>sj
      function()
        Snacks.picker.jumps()
      end,
      desc = "Snacks: Search Jumps",
    },
    {
      snacks_prefix .. "sk", -- Was <leader>sk
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Snacks: Search Keymaps",
    },
    {
      snacks_prefix .. "sl", -- Was <leader>sl
      function()
        Snacks.picker.loclist()
      end,
      desc = "Snacks: Search Location List",
    },
    {
      snacks_prefix .. "sm", -- Was <leader>sm
      function()
        Snacks.picker.marks()
      end,
      desc = "Snacks: Search Marks",
    },
    {
      snacks_prefix .. "sM", -- Was <leader>sM
      function()
        Snacks.picker.man()
      end,
      desc = "Snacks: Search Man Pages",
    },
    {
      snacks_prefix .. "sp", -- Was <leader>sp
      function()
        Snacks.picker.lazy()
      end,
      desc = "Snacks: Search Plugin Spec",
    },
    {
      snacks_prefix .. "sq", -- Was <leader>sq
      function()
        Snacks.picker.qflist()
      end,
      desc = "Snacks: Search Quickfix List",
    },
    {
      snacks_prefix .. "sR", -- Was <leader>sR
      function()
        Snacks.picker.resume()
      end,
      desc = "Snacks: Search Resume",
    },
    {
      snacks_prefix .. "su", -- Was <leader>su
      function()
        Snacks.picker.undo()
      end,
      desc = "Snacks: Search Undo History",
    },
    {
      snacks_prefix .. "uC", -- Was <leader>uC (moved under sn prefix)
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Snacks: Search Colorschemes",
    },

    -- ========== LSP (under <leader>snl) ==========
    -- Avoid overriding default gd, gr, etc.
    {
      snacks_prefix .. "ld", -- Was gd
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Snacks: LSP Definitions",
    },
    {
      snacks_prefix .. "lD", -- Was gD
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "Snacks: LSP Declarations",
    },
    {
      snacks_prefix .. "lr", -- Was gr
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "Snacks: LSP References",
    },
    {
      snacks_prefix .. "lI", -- Was gI
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Snacks: LSP Implementations",
    },
    {
      snacks_prefix .. "ly", -- Was gy
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Snacks: LSP Type Definitions",
    },
    {
      snacks_prefix .. "ls", -- Was <leader>ss
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Snacks: LSP Symbols",
    },
    {
      snacks_prefix .. "lS", -- Was <leader>sS
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "Snacks: LSP Workspace Symbols",
    },

    -- ========== Other Snacks Features (under <leader>sn) ==========
    {
      snacks_prefix .. "z", -- Was <leader>Z
      function()
        Snacks.zen.zoom()
      end,
      desc = "Snacks: Toggle Zoom",
    },
    {
      snacks_prefix .. ".", -- Was <leader>.
      function()
        Snacks.scratch()
      end,
      desc = "Snacks: Toggle Scratch Buffer",
    },
    {
      snacks_prefix .. ">", -- Was <leader>S (using > as 'select' or 'go to')
      function()
        Snacks.scratch.select()
      end,
      desc = "Snacks: Select Scratch Buffer",
    },
    -- <leader>n for notification history picker is snacks_prefix .. "N"
    -- <leader>n for showing history function is snacks_prefix .. "nh" (see below)
    {
      snacks_prefix .. "nh", -- Was <leader>n
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Snacks: Show Notification History Window",
    },
    {
      snacks_prefix .. "bd", -- Was <leader>bd
      function()
        Snacks.bufdelete()
      end,
      desc = "Snacks: Delete Buffer",
    },
    {
      snacks_prefix .. "cR", -- Was <leader>cR
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Snacks: Rename File",
    },
    {
      snacks_prefix .. "un", -- Was <leader>un
      function()
        Snacks.notifier.hide()
      end,
      desc = "Snacks: Dismiss All Notifications",
    },
    {
      snacks_prefix .. "t", -- Was <c-/> and <c-_>
      function()
        Snacks.terminal()
      end,
      desc = "Snacks: Toggle Terminal",
    },
    -- Moved [[ and ]] under prefix to avoid conflicts
    {
      snacks_prefix .. "]]", -- Was ]]
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Snacks: Next Reference",
      mode = { "n", "t" },
    },
    {
      snacks_prefix .. "[[", -- Was [[
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Snacks: Prev Reference",
      mode = { "n", "t" },
    },
    {
      snacks_prefix .. "news", -- Was <leader>N
      desc = "Snacks: Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings under the snacks prefix <leader>snu*
        -- (originally <leader>u*)
        local toggle_prefix = snacks_prefix .. "u"

        Snacks.toggle.option("spell", { name = "Spelling" }):map(toggle_prefix .. "s")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map(toggle_prefix .. "w")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map(toggle_prefix .. "L")
        Snacks.toggle.diagnostics():map(toggle_prefix .. "d")
        Snacks.toggle.line_number():map(toggle_prefix .. "l")
        Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map(toggle_prefix .. "c")
        Snacks.toggle.treesitter():map(toggle_prefix .. "T")
        Snacks.toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map(toggle_prefix .. "b")
        Snacks.toggle.inlay_hints():map(toggle_prefix .. "h")
        Snacks.toggle.indent():map(toggle_prefix .. "g") -- Changed from 'i' to 'g' (guide) to avoid conflict with inlay hints 'h' if prefix was short
        Snacks.toggle.dim():map(toggle_prefix .. "D")
      end,
    })
  end,
}
