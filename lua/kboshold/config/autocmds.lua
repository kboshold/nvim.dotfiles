local group = vim.api.nvim_create_augroup("kboshold", { clear = true })

-- Set ux_piped_input to `1` for input streams
vim.api.nvim_create_autocmd("StdinReadPost", {
  group = group,
  callback = function()
    vim.g.ux_piped_input = 1
  end,
})

-- Change the color of CursorLineNr depending on the mode (same colors as catppuccin's lualine theme)
local MODE_COLORS = {
  n = "blue",
  i = "green",
  t = "green",
  c = "peach",
  v = "mauve",
  V = "mauve",
  ["\22"] = "mauve",
  s = "mauve",
  S = "mauve",
  ["\19"] = "mauve",
  R = "red",
}

local last_color = nil
local function update_cursor_line_nr(force)
  local ok, palettes = pcall(require, "catppuccin.palettes")
  if not ok then
    return
  end
  local color = MODE_COLORS[vim.fn.mode():sub(1, 1)] or "blue"
  if color == last_color and not force then
    return
  end
  last_color = color

  local cursor_line_hl = vim.api.nvim_get_hl(0, { name = "CursorLine", create = false })
  vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = palettes.get_palette()[color],
    bg = cursor_line_hl.bg,
    bold = true,
  })
end

vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  callback = function()
    update_cursor_line_nr(false)
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "ColorScheme" }, {
  group = group,
  callback = function()
    update_cursor_line_nr(true)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "gitcommit",
  callback = function(ev)
    local ai_commit = require("kboshold.config.ai_commit")
    ai_commit.auto(ev.buf)
    vim.keymap.set("n", "<leader>gm", function()
      ai_commit.generate(ev.buf, true)
    end, { buffer = ev.buf, desc = "Regenerate Commit Message (codex)" })
  end,
})
