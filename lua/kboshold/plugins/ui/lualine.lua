return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "catppuccin",
  },
  opts = function()
    local empty = require("lualine.component"):extend()
    function empty:draw(default_highlight)
      self.status = ""
      self.applied_separator = ""
      self:apply_highlights(default_highlight)
      self:apply_section_separators()
      return self.status
    end

    local colors = require("catppuccin.palettes").get_palette()

    local left_seperator = {
      empty,
      separator = { right = "" },
      color = { bg = colors.mantle },
    }

    local right_seperator = {
      empty,
      separator = { left = "" },
      color = { bg = colors.mantle },
    }

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          "mode",
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
            separator = { right = "" },
            color = { fg = colors.base, bg = colors.red },
          },
          left_seperator,
          {
            "branch",
            separator = { right = "" },
          },
          {
            "diff",
            separator = { right = "" },
          },
          left_seperator,
          {
            "diagnostics",
            separator = { right = "" },
          },
        },
        lualine_c = {
          LazyVim.lualine.root_dir(),
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          LazyVim.lualine.pretty_path(),
          {
            "aerial",
            sep = " ", -- separator between symbols
            sep_icon = "", -- separator between icon and symbol

            -- The number of symbols to render top-down. In order to render only 'N' last
            -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
            -- be used in order to render only current symbol.
            depth = 5,

            -- When 'dense' mode is on, icons are not rendered near their symbols. Only
            -- a single icon that represents the kind of current symbol is rendered at
            -- the beginning of status line.
            dense = false,

            -- The separator to be used to separate symbols in dense mode.
            dense_sep = ".",

            -- Color the symbol icons.
            colored = true,
            color = { fg = colors.overlay1 },
          },
        },
        lualine_x = {
          {
            function()
              local status = require("sidekick.status").cli()
              return " " .. (#status > 1 and #status or "")
            end,
            cond = function()
              return package.loaded["sidekick"] ~= nil and #require("sidekick.status").cli() > 0
            end,
            color = { fg = colors.mauve },
          },
          {
            "filesize",
            color = { fg = colors.overlay1 },
          },
          {
            "encoding",
            color = { fg = colors.overlay1 },
          },
          {
            "fileformat",
            symbols = {
              unix = "LF", -- e712
              dos = "CRLF", -- e70f
              mac = "CR", -- e711
            },
            color = { fg = colors.overlay1 },
          },
        },
        lualine_y = {
          {
            "filetype",
          },
          right_seperator,
          {
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients({ bufnr = bufnr })
              if #clients == 0 then
                return ""
              end

              local icons = {
                [1] = "󰇊",
                [2] = "󰇋",
                [3] = "󰇌",
                [4] = "󰇍",
                [5] = "󰇎",
                [6] = "󰇏",
              }
              return icons[math.min(#clients, 6)] or ""
            end,
            color = { fg = colors.blue },
            padding = { left = 0, right = 1 },
          },
          right_seperator,
        },
        lualine_z = {
          right_seperator,
          {
            "searchcount",
            separator = { left = "" },
            color = { bg = colors.sky },
          },
          right_seperator,
          {
            "progress",
            separator = { left = "" },
          },
          {
            "location",
            padding = { left = 0, right = 1 },
          },
        },
      },
    }
  end,
}
