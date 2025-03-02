return {
	"CopilotC-Nvim/CopilotChat.nvim",
	opts = function()
		local user = vim.env.USER or "User"
		return {
			auto_insert_mode = true,
			model = "claude-3.7-sonnet",
			question_header = "  " .. user .. " ",
			answer_header = "  copilot ",
			error_header = " error",
			window = {
				layout = "vertical",
				width = 0.3,
			},
		}
	end,
	config = function(_, opts)
		local chat = require("CopilotChat")

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-chat",
			callback = function()
				vim.opt_local.relativenumber = true
				vim.opt_local.number = true
				vim.opt_local.signcolumn = 'no'
				vim.opt_local.wrap = true
				vim.opt_local.numberwidth = 3
			end,
		})

		chat.setup(opts)
	end,

	keys = {
		{ "<c-s>",     "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
		{ "<leader>a", "",     desc = "+ai",        mode = { "n", "v" } },
		-- CopilotChat keymaps
		{
			"<leader>at",
			function()
				return require("CopilotChat").toggle()
			end,
			desc = "Toggle (CopilotChat)",
			mode = { "n", "v" },
		},
		{
			"<leader>aa",
			function()
				local found = false
				for _, win in pairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "copilot-chat" then
						vim.api.nvim_set_current_win(win)
						vim.cmd("normal! G$a")
						found = true
						break
					end
				end

				if not found then
					require("CopilotChat").toggle()
				end
			end,
			desc = "Ask/Toggle (CopilotChat)",
			mode = { "n", "v" },
		},
		{
			"<leader>ax",
			function()
				return require("CopilotChat").reset()
			end,
			desc = "Clear (CopilotChat)",
			mode = { "n", "v" },
		},
		{
			"<leader>aq",
			function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input)
				end
			end,
			desc = "Quick Chat (CopilotChat)",
			mode = { "n", "v" },
		},
	}
}
