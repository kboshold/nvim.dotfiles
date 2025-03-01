local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
if vim.fn.filewritable(lockfile) ~= 1 then
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json"
end

require("lazy").setup({
	spec = {
		-- We could do this dynamic using vim.fn.readdir but why should we waste time?
		-- { import = "kboshold.config.plugins.debug" },
		{ import = "kboshold.config.plugins.lsp" },
		{ import = "kboshold.config.plugins.color" },
		{ import = "kboshold.config.plugins.ui" },
		{ import = "kboshold.config.plugins.util" }
	},
	lockfile = lockfile,
	defaults = {
		lazy = false,
		version = false
	},
	install = {},
	checker = {
		enabled = false, -- check for plugin updates periodically
		notify = false, -- notify on update
	}, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

return {}
