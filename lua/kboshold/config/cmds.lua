local function get_line_spec()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: get range
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    if start_line == end_line then
      return ":" .. start_line
    else
      return (":" .. start_line .. "-" .. end_line)
    end
  else
    -- Normal mode: just current line
    return ":" .. vim.fn.line(".")
  end
end

local function copy_to_clipboard(str)
  vim.fn.setreg("+", str)
  vim.notify("Copied: " .. str, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("PathCopyName", function()
  copy_to_clipboard(vim.fn.expand("%:t"))
end, { desc = "Copy current file name to clipboard" })

vim.api.nvim_create_user_command("PathCopyRelative", function()
  copy_to_clipboard(vim.fn.expand("%:~:."))
end, { desc = "Copy current file path (relative) to clipboard" })

vim.api.nvim_create_user_command("PathCopyRelativeFull", function()
  local path = vim.fn.expand("%:~:.") .. get_line_spec()
  copy_to_clipboard(path)
end, { desc = "Copy current file path (relative, with line) to clipboard" })

vim.api.nvim_create_user_command("PathCopyAbsolute", function()
  copy_to_clipboard(vim.fn.expand("%:p"))
end, { desc = "Copy current file full path to clipboard" })

vim.api.nvim_create_user_command("PathCopyAbsoluteFull", function()
  local path = vim.fn.expand("%:p") .. get_line_spec()
  copy_to_clipboard(path)
end, { desc = "Copy current file full path (with line) to clipboard" })
