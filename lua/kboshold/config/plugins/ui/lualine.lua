-- if true then return {} end

local colors = {
  red = '#ca1243',
  grey = '#a0a1a7',
  black = '#383a42',
  white = '#f3f3f3',
  light_green = '#83a598',
  orange = '#fe8019',
  green = '#8ec07c',
}


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

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 
          "mode"
        },
        lualine_b = { 
          { 
            empty,
            separator = { right = '' },
            color = { fg = colors.red, bg = "#181825" }
          },
          {
            function() 
              return "<A>"
            end,
            separator = { right = '' },
            color = { fg = "#ffffff", bg = "#202020" }
          },
          { 
            empty,
            separator = { right = '' },
            color = { fg = colors.red, bg = "#181825" }
          },
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
            color = { fg = colors.white, bg = colors.red } 
          },
          { 
            empty,
            separator = { right = '' },
            color = { fg = colors.red, bg = "#181825" }
          },
          {
            function() 
              return "<C>"
            end,
            separator = { right = '' },
            color = { fg = "#ffffff", bg = "#606060" }
          }


          -- { empty, color = { fg = colors.red, bg = colors.white } },
          -- {
          --   function()
          --     -- May add recording section
          --     local reg = vim.fn.reg_recording()
          --     if reg == "" then 
          --       return ""
          --     end
          --     return "󰑋  @" .. reg
          --   end,
          --   color = { fg = colors.blue, bg = colors.red } 
          -- },
          -- { empty, color = { fg = colors.green, bg = colors.blue } },
          -- {
          --   function()
          --     return "󰑋  @q"
          --   end,
          --   separator =  { right = '' },
          --   padding = { ht = 2 },
          --   color = { fg = colors.black, bg = colors.white } 
          -- },
          -- {
          --   "filename",
          --   separator = { left = 'X' },
          --   padding = { left = 2, right = 2 }

          -- },
          -- "branch",
          -- "diff",
          -- "diagnostics"
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
