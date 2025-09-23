local function copy_to_clipboard(str)
  vim.fn.setreg("+", str)
  vim.notify("Copied: " .. str, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("CopyName", function()
  copy_to_clipboard(vim.fn.expand("%:t"))
end, { desc = "Copy current file name to clipboard" })

vim.api.nvim_create_user_command("CopyPath", function()
  copy_to_clipboard(vim.fn.expand("%:~:."))
end, { desc = "Copy current file path (relative) to clipboard" })

vim.api.nvim_create_user_command("CopyFullPath", function()
  copy_to_clipboard(vim.fn.expand("%:p"))
end, { desc = "Copy current file full path to clipboard" })
