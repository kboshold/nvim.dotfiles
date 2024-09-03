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
  mouse = "",
  scrolloff = 4,                               -- Scroll 4 lines
  tabstop = 2,                                 -- Insert 2 spaces
  wrap = false,                                 -- Disable line wrap

  smoothscroll = true,
  foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()",
  foldmethod = "expr",
  foldtext = "",
  -- colorcolumn = '100,120'
})
