-- Headless smoke test: config loads and VeryLazy runs without errors. Exits non-zero on errors.
local IGNORE = { "mason", "tree%-sitter", "treesitter", "Unmet requirements" }
local errors = {}

local function ignored(msg)
  return vim.iter(IGNORE):any(function(pattern)
    return msg:find(pattern) ~= nil
  end)
end

local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  msg = tostring(msg)
  if level == vim.log.levels.ERROR then
    -- forwarding errors can block headless nvim on a prompt
    if not ignored(msg) then
      table.insert(errors, msg)
    end
    return
  end
  return orig_notify(msg, level, opts)
end

vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
for _, file in ipairs({ "sample.lua", "sample.md", "sample.ts" }) do
  local ok, err = pcall(vim.cmd.edit, vim.fs.joinpath(root, "fixtures", file))
  if not ok and not ignored(err) then
    table.insert(errors, err)
  end
end
vim.wait(1000)

-- v:errmsg also catches `silent!` errors (e.g. runtime ftplugins), so read :messages instead
for line in vim.api.nvim_exec2("messages", { output = true }).output:gmatch("[^\n]+") do
  if (line:match("E%d+:") or line:match("^Error")) and not ignored(line) then
    table.insert(errors, line)
  end
end

if #errors > 0 then
  io.stdout:write("smoke: " .. #errors .. " error(s)\n  " .. table.concat(errors, "\n  ") .. "\n")
  vim.cmd("cq")
end
io.stdout:write("smoke: ok\n")
vim.cmd("qa!")
