return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha",

    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
    },

    custom_highlights = function(colors)
      return {
        Whitespace = { fg = "#27273b"},

        CmpDocBorder = { fg = "#45475a"},
        CmpBorder = { fg = "#45475a"},

        CmpItemAbbr = { fg = colors.text },
        CmpItemMenu = { fg = colors.text },

        CmpPmenu = { bg = colors.base, fg = colors.text },
        CmpSel = { bg = colors.blue, fg = colors.mantle, bold = true },
      }
    end
  },

}
