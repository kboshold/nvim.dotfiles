return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  opts = {
    flavour = "mocha",

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

        CursorLine = { bg = util.color.interpolate(colors.base, colors.lavender, 0.96) },
        ColorColumnBlue = { fg = util.color.interpolate(colors.base, colors.blue, 0.98) },
        ColorColumnRed = { fg = util.color.interpolate(colors.base, colors.red, 0.98) },

        SnacksPickerBorder = { fg = colors.lavender, bg = colors.mantle },
        SnacksPickerTree = { fg = colors.surface0 },

        DiffAdd = { bg = util.color.interpolate(colors.base, colors.green, 0.92) },
        DiffDelete = {
          bg = util.color.interpolate(colors.base, colors.red, 0.98),
          fg = util.color.interpolate(colors.base, colors.red, 0.92),
        },
        DiffChange = { bg = util.color.interpolate(colors.base, colors.mauve, 0.9) },
        DiffText = { bg = util.color.interpolate(colors.base, colors.mauve, 0.75) },

        Folded = { bg = util.color.interpolate(colors.base, colors.sapphire, 0.92) },
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
}
