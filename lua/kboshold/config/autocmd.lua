-- Set ux_piped_input to `1` for input streams
vim.api.nvim_create_autocmd("StdinReadPost", { 
  callback = function()
    vim.g.ux_piped_input = 1;
  end 
})

-- Change the color or the CursorLineNr depending on the mode
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local color = 16752228 -- default color of tokionight (#ff9e64)
    local suffix = require("lualine.highlight").get_mode_suffix()
    
    if suffix ~= '_normal' then
      local highlight = vim.api.nvim_get_hl(0, {
        name = "lualine_a" .. suffix,
        create = false
      })
      color = highlight.bg
    end
    
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = color })
  end
})
