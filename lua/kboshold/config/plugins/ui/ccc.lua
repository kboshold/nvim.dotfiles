return {
	"uga-rosa/ccc.nvim",
	init = function() 
		local ccc = require("ccc")
		local mapping = ccc.mapping

		ccc.setup({
			highlighter = {
				auto_enable = true,
				lsp = true,
			}
		})
	end
}
