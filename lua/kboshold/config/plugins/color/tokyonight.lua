return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night",
		on_colors = function(colors)
			colors.bg = "#14141c"
		end
	},
}
