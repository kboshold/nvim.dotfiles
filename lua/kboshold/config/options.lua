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
  ai_cmp = true,
})
-- assign options
assign(vim.opt, {
  listchars = {
    space = "·",
    tab = "▏ ",
  },

  tabstop = 4, -- Number of spaces that a <Tab> in the file counts for.
  shiftwidth = 4, -- Number of spaces to use for each step of (auto)indent.
  softtabstop = 4, -- Number of spaces that a <Tab> in the file counts for.
  expandtab = false, -- Use a tab over spaces since the size can be individual.
  smarttab = true, -- Smart indent and remove of tabs/spaces
  smartcase = true,
  smartindent = true,

  wrap = false, -- Long lines wrap to the next line when enabled
  completeopt = "menu,menuone,popup,noinsert",
  colorcolumn = "101,121",
  signcolumn = "yes:2",
  scrolloff = 10,
})
