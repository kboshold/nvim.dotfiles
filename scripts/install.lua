-- Headless: install mason tools + treesitter parsers and wait for completion.
local registry = require("mason-registry")
local wanted = vim.list_extend({ "tree-sitter-cli" }, LazyVim.opts("mason.nvim").ensure_installed or {})
local map = require("mason-lspconfig").get_mappings().lspconfig_to_package
for name, server in pairs(LazyVim.opts("nvim-lspconfig").servers or {}) do
  if type(server) == "table" and server.enabled ~= false and server.mason ~= false and map[name] then
    table.insert(wanted, map[name])
  end
end

local function pending()
  local left = {}
  for _, name in ipairs(wanted) do
    local ok, pkg = pcall(registry.get_package, name)
    if ok and not pkg:is_installed() then
      if not pkg:is_installing() then
        pkg:install()
      end
      table.insert(left, name)
    end
  end
  return left
end

registry.refresh(function()
  vim.g.mason_refreshed = true
end)
vim.wait(60000, function()
  return vim.g.mason_refreshed
end, 200)
vim.wait(600000, function()
  return #pending() == 0
end, 2000)
print("mason pending: " .. table.concat(pending(), ", "))

local parsers = LazyVim.opts("nvim-treesitter").ensure_installed or {}
require("nvim-treesitter").install(parsers):wait(600000)
vim.cmd("qa!")
