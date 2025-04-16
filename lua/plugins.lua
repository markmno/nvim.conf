-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	--
	-- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
	--

	-- modular approach: using `require 'path/name'` will
	-- include a plugin definition from file lua/path/name.lua

	-- require("plugins/autocomplete"),
	require("plugins/avante"),
	require("plugins/blink"),

	require("plugins/trouble"),

	-- require("plugins/bufferline"),

	require("plugins/codeium"),

	require("plugins/conform"),

	require("plugins/debug"),

	require("plugins/garbage-day"),

	require("plugins/gitsigns"),

	require("plugins/image"),

	require("plugins/jupytext"),

	require("plugins/lspconfig"),

	require("plugins/lualine"),

	require("plugins/mini"),

	require("plugins/molten"),

	require("plugins/neogen"),

	require("plugins/neogit"),

	require("plugins/neotest"),

	require("plugins/noice"),

	require("plugins/quarto"),

	require("plugins/rainbow-csv"),

	require("plugins/snacks"),

	require("plugins/telescope"),

	require("plugins/theme"),

	require("plugins/todo-comments"),

	require("/plugins/treesitter"),

	require("plugins/which"),

	-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	-- require 'kickstart.plugins.neo-tree',

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- { import = 'custom.plugins' },
	--
	-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
	-- Or use telescope!
	-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
	-- you can continue same window with `<space>sr` which resumes last telescope search
})

-- vim: ts=2 sts=2 sw=2 et
