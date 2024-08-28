local function on_stid_in_read_post()
  vim.g.ux_piped_input = 1;
end

vim.api.nvim_create_autocmd({ "StdinReadPost" }, { callback = on_stid_in_read_post })
