-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local function assign(dest, src)
	for k, v in pairs(src) do
		dest[k] = v
	end
end

assign(vim.g, {
	bigfile_size = 1024 * 1024 * 0.5,
	-- defaults
	ux_piped_input = 0,

	-- lazy defaults
	lazyvim_cmp = "blink.cmp",
	ai_cmp = true
})
-- assign options
assign(vim.opt, {
	listchars = {
		space = '·',
		tab = "▏ ",
	},

	completeopt = "menu,menuone,noselect,noinsert",
	colorcolumn = '101,121',
	signcolumn = "yes:2",
	scrolloff = 10,
})
