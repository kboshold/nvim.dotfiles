local group = vim.api.nvim_create_augroup("kboshold", { clear = true })

-- Set ux_piped_input to `1` for input streams
vim.api.nvim_create_autocmd("StdinReadPost", {
  group = group,
  callback = function()
    vim.g.ux_piped_input = 1
  end,
})

-- Change the color of CursorLineNr depending on the mode
local last_mode_suffix = nil
local function update_cursor_line_nr()
  local ok, hl = pcall(require, "lualine.highlight")
  if not ok then
    return
  end
  local suffix = hl.get_mode_suffix()
  if suffix == last_mode_suffix then
    return
  end
  last_mode_suffix = suffix

  local cursor_line_hl = vim.api.nvim_get_hl(0, {
    name = "CursorLine",
    create = false,
  })

  local lualine_hl = vim.api.nvim_get_hl(0, {
    name = "lualine_a" .. suffix,
    create = false,
  })

  vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = lualine_hl.bg,
    bg = cursor_line_hl.bg,
    bold = true,
  })
end

vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  callback = update_cursor_line_nr,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function()
    last_mode_suffix = nil
    update_cursor_line_nr()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
