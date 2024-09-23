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
				Whitespace = { fg = util.color.lighten(colors.base, 0.06)},

				CmpDocBorder = { fg = colors.surface1},
				CmpBorder = { fg = colors.surface1},

				CmpItemAbbr = { fg = colors.text },
				CmpItemMenu = { fg = colors.text },

				CmpPmenu = { bg = colors.base, fg = colors.text },
				CmpSel = { bg = colors.blue, fg = colors.mantle, bold = true },
			}

			for _, accent in ipairs(accents) do
				local key = accent:sub(1, 1):upper() .. accent:sub(2)
				highlights["Indent" .. key] = {
					fg = util.color.interpolate(colors.base, colors[accent], 0.94)
				}
				highlights["IndentScope" .. key] = {
					fg = util.color.interpolate(colors.base, colors[accent], 0.88)
				}
			end

			return highlights;
		end
	},

}
