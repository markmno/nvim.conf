-- lspconfig.lua

-- Define a global prefix for LSP keymaps for easy customization.
local lsp_prefix = "<leader>c"

-- Safely require a module, notifying on error. This is a good practice.
local function safe_require(name)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.notify("Failed to load module '" .. name .. "': " .. tostring(mod), vim.log.levels.ERROR)
    return nil
  end
  return mod
end

return {
  -- Plugin 1: mason.nvim (manages LSP installers)
  {
    "williamboman/mason.nvim",
    config = function()
      local mason = safe_require("mason")
      if mason then
        mason.setup()
      end
    end,
  },

  -- Plugin 2: mason-lspconfig.nvim (bridges mason and lspconfig)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp", -- Used for LSP capabilities
    },
    config = function()
      -- Part 1: Configure Diagnostics Appearance
      -- This sets up how errors, warnings, etc., are displayed in the editor.
      vim.diagnostic.config({
        virtual_text = { source = "if_many", prefix = "●", spacing = 4 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "always", header = "" },
      })

      -- Custom colors for virtual text diagnostics to match a common theme (e.g., Nord)
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#bf616a" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ebcb8b" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#81a1c1" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a3be8c" })

      -- Part 2: Define the on_attach function
      -- This function runs once for each LSP that attaches to a buffer.
      -- It's the ideal place to define buffer-local keymaps for LSP features.
      local on_attach = function(client, bufnr)
        -- Helper for setting keymaps in the current buffer with descriptions.
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end

        -- Diagnostics
        map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("n", lsp_prefix .. "e", vim.diagnostic.open_float, "Show Diagnostics")
        map("n", lsp_prefix .. "q", vim.diagnostic.setloclist, "Diagnostics to Loclist")

        -- Core LSP Features
        map("n", "K", vim.lsp.buf.hover, "Hover Doc")
        map("n", "gi", vim.lsp.buf.implementation, "Go To Implementation")
        map("n", "gr", vim.lsp.buf.references, "Go To References")
        map("n", lsp_prefix .. "d", vim.lsp.buf.definition, "Go To Definition")
        map("n", lsp_prefix .. "D", vim.lsp.buf.declaration, "Go To Declaration")
        map("n", lsp_prefix .. "s", vim.lsp.buf.signature_help, "Signature Help")
        map("n", lsp_prefix .. "r", vim.lsp.buf.rename, "Rename Symbol")
        map("n", lsp_prefix .. "f", function() vim.lsp.buf.format({ async = true }) end, "Format Document")

        -- Code Actions
        map("n", lsp_prefix .. "a", vim.lsp.buf.code_action, "Code Action")
        map({ "n", "v" }, lsp_prefix .. "A", vim.lsp.buf.code_action, "Code Action (Visual)")

        -- Workspace Management
        map("n", lsp_prefix .. "w", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
        map("n", lsp_prefix .. "wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
        map("n", lsp_prefix .. "wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
        map("n", lsp_prefix .. "wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
          "List Workspace Folders")

        -- Highlight references on cursor hold (if the server supports it)
        if client.supports_method("textDocument/documentHighlight") then
          local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Part 3: Get LSP capabilities from your completion plugin
      local capabilities = {}
      local cmp_cap = safe_require("blink.cmp")
      if cmp_cap and cmp_cap.get_lsp_capabilities then
        capabilities = cmp_cap.get_lsp_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
      end

      -- Part 4: Define server-specific settings
      -- Add any LSP server and its specific configurations to this table.
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
        ruff = {},
        pyrefly = {},
        ty = {},
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy" },
        },
        -- Example: Add pyright here if you decide to use it
        -- pyright = { ... settings ... },
      }

      -- Part 5: Setup mason-lspconfig to manage installations
      local mlsp = safe_require("mason-lspconfig")
      if not mlsp then return end

      mlsp.setup({
        -- A list of servers to automatically install.
        -- This is derived from the keys of our `servers` table.
        ensure_installed = vim.tbl_keys(servers),
      })

      -- Part 6: Setup all language servers with lspconfig
      -- This loop iterates through your `servers` table and configures each one.
      local lspconfig = safe_require("lspconfig")
      if not lspconfig then return end

      for server_name, server_opts in pairs(servers) do
        -- Combine shared settings (on_attach, capabilities) with server-specific ones.
        -- The server-specific settings (`server_opts`) will override shared ones on conflict.
        local opts = vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, server_opts or {})

        lspconfig[server_name].setup(opts)
      end
    end,
  },
}
