local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("plugins")
vim.api.nvim_set_hl(0, "SnacksExplorerIcon", { fg = "#FABD2F" }) -- Icons
vim.api.nvim_set_hl(0, "SnacksExplorerExpander", { fg = "#FE8019" }) -- ▸/▾ symbols
vim.api.nvim_set_hl(0, "SnacksExplorerDir", { fg = "#B8BB26", bold = true }) -- Folder names
vim.api.nvim_set_hl(0, "SnacksExplorerFile", { fg = "#8EC07C" }) -- File names
vim.api.nvim_set_hl(0, "SnacksExplorerSymlink", { fg = "#D3869B", underline = true }) -- Symlinks
vim.api.nvim_set_hl(0, "SnacksExplorerIndent", { fg = "#504945" }) -- Tree indent lines
vim.api.nvim_set_hl(0, "SnacksExplorerPathHidden", { fg = "#928374" })
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")
vim.g.loaded_python3_provider = nil
vim.cmd("runtime! plugin/rplugin.vim")
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
