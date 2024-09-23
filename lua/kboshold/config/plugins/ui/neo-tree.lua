vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		vim.diagnostic.severity["I"] = vim.diagnostic.severity.INFO
		vim.diagnostic.severity["H"] = vim.diagnostic.severity.HINT
		vim.diagnostic.severity["W"] = vim.diagnostic.severity.WARN
		vim.diagnostic.severity["E"] = vim.diagnostic.severity.ERROR

		-- automatically open for no arguments (current directory) and when a directory will be opend
		local first_buf_enter = 1;
		local function on_buf_enter(data)
			if first_buf_enter == 0 then
				return
			end
			first_buf_enter = 0;

			local is_directory = vim.fn.isdirectory(data.file) == 1
			local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
			local is_stream = vim.g.ux_piped_input == 1

			if is_stream then
				return
			end

			if not (is_directory or no_name) then
				return
			end

			require("neo-tree.command").execute({ action = "show" })
		end
		vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = on_buf_enter })

	end,
	opts = {
		close_if_last_window = true,
		enable_git_status = true,
		enable_diagnostics = true,
		sources = { "filesystem", "buffers", "git_status" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible  = true,
				hide_dotfiles = false,
				never_show = { "node_modules", ".git" },
			}
		},
		source_selector = {
			padding = 2
		},
		default_component_configs = {
			container = { enable_character_fade = true },
			indent = {
				with_expanders = true,
			},
			modified = {
				symbol = ""
			},
			git_status = {
				symbols = {
					added     = "", -- Will be green
					modified  = "", -- Will be orange
					deleted   = "D",
					renamed   = "R",
					untracked = "U",
					ignored   = "", -- Will be gray
					unstaged  = "M",
					staged    = "M",
					conflict  = "C",

				},
			},
			file_size = {
				enabled = false
			},
			type = {
				enabled = false
			},
			last_modified = {
				enabled = false
			},
			created = {
				enabled = false
			}
		},
		window = {
			position = "left",
			width = 38
		},
	},
}
