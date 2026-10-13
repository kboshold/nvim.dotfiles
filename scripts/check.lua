-- Headless health report: notify errors, :messages, LSP clients, checkhealth problems.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
local function emit(line)
  io.stdout:write(line .. "\n")
  io.stdout:flush()
end

local notified = {}
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if level and level >= vim.log.levels.WARN then
    table.insert(notified, ("[%s] %s"):format(level == vim.log.levels.ERROR and "E" or "W", tostring(msg)))
  end
  return orig_notify(msg, level, opts)
end

vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
local stats = require("lazy").stats()
emit(("plugins: %d loaded / %d total (after VeryLazy)"):format(stats.loaded, stats.count))

local files = { "sample.ts", "sample.vue", "sample.lua", "sample.md", "sample.nix", "tailwind/sample.vue" }
for _, file in ipairs(files) do
  local ok, err = pcall(vim.cmd.edit, vim.fs.joinpath(root, "fixtures", file))
  if not ok then
    table.insert(notified, "[E] open " .. file .. ": " .. err)
  end
  local buf = vim.api.nvim_get_current_buf()
  vim.wait(8000, function()
    return #vim.lsp.get_clients({ bufnr = buf }) > 0
  end, 100)
  vim.wait(1500)
  local names = vim.tbl_map(function(c)
    return c.name
  end, vim.lsp.get_clients({ bufnr = buf }))
  table.sort(names)
  local ts = pcall(vim.treesitter.get_parser, buf) and "ts" or "no-ts"
  emit(("%-20s %-5s lsp: %s"):format(file, ts, table.concat(names, ", ")))
end

for _, client in ipairs(vim.lsp.get_clients()) do
  if client:is_stopped() then
    table.insert(notified, "[E] lsp stopped: " .. client.name)
  end
end

local messages = vim.api.nvim_exec2("messages", { output = true }).output
for line in messages:gmatch("[^\n]+") do
  if line:match("[Ee]rror") or line:match("E%d+:") or line:match("[Ww]arn") then
    table.insert(notified, "[M] " .. line)
  end
end

emit(("notify/messages problems: %d"):format(#notified))
for _, line in ipairs(notified) do
  emit("  " .. line:gsub("\n", " | "):sub(1, 240))
end

vim.cmd("silent checkhealth lazy lazyvim vim.lsp nvim-treesitter")
local health = vim.api.nvim_buf_get_lines(0, 0, -1, false)
local problems = {}
local ignore = { "Unknown filetype", "luarocks", "hererocks", "lazygit", "inotify", "site/pack/core" }
for _, line in ipairs(health) do
  local ignored = vim.iter(ignore):any(function(pat)
    return line:find(pat, 1, true) ~= nil
  end)
  if not ignored and (line:match("ERROR") or line:match("WARNING")) then
    table.insert(problems, line)
  end
end
emit(("checkhealth problems: %d"):format(#problems))
for _, line in ipairs(problems) do
  emit("  " .. vim.trim(line):sub(1, 200))
end

vim.cmd("qa!")
