if true then return {} end
return {
	"echasnovski/mini.indentscope",
	version = false, -- wait till new 0.7.0 release to put it back on semver
	-- event = "LazyFile",
	opts = {
		symbol = "▏",
		options = { try_as_border = true },
		draw = {
			animation = function() 
				return 0 
			end
		}
	},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"alpha",
				"dashboard",
				"fzf",
				"help",
				"lazy",
				"lazyterm",
				"mason",
				"neo-tree",
				"notify",
				"toggleterm",
				"Trouble",
				"trouble",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end
}
