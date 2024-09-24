-- Set ux_piped_input to `1` for input streams
vim.api.nvim_create_autocmd("StdinReadPost", {
	callback = function()
		vim.g.ux_piped_input = 1;
	end
})

-- Change the color or the CursorLineNr depending on the mode
local function update_cursor_line_nr()
	local suffix = require("lualine.highlight").get_mode_suffix()

	local cursor_line_hl = vim.api.nvim_get_hl(0, {
		name = "CursorLine",
		create = false
	})

	local lualine_hl = vim.api.nvim_get_hl(0, {
		name = "lualine_a" .. suffix,
		create = false
	})

	vim.api.nvim_set_hl(0, "CursorLineNr", {
		fg = lualine_hl.bg,
		bg = cursor_line_hl.bg,
		bold = true
	})
end

vim.api.nvim_create_autocmd("ModeChanged", {
	callback = update_cursor_line_nr
})
vim.api.nvim_create_autocmd("BufEnter", {
	callback = update_cursor_line_nr
})

-- Create an autocmd to set the ruler when entering a buffer
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local util = require("kboshold.config.util")
		local bg_color = vim.api.nvim_get_hl(0, {
			name = "Normal",
			create = false
		}).bg

		local color = util.color.lighten(bg_color, 0.2)
		vim.api.nvim_set_hl(0, "ColorColumn", { bg = new_color })
		vim.api.nvim_set_hl(0, "CursorLine", { bg = new_color })
	end
})
