-- Smart Commit PNPM Task Factory
-- Author: kboshold

local M = {}

-- Flag to track if pnpm install has been checked/run in this session
local _pnpm_install_checked = false

-- Create a PNPM task with memoization for install check
---@param cmd string The PNPM command to run (e.g., "lint", "test")
---@param opts? table Additional options for the task
---@return SmartCommitTask The configured task
function M.create_pnpm_task(cmd, opts)
  opts = opts or {}
  
  -- Create the task
  ---@type SmartCommitTask
  local task = {
    id = "pnpm-" .. cmd,
    label = "PNPM " .. cmd:gsub("^%l", string.upper),
    command = function()
      -- Check if we need to run pnpm install first
      if not _pnpm_install_checked then
        -- Check if node_modules exists
        local node_modules_exists = vim.fn.isdirectory("node_modules") == 1
        
        if not node_modules_exists then
          -- Run pnpm install first
          vim.notify("Running pnpm install before " .. cmd, vim.log.levels.INFO)
          local install_result = vim.fn.system("pnpm install")
          
          if vim.v.shell_error ~= 0 then
            vim.notify("pnpm install failed: " .. install_result, vim.log.levels.ERROR)
            return "exit 1" -- Return a command that will fail
          end
        end
        
        -- Set the flag to true so we don't check again in this session
        _pnpm_install_checked = true
      end
      
      -- Check if the script exists in package.json
      local package_json = vim.fn.filereadable("package.json") == 1 and vim.fn.json_decode(vim.fn.readfile("package.json")) or {}
      local scripts = package_json.scripts or {}
      
      if scripts[cmd] then
        return "pnpm " .. cmd
      else
        vim.notify("Script '" .. cmd .. "' not found in package.json", vim.log.levels.ERROR)
        return "exit 1" -- Return a command that will fail
      end
    end,
  }
  
  -- Merge with provided options
  if opts then
    for k, v in pairs(opts) do
      task[k] = v
    end
  end
  
  return task
end

-- Reset the install check flag (useful for testing)
function M.reset_install_check()
  _pnpm_install_checked = false
end

return M
