local function set_marks_for_current_highlight()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local current_node = ts_utils.get_node_at_cursor()
  if current_node == nil then
    return false
  end

  local start_row, start_col, end_row, end_col = current_node:range()
  vim.api.nvim_buf_set_mark(0, "<", start_row + 1, start_col, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row + 1, end_col - 1, {})
  return true
end

vim.keymap.set("n", "dih", function()
  if set_marks_for_current_highlight() then
    vim.cmd("normal! `<v`>d")
  end
end, { desc = "Delete in Highlight Group" })

vim.keymap.set("n", "cih", function()
  if set_marks_for_current_highlight() then
    vim.cmd("normal! `<v`>")
    vim.api.nvim_feedkeys("c", "n", false)
  end
end, { desc = "Change in Highlight Group" })

vim.keymap.set("n", "vih", function()
  if set_marks_for_current_highlight() then
    vim.cmd("normal! `<v`>")
  end
end, { desc = "View in Highlight Group" })
