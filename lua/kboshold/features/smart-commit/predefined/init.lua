-- Smart Commit Predefined Tasks
-- Author: kboshold

local pnpm = require("kboshold.features.smart-commit.predefined.pnpm")
local copilot = require("kboshold.features.smart-commit.predefined.copilot")

---@class PredefinedTasks
local M = {}

-- Collection of predefined tasks
---@type table<string, SmartCommitTask>
M.tasks = {
  -- Base PNPM task for extension
  ["pnpm"] = pnpm.base_task,
  
  -- Simple example task
  ["example-task"] = {
    id = "example-task",
    label = "Example Task",
    icon = "󰛨",
    command = "echo 'This is an example task'",
  },
  
  -- Copilot tasks
  ["generate-commit-message"] = copilot.generate_commit_message,
  ["analyze-staged"] = copilot.analyze_staged,
}

-- Get a predefined task by ID
---@param id string The task ID
---@return SmartCommitTask|nil The task or nil if not found
function M.get(id)
  -- Debug logging
  vim.notify("Looking for predefined task: " .. id, vim.log.levels.DEBUG)
  vim.notify("Available predefined tasks: " .. vim.inspect(vim.tbl_keys(M.tasks)), vim.log.levels.DEBUG)
  
  local task = M.tasks[id]
  if task then
    vim.notify("Found predefined task: " .. id, vim.log.levels.DEBUG)
  else
    vim.notify("Predefined task not found: " .. id, vim.log.levels.WARN)
  end
  
  return task
end

-- Register a new predefined task
---@param id string The task ID
---@param task SmartCommitTask The task definition
function M.register(id, task)
  M.tasks[id] = task
  vim.notify("Registered predefined task: " .. id, vim.log.levels.DEBUG)
end

return M
