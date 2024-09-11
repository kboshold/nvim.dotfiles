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
    local empty = require('lualine.component'):extend()
    function empty:draw(default_highlight)
      self.status = ''
      self.applied_separator = ''
      self:apply_highlights(default_highlight)
      self:apply_section_separators()
      return self.status
    end

    local mocha = require("catppuccin.palettes").get_palette "mocha"

    local emptyEntry =  { 
      empty,
      separator = { right = '' },
      color = { bg = mocha.mantle }
    }

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 
          "mode"
        },
        lualine_b = { 
          emptyEntry,
          {
            function()
              -- May add recording section
              local reg = vim.fn.reg_recording()
              if reg == "" then 
                return ""
              end
              return "󰑋  @" .. reg
            end,
            separator = { right = '' },
            color = { fg = mocha.base, bg =  mocha.red } 
          },
          emptyEntry,
          {
            "branch",
            separator = { right = '' },
          },      
          {
            "diff",
            separator = { right = '' },
          },  
          emptyEntry,
          {
            "diagnostics",
            separator = { right = '' },
          },  
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            color = { fg = mocha.overlay1 } 
          }
        },
        lualine_x = {
          {
            "encoding",
            color = { fg = mocha.overlay1 } 
          },
          {
            "fileformat",
            color = { fg = mocha.overlay1 } 
          },
          {
            "filetype",
            color = { fg = mocha.overlay1 } 
          },
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
