return {
	"mbbill/undotree",

	config = function() 
		-- TODO: Keymap
		-- Keymap.Desc: Shows the undotree
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
	end
}
