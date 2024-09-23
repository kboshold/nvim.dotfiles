return   {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = "BufEnter",
	config = function()
		local colors = {
			"Mauve",
			"Blue",
			"Peach",
			"Sky",
			"Pink",
			"Sapphire",
			"Red",
			"Green",
			"Yellow",
		}

		local indent_highlights = {}
		local scope_highlights = {}

		for i, value in ipairs(colors) do
			indent_highlights[i] = "Indent" .. value
			scope_highlights[i] = "IndentScope" .. value
		end

		require("ibl").setup {
			scope = {
				highlight = scope_highlights,
				enabled = true,
				show_exact_scope = false,
				show_start = false,
				show_end = false,
			},
			indent = {
				highlight = indent_highlights,
				char = "▏"
			},
			whitespace = {
				highlight = indent_highlights,
				remove_blankline_trail = false,
			},
		}
	end
}

