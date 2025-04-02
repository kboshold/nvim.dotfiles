return {
	"snacks.nvim",
	opts = {
		dashboard = {
			preset = {
				pick = function(cmd, opts)
					return LazyVim.pick(cmd, opts)()
				end,

				-- stylua: ignore
				---@type snacks.dashboard.Item[]
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{
					text = {
						table.concat({
							"    ⠰⠿⠆⠾⠿⠿⠿⣶⣤                 ⢰⣶⣶⣶⣶⣶⣶⣦⣄                     ",
							"    ⠰⠾⠶⠲⠆⠾⠿⢿⣿⡇ ⢀⣤⣴⣶⣦⣄⡀  ⣠⣴⣶⣤⣄⡀⢸⣿⣿⠉⠉⠉⠙⢿⣿⣧  ⣀⣤⣶⣦⣤⡀ ⣤⣤⡀   ⣠⣤⡀  ",
							"    ⠶⠶⠶⠖⠶⠶⣶⣾⡿⠃⣰⣿⡿⠛⠛⠛⢿⣿⡄⣾⣿⡏⠉⠙⠿⠇⢸⣿⣿    ⠈⣿⣿⡆⣼⣿⠟⠛⠛⢿⣿⣆⢹⣿⣧  ⢰⣿⡿   ",
							"  ⠰⠶⠆⠶⠶⠶⠶⠶⠿⢿⣷⡄⣿⣿⠁   ⢸⣿⣿⠘⠿⣿⣿⣶⣦⡀⢸⣿⣿    ⢀⣿⣿⢳⣿⣿⣿⣿⣿⣿⣿⡿ ⢻⣿⣧⢠⣿⡿⠁   ",
							"   ⠶⠶⠶⠆⠶⠆⠶⠶⣾⣿⡇⢻⣿⣧⣀⣀⣠⣾⣿⠏⣴⣤⡀⠈⢙⣿⣿⢸⣿⣿⣀⣀⣀⣠⣾⣿⡟⠈⢿⣿⣄⣀⣀⣀⣤⡀  ⢻⣿⣿⡿⠁    ",
							"   ⢶⣶⣶⣶⠆⢶⣶⣶⠿⠛  ⠙⠿⠿⣿⠿⠟⠋ ⠙⠿⠿⣿⠿⠟⠁⠸⠿⠿⠿⠿⠿⠿⠟⠋  ⠈⠛⠿⢿⣿⠿⠟⠁   ⠻⠿⠃     ",
						}, "\n"),
						hl = "SnacksDashboardHeader",
						align = "center"
					},
					gap = 0,
					padding = 0
				},
				{
					text = {
						"by kboshold",
						hl = "SnacksDashboardAuthor",
						align = "center"
					},
					gap = 0,
					padding = {3,0}
				},
				{ section = "keys", gap = 1, padding = 3 },
				{ section = "startup", padding = 3 },
			},
		},
	},
}
