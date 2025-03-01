return {
	"laytan/cloak.nvim",
	opts = {
		enabled = true,
		cloak_character = "*",
		highlight_group = "Comment",
		cloak_on_leave = true,
		patterns = {
			{
				file_pattern = {
					".env*",
					".*.env",
				},
				cloak_pattern = "=.+"
			},
		},
	},
}
