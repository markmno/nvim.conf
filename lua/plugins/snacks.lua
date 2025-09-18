return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    image = { enabled = true },
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = (function()
          local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
          if branch == "" then return "No Git Repo" end
          local status = vim.fn.system("git status --porcelain 2>/dev/null | wc -l"):gsub("\n", "")
          local changes = status ~= "0" and (" | " .. status .. " changes") or " | Clean"
          local commit = vim.fn.system("git log --oneline -1 2>/dev/null"):gsub("\n", "")
          local last_commit = commit ~= "" and (" | Last: " .. commit:sub(1, 50)) or ""
          return "Branch: " .. branch .. changes .. last_commit
        end)(),
        keys = {
          -- Search
          { icon = " ", key = "f", desc = "Find Files", action = function() Snacks.picker.files() end },
          { icon = " ", key = "g", desc = "Live Grep", action = function() Snacks.picker.grep() end },
          { icon = " ", key = "e", desc = "File Browser", action = function() Snacks.picker.explorer() end },
          -- Git
          { icon = " ", key = "gs", desc = "Git Status", action = function() Snacks.picker.git_status() end },
          { icon = " ", key = "gc", desc = "Git Commits", action = function() require('neogit').open({ 'log' }) end },
          { icon = " ", key = "gb", desc = "Git Branches", action = function() Snacks.picker.git_branches() end },
          { icon = " ", key = "gst", desc = "Git Stash", action = function() Snacks.picker.git_stash() end },
          -- Todo
          { icon = " ", key = "td", desc = "Workspace Diagnostics", action = function() Snacks.picker.diagnostics() end },
          { icon = " ", key = "tl", desc = "Todo List", action = function() Snacks.picker.todo_comments() end },
          -- Config
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          -- Help
          { icon = " ", key = "h", desc = "Help Tags", action = function() Snacks.picker.help() end },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys",   gap = 0, padding = 1 },
        {
          title = "Git Graph",
          content = function()
            local graph = vim.fn.system("git log --oneline -5 2>/dev/null")
            if vim.v.shell_error ~= 0 then return { "No git repository" } end
            return vim.split(graph, "\n")
          end,
        },
        { section = "startup" },
      },
    },
    -- explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
