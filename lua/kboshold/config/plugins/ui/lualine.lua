-- if true then return {} end

return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  dependencies = { 
    'nvim-tree/nvim-web-devicons'
  },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    return {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 
          function()
            -- May add recording section
            local reg = vim.fn.reg_recording()
            if reg == "" then 
              return ""
            end
            return "󰑋  @" .. reg
          end,
          "mode"
        },
        lualine_b = { 
          "branch",
          "diff",
          "diagnostics"
        },
        lualine_c = {
          "filename"
        },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype"
        },
        lualine_y = {
          'searchcount',
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {},
      }
    }
  end,
}
