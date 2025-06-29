-- Smart Commit Predefined Tasks
-- Author: kboshold

local pnpm = require("kboshold.features.smart-commit.predefined.pnpm")

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
    command = "echo 'This is an example task'",
  },
}

-- Get a predefined task by ID
---@param id string The task ID
---@return SmartCommitTask|nil The task or nil if not found
function M.get(id)
  return M.tasks[id]
end

-- Register a new predefined task
---@param id string The task ID
---@param task SmartCommitTask The task definition
function M.register(id, task)
  M.tasks[id] = task
end

return M
