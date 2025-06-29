-- Smart Commit Predefined Tasks
-- Author: kboshold

local pnpm = require("kboshold.features.smart-commit.predefined.pnpm")

---@class PredefinedTasks
local M = {}

-- Collection of predefined tasks
---@type table<string, SmartCommitTask>
M.tasks = {
  -- PNPM tasks
  ["pnpm-lint"] = pnpm.create_pnpm_task("lint", {
    label = "PNPM Lint",
    when = function() return vim.fn.filereadable("package.json") == 1 end,
  }),
  
  ["pnpm-test"] = pnpm.create_pnpm_task("test", {
    label = "PNPM Test",
    when = function() return vim.fn.filereadable("package.json") == 1 end,
  }),
  
  ["pnpm-build"] = pnpm.create_pnpm_task("build", {
    label = "PNPM Build",
    when = function() return vim.fn.filereadable("package.json") == 1 end,
  }),
  
  -- Simple example task
  ["example-task"] = {
    id = "example-task",
    label = "Example Task",
    command = "echo 'This is an example task' && exit 0",
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
