-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "


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


--  print(dump(vim.diagnostic.serverity))
  -- print(dump(vim.diagnostic.config().signs))
  local extmark = vim.api.nvim_buf_get_extmarks(0, 20, 0, -1, {type = 'sign', details=true})
  print(dump(vim.fn.sign_getdefined()[1]))



end, {});
