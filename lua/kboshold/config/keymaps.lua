-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.keymap.set("", "<ScrollWheelUp>", "<C-e>")
vim.keymap.set("", "<ScrollWheelDown>", "<C-y>")

vim.keymap.set("n", "<leader>j", "<C-e>")
vim.keymap.set("n", "<leader>k", "<C-y>")

vim.keymap.set("n", "<leader>dd", function()
	local function dump(o)
		if type(o) == 'table' then
			local s = '{ '
			for k,v in pairs(o) do
				if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. '['..k..'] = ' .. dump(v) .. ','
			end
			return s .. '} '
		else
			return tostring(o)
		end
	end

	print(dump(colors))

end, {});
