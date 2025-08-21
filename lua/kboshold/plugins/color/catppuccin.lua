return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  opts = {
    flavour = "mocha",

    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      flash = true,
      fzf = true,
      grug_far = true,
      gitsigns = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      snacks = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },

    custom_highlights = function(colors)
      local util = require("kboshold.config.util")
      local accents = {
        "rosewater",
        "flamingo",
        "pink",
        "mauve",
        "red",
        "maroon",
        "peach",
        "yellow",
        "green",
        "teal",
        "sky",
        "sapphire",
        "blue",
        "lavender",
      }

      local highlights = {
        Whitespace = { fg = util.color.lighten(colors.base, 0.06) },

        SnacksDashboardHeader = { fg = colors.lavender },
        SnacksDashboardAuthor = { fg = util.color.interpolate(colors.base, colors.lavender, 0.75) },

        CmpDocBorder = { fg = colors.surface1 },
        CmpBorder = { fg = colors.surface1 },

        CmpItemAbbr = { fg = colors.text },
        CmpItemMenu = { fg = colors.text },

        CmpPmenu = { bg = colors.base, fg = colors.text },
        CmpSel = { bg = colors.blue, fg = colors.mantle, bold = true },

        CursorLine = { bg = util.color.lighten(colors.base, 0.02) },
        ColorColumnBlue = { fg = util.color.interpolate(colors.base, colors.blue, 0.98) },
        ColorColumnRed = { fg = util.color.interpolate(colors.base, colors.red, 0.98) },

        SnacksPickerBorder = { fg = colors.lavender, bg = colors.mantle },
        SnacksPickerTree = { fg = colors.surface0 },

        SmartCommitStatus = { fg = colors.sapphire },
        SmartCommitStatusPending = { fg = colors.peach },
        SmartCommitStatusSuccess = { fg = colors.green },
        SmartCommitStatusError = { fg = colors.red },
        SmartCommitDivider = { fg = colors.overlay1 },
      }

      for _, accent in ipairs(accents) do
        local key = accent:sub(1, 1):upper() .. accent:sub(2)
        highlights["Indent" .. key] = {
          fg = util.color.interpolate(colors.base, colors[accent], 0.94),
        }
        highlights["IndentScope" .. key] = {
          fg = util.color.interpolate(colors.base, colors[accent], 0.88),
        }
      end

      return highlights
    end,
  },
  specs = {
    {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
        if (vim.g.colors_name or ""):find("catppuccin") then
          opts.highlights = require("catppuccin.groups.integrations.bufferline").get_theme()
        end
      end,
    },
  },
}
