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
				Whitespace = { fg = util.color.lighten(colors.base, 0.08)},

				CmpDocBorder = { fg = "#45475a"},
				CmpBorder = { fg = "#45475a"},

				CmpItemAbbr = { fg = colors.text },
				CmpItemMenu = { fg = colors.text },

				CmpPmenu = { bg = colors.base, fg = colors.text },
				CmpSel = { bg = colors.blue, fg = colors.mantle, bold = true },
			}

			for _, accent in ipairs(accents) do
				local key = accent:sub(1, 1):upper() .. accent:sub(2)
				highlights["Indent" .. key] = {
					fg = util.color.interpolate(colors.base, colors[accent], 0.92)
				}
				highlights["IndentScope" .. key] = {
					fg = util.color.interpolate(colors.base, colors[accent], 0.8)
				}
			end

			return highlights;
		end
	},

}
