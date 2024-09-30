-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>dd", function()
-- 	local function dump(o)
-- 		if type(o) == 'table' then
-- 			local s = '{ '
-- 			for k,v in pairs(o) do
-- 				if type(k) ~= 'number' then k = '"'..k..'"' end
-- 				s = s .. '['..k..'] = ' .. dump(v) .. ','
-- 			end
-- 			return s .. '} '
-- 		else
-- 			return tostring(o)
-- 		end
-- 	end
--
-- 	-- print(dump({}))
-- 				vim.cmd("Neotree show")
-- 	local width = vim.api.nvim_win_get_width(0)
-- 	print(width)
--
-- end, {});
