return {
  {
    "echasnovski/mini.starter",
    version = false, -- Wait for stable release
    lazy = false,    -- Load on startup for dashboard
    config = function()
      local starter = require("mini.starter")
      starter.setup({
        header = function()
          local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
          if branch == "" then return "No Git Repo" end
          local status = vim.fn.system("git status --porcelain 2>/dev/null | wc -l"):gsub("\n", "")
          local changes = status ~= "0" and (" | " .. status .. " changes") or " | Clean"
          local commit = vim.fn.system("git log --oneline -1 2>/dev/null"):gsub("\n", "")
          local last_commit = commit ~= "" and (" | Last: " .. commit:sub(1, 50)) or ""
          return "Branch: " .. branch .. changes .. last_commit
        end,
        items = {
          -- Search
          { name = "Find Files",            action = "Telescope find_files",   section = "Search" },
          { name = "Live Grep",             action = "Telescope live_grep",    section = "Search" },
          { name = "File Browser",          action = "Telescope file_browser", section = "Search" },
          { name = "Grep Buffers",          action = "Telescope grep_string",  section = "Search" },

          -- Git
          { name = "Git Status",            action = "Telescope git_status",   section = "Git" },
          { name = "Git Commits",           action = "Telescope git_commits",  section = "Git" },
          { name = "Git Branches",          action = "Telescope git_branches", section = "Git" },
          { name = "Git Files",             action = "Telescope git_files",    section = "Git" },
          { name = "Git Stash",             action = "Telescope git_stash",    section = "Git" },
          { name = "Neogit",                action = "Neogit",                 section = "Git" },

          -- LSP
          { name = "Workspace Diagnostics", action = "Telescope diagnostics",  section = "Todo" },
          { name = "Todo List",             action = "TodoTelescope",          section = "Todo" },

          -- Config/Help
          { name = "Lazy",                  action = "Lazy",                   section = "Config" },
          { name = "Help Tags",             action = "Telescope help_tags",    section = "Help" },
        },
        footer = function()
          local stats = require("lazy").stats()
          return string.format("Loaded %d/%d plugins in %.2fms", stats.loaded, stats.count, stats.startuptime)
        end,
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning("center", "center"),
          starter.gen_hook.padding(3, 2),
        },
      })
    end,
  },
}
