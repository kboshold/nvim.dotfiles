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

    local left_seperator =  {
      empty,
      separator = { right = '' },
      color = { bg = mocha.mantle }
    }

    local right_seperator =  {
      empty,
      separator = { left = '' },
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
          left_seperator,
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
          left_seperator,
          {
            "branch",
            separator = { right = '' },
          },
          {
            "diff",
            separator = { right = '' },
          },
          left_seperator,
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
            symbols = {
              unix = 'LF', -- e712
              dos = 'CRLF',  -- e70f
              mac = 'CR',  -- e711
            },
            color = { fg = mocha.overlay1 }
          },
        },
        lualine_y = {
          {
            "filetype",
          },
          {
            function()
              return ""
            end,
            color = function()
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients({ bufnr = bufnr })
              if clients ~= nil and #clients > 0 then
                return { fg = mocha.green }
              else
                return { fg = mocha.red }
              end
            end,
            padding = { left = 0, right = 1 }
          },
          right_seperator,
        },
        lualine_z = {
          'searchcount',
          {
            "location",
            padding = { left = 1, right = 1 }
          },
        }
      }
    }
  end,
}
