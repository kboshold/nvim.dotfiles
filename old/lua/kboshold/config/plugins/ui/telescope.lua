return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim"
	},

	config = function()

		local telescope = require('telescope')
		telescope.setup({
			pickers = {
				find_files = {
					hidden = true
				}
			},
			defaults = {
				layout_config = {
					width = function(_, max_columns)
						local percentage = 0.9
						local max = 150
						return math.min(math.floor(percentage * max_columns), max)
					end,
					height = function(_, _, max_lines)
						local percentage = 0.9
						local max = 40
						return math.min(math.floor(percentage * max_lines), max)
					end,

					vertical = { width = 0.5 }
				}
			}
		})
		telescope.load_extension("file_browser")

		-- TODO: Keymap
		local builtin = require('telescope.builtin')
		local utils = require("telescope.utils")

		-- find

		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })

		vim.keymap.set('n', '<leader>fF', function()
			builtin.find_files({ 
				cwd = utils.buffer_dir()
			})
		end, { desc = "Find Files (buffer dir)" })

		vim.keymap.set('n', '<leader>fd', function()
			telescope.extensions.file_browser.file_browser({
				cwd = utils.buffer_dir()
			})
		end, { desc = "Files browser (buffer Dir)" })

		vim.keymap.set('n', '<leader>fD', function()
			telescope.extensions.file_browser.file_browser({
				cwd = vim.uv.cwd()
			})
		end, { desc = "Files browser (cwd)" })

		vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "Find Git Files" })
		vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = "Find Word" })

		vim.keymap.set('n', '<leader>fb', function() 
			builtin.buffers({
				sort_mru = true,
				sort_lastused = true
			})
		end, { desc = "Find Buffer" })

		vim.keymap.set('n', '<leader>fr', function()
			builtin.oldfiles({
				cwd = vim.uv.cwd()
			}) 
		end, { desc = "Find Recent" })

		vim.keymap.set('n', '<leader>fR', function()
			builtin.oldfiles({
				sort_mru = true,
				sort_lastused = true
			}) 
		end, { desc = "Find Recent (all)" })

		-- search
		vim.keymap.set('n', '<leader>s"', builtin.registers, { desc = "Search registers" })


	end,
}
