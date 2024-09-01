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


local function process_sections(sections)
  for name, section in pairs(sections) do
    local left = name:sub(9, 10) < 'x'
    for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
      table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
    end
    for id, comp in ipairs(section) do
      if type(comp) ~= 'table' then
        comp = { comp }
        section[id] = comp
      end
      comp.separator = left and { right = '' } or { left = '' }
    end
  end
  return sections
end

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
        section_separators = { left = '', right = '' }, -- Do i want this... 
      },
      sections = process_sections  {
        
        lualine_a = { 
          "mode"
        },
        lualine_b = { 
            function()
              -- May add recording section
              local reg = vim.fn.reg_recording()
              if reg == "" then 
                return ""
              end
              return "󰑋  @" .. reg
            end,
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
