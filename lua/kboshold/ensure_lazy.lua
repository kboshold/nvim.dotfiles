-- 
-- This file makes sure lazy will be ready for the configuration. 
-- The configuration of lazy itself can be found in ./config/lazy.lua 
-- The configuration of the plugins can be found in ./config/plugins/
--
if vim.fn.filewritable(vim.fn.stdpath("config") .. "/lazy-lock.json") ~= 1 then
    -- File is not writable, set to data directory
    vim.g.lazylock_json = vim.fn.stdpath("data") .. "/lazy-lock.json"
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
