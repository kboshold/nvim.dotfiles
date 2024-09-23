return {
	"laytan/cloak.nvim",
	config = function()
		-- TODO: May add keybindings -> Will i ever remeber themn?! May add a keybinding for Screen Sharing.
		require("cloak").setup({
			enabled = true,
			cloak_character = "*", -- TODO: May use nerdfont
			highlight_group = "Comment",
			patterns = {
				{
					file_pattern = {
						".env*",
						".*.env",
					},
					cloak_pattern = "=.+"
				},
			},
		})
	end
}
