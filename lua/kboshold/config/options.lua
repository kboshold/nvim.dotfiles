local function assign(dest, src)
	for k,v in pairs(src) do
		dest[k] = v
	end
end
-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })

-- assign globals
assign(vim.g, {
	mapleader = " ",                             -- Leader = Space
	maplocalleader = "\\",                       -- LLeader = \
	autoformat = true,                           -- auto format
	bigfile_size = 1024 * 1024 * 1.5,            -- 1.5 MB
	trouble_lualine = true,

	-- defaults
	ux_piped_input = 0
})

-- assign options
assign(vim.opt, {
	number = true,                              -- Show numbers 
	relativenumber = true,                      -- Use relative numbers over "normal" numbers
	termguicolors = true,                       -- enable 24-bit colour
	autowrite = true,                           -- Enable auto write
	completeopt = "menu,menuone,noselect",
	confirm = true,                             -- Confirm to save before exit buffer
	cursorline = true,                          -- Highlight current line

	fillchars = {
		foldopen = "",
		foldclose = "",
		fold = " ",
		foldsep = " ",
		diff = "╱",
		eob = " ",
	},
	scrolloff = 15,                              -- Minimal number of screen lines to keep above and below the cursor.
	tabstop = 4,                                 -- Number of spaces that a <Tab> in the file counts for.
	shiftwidth = 4,                              -- Number of spaces to use for each step of (auto)indent.
	softtabstop = 4,                             -- Number of spaces that a <Tab> in the file counts for.
	expandtab = false,                           -- Use a tab over spaces since the size can be individual.
	smarttab = true,                             -- Smart indent and remove of tabs/spaces 
	wrap = false,                                -- Long lines wrap to the next line when enabled
	listchars = {
		space = '·',
		tab = "▏ ",
	},
	signcolumn = "yes:2",
	list = true,
	smoothscroll = true,
	foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()",
	foldmethod = "expr",
	foldtext = "",
	colorcolumn = '101,121',                      -- screen columns that are highlighted with ColorColumn
	grepprg = "rg --vimgrep",                     -- use rg oder grep
	laststatus = 3,                               -- Expaned status over all buffers
	linebreak = true,
	showmode = false,
	sidescrolloff = 8,

	smartcase = true,
	smartindent = true,
	spelllang = { "en" },
	undofile = true,
	undolevels = 10000,
	updatetime = 200,
	virtualedit = "block",
})

