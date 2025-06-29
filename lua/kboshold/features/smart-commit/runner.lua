-- Smart Commit Task Runner
-- Author: kboshold

local ui = require("kboshold.features.smart-commit.ui")
local utils = require("kboshold.features.smart-commit.utils")

---@class SmartCommitRunner
local M = {}

-- Task states
M.TASK_STATE = {
  PENDING = "pending",
  RUNNING = "running",
  SUCCESS = "success",
  FAILED = "failed",
}

-- Current task state
---@type table<string, {state: string, output: string, start_time: number}>
M.tasks = {}

-- Timer for UI updates
local update_timer = nil

-- Define signs for the sign column
local function setup_signs()
  vim.fn.sign_define("SmartCommitRunning", { text = utils.ICONS.RUNNING, texthl = "DiagnosticInfo" })
  vim.fn.sign_define("SmartCommitSuccess", { text = utils.ICONS.SUCCESS, texthl = "DiagnosticOk" })
  vim.fn.sign_define("SmartCommitError", { text = utils.ICONS.ERROR, texthl = "DiagnosticError" })
  vim.fn.sign_define("SmartCommitWarning", { text = utils.ICONS.WARNING, texthl = "DiagnosticWarn" })
  
  -- Signs with count
  for i = 1, 9 do
    vim.fn.sign_define("SmartCommitError" .. i, { text = utils.ICONS.ERROR .. i, texthl = "DiagnosticError" })
    vim.fn.sign_define("SmartCommitSuccess" .. i, { text = utils.ICONS.SUCCESS .. i, texthl = "DiagnosticOk" })
  end
end

-- Initialize signs
setup_signs()

-- Run a simple task
---@param win_id number The window ID of the commit buffer
---@param task SmartCommitTask The task to run
function M.run_task(win_id, task)
  -- Initialize task state
  M.tasks[task.id] = {
    state = M.TASK_STATE.RUNNING,
    output = "",
    start_time = vim.loop.now(),
  }
  
  -- Start UI update timer if not already running
  M.start_ui_updates(win_id)
  
  -- Run the task asynchronously
  vim.system({
    "sleep", "5", -- Hardcoded sleep command for now
  }, {
    stdout = function(err, data)
      if data then
        M.tasks[task.id].output = M.tasks[task.id].output .. data
      end
    end,
    stderr = function(err, data)
      if data then
        M.tasks[task.id].output = M.tasks[task.id].output .. data
      end
    end,
  }, function(obj)
    -- Update task state based on exit code
    if obj.code == 0 then
      M.tasks[task.id].state = M.TASK_STATE.SUCCESS
    else
      M.tasks[task.id].state = M.TASK_STATE.FAILED
    end
    
    -- Update UI with the final state
    vim.schedule(function()
      M.update_ui(win_id)
      M.update_signs(win_id)
      
      -- Stop timer if all tasks are complete
      if M.all_tasks_complete() then
        M.stop_ui_updates()
      end
    end)
  end)
  
  -- Update signs immediately
  M.update_signs(win_id)
end

-- Check if all tasks are complete
function M.all_tasks_complete()
  for _, task in pairs(M.tasks) do
    if task.state == M.TASK_STATE.RUNNING or task.state == M.TASK_STATE.PENDING then
      return false
    end
  end
  return true
end

-- Start periodic UI updates
---@param win_id number The window ID of the commit buffer
function M.start_ui_updates(win_id)
  if update_timer then
    return
  end
  
  update_timer = vim.loop.new_timer()
  update_timer:start(0, 100, function()  -- Changed to 100ms for faster animation
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(win_id) then
        -- Advance the spinner frame once per update cycle
        utils.advance_spinner_frame()
        
        -- Update UI and signs
        M.update_ui(win_id)
        M.update_signs(win_id)
      else
        M.stop_ui_updates()
      end
    end)
  end)
end

-- Stop UI updates
function M.stop_ui_updates()
  if update_timer then
    update_timer:stop()
    update_timer:close()
    update_timer = nil
  end
end

-- Update signs in the commit buffer
---@param win_id number The window ID of the commit buffer
function M.update_signs(win_id)
  local buf_id = vim.api.nvim_win_get_buf(win_id)
  
  -- Clear existing signs
  vim.fn.sign_unplace("SmartCommitSigns", { buffer = buf_id })
  
  -- Count tasks by state
  local running_count = 0
  local error_count = 0
  local success_count = 0
  
  for _, task in pairs(M.tasks) do
    if task.state == M.TASK_STATE.RUNNING then
      running_count = running_count + 1
    elseif task.state == M.TASK_STATE.FAILED then
      error_count = error_count + 1
    elseif task.state == M.TASK_STATE.SUCCESS then
      success_count = success_count + 1
    end
  end
  
  -- Place appropriate sign
  if running_count > 0 then
    -- Use the current spinner frame for the running sign
    vim.fn.sign_define("SmartCommitRunning", { text = utils.get_current_spinner_frame(), texthl = "DiagnosticInfo" })
    vim.fn.sign_place(0, "SmartCommitSigns", "SmartCommitRunning", buf_id, { lnum = 1 })
  elseif error_count > 0 then
    local sign_name = "SmartCommitError"
    if error_count > 1 and error_count <= 9 then
      sign_name = sign_name .. error_count
    end
    vim.fn.sign_place(0, "SmartCommitSigns", sign_name, buf_id, { lnum = 1 })
  elseif success_count > 0 then
    local sign_name = "SmartCommitSuccess"
    if success_count > 1 and success_count <= 9 then
      sign_name = sign_name .. success_count
    end
    vim.fn.sign_place(0, "SmartCommitSigns", sign_name, buf_id, { lnum = 1 })
  end
  
  -- Force a redraw to update the sign column immediately
  vim.cmd("redrawstatus")
  vim.cmd("redraw!")
end

-- Update the UI with current task states
---@param win_id number The window ID of the commit buffer
function M.update_ui(win_id)
  -- Create header content based on task states
  ---@type StickyHeaderContent
  local content = {
    {
      { text = "Smart Commit ", highlight_group = "Title" },
      { text = "Tasks", highlight_group = "String" },
    },
  }
  
  -- Check if any task is running
  local any_running = false
  for _, task in pairs(M.tasks) do
    if task.state == M.TASK_STATE.RUNNING then
      any_running = true
      break
    end
  end
  
  -- Add status line with spinner if any task is running
  if any_running then
    table.insert(content, {
      { text = "Status: ", highlight_group = "Label" },
      { text = utils.get_current_spinner_frame() .. " Running tasks...", highlight_group = "DiagnosticInfo" },
    })
  else
    -- Check if any task failed
    local any_failed = false
    for _, task in pairs(M.tasks) do
      if task.state == M.TASK_STATE.FAILED then
        any_failed = true
        break
      end
    end
    
    if any_failed then
      table.insert(content, {
        { text = "Status: ", highlight_group = "Label" },
        { text = utils.ICONS.ERROR .. " Some tasks failed", highlight_group = "DiagnosticError" },
      })
    else
      table.insert(content, {
        { text = "Status: ", highlight_group = "Label" },
        { text = utils.ICONS.SUCCESS .. " All tasks completed", highlight_group = "DiagnosticOk" },
      })
    end
  end
  
  -- Get task keys and sort them
  local task_keys = {}
  for id, _ in pairs(M.tasks) do
    table.insert(task_keys, id)
  end
  table.sort(task_keys)
  
  -- Add task status lines
  local task_count = #task_keys
  for i, id in ipairs(task_keys) do
    local task_state = M.tasks[id]
    local status_text = ""
    local status_hl = ""
    local border_char = utils.BORDERS.MIDDLE
    
    -- Use bottom border for the last task
    if i == task_count then
      border_char = utils.BORDERS.BOTTOM
    end
    
    if task_state.state == M.TASK_STATE.RUNNING then
      status_text = utils.get_current_spinner_frame() .. " Running..."
      status_hl = "DiagnosticInfo"
    elseif task_state.state == M.TASK_STATE.SUCCESS then
      status_text = utils.ICONS.SUCCESS .. " Success"
      status_hl = "DiagnosticOk"
    elseif task_state.state == M.TASK_STATE.FAILED then
      status_text = utils.ICONS.ERROR .. " Failed"
      status_hl = "DiagnosticError"
    else
      status_text = "Pending"
      status_hl = "Comment"
    end
    
    table.insert(content, {
      { text = border_char .. " ", highlight_group = "Comment" },
      { text = "Task: ", highlight_group = "Label" },
      { text = id .. " ", highlight_group = "Identifier" },
      { text = status_text, highlight_group = status_hl },
    })
  end
  
  -- Update the header
  ui.set(win_id, content)
end

return M
