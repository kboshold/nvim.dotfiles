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

vim.keymap.set("n", "gf", function()
  local file = vim.fn.expand("<cfile>")
  if file == "" or file == nil then
    return
  end

  local line_content = vim.fn.getline(".")
  local cursor_col = vim.fn.col(".")

  local start_index = 1
  local found_start = nil
  local found_end = nil
  while true do
    found_start, found_end = string.find(line_content, file, start_index)
    if not found_start then
      break
    end

    if found_start <= cursor_col and found_end >= cursor_col then
      break
    end

    start_index = found_end + 1
  end

  vim.cmd("e " .. file)

  if found_end then
    local text_after = string.sub(line_content, found_end + 1)
    local line_start, _, line_end = string.match(text_after, "^:(%d+)(%-?(%d*))")
    if line_start then
      vim.cmd(line_start)
    end

    if line_end and line_end > 0 then
      vim.cmd("normal! V" .. line_end .. "G")
    end
  end
end, { desc = "Open file at position" })
