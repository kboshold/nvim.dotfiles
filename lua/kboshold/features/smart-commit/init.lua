-- Smart Commit Plugin for Neovim
-- Author: kboshold

-- Import dependencies
local ui = require("kboshold.features.smart-commit.ui")
local types = require("kboshold.features.smart-commit.types")
local runner = require("kboshold.features.smart-commit.runner")

---@class SmartCommit
local M = {}

-- Default configuration
---@type SmartCommitConfig
M.config = {
  defaults = {
    auto_run = true,
    sign_column = true,
    status_window = {
      enabled = true,
      position = "bottom",
      refresh_rate = 100,
    },
  },
  tasks = {},
}

-- Setup function to initialize the plugin with user config
---@param opts SmartCommitConfig|nil User configuration table
function M.setup(opts)
  -- Merge user config with defaults
  if opts then
    M.config = vim.tbl_deep_extend("force", M.config, opts)
  end
  
  -- Only set up autocommands if enabled
  if M.config.defaults.auto_run then
    M.create_autocommands()
  end
  
  return M
end

-- Create autocommands for detecting git commit buffers
function M.create_autocommands()
  local augroup = vim.api.nvim_create_augroup("SmartCommit", { clear = true })
  
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "COMMIT_EDITMSG",
    callback = function()
      -- Check if auto_run is enabled and if SMART_COMMIT_ENABLED env var is not set to 0
      local env_disabled = vim.env.SMART_COMMIT_ENABLED == "0"
      
      if M.config.defaults.auto_run and not env_disabled then
        M.on_commit_buffer_open()
      end
    end,
    desc = "Smart Commit activation on git commit",
  })
end

-- Handler for when a commit buffer is opened
function M.on_commit_buffer_open()
  local win_id = vim.api.nvim_get_current_win()
  
  -- Show initial header
  ---@type StickyHeaderContent
  local content = {
    {
      { text = "Smart Commit ", highlight_group = "Title" },
      { text = "activated", highlight_group = "String" },
    },
    {
      { text = "Status: ", highlight_group = "Label" },
      { text = "Running tasks...", highlight_group = "DiagnosticInfo" },
    },
  }
  
  -- Show the header
  ui.set(win_id, content)
  
  -- Show a notification
  vim.notify("Smart Commit activated: Git commit buffer detected", vim.log.levels.INFO)
  
  -- Run multiple tasks for demonstration
  -- Two successful tasks
  runner.run_task(win_id, {
    id = "lint-check",
    label = "Lint Check",
    command = "sleep 2 && exit 0", -- Will succeed after 2 seconds
  })
  
  runner.run_task(win_id, {
    id = "type-check",
    label = "Type Check",
    command = "sleep 3 && exit 0", -- Will succeed after 3 seconds
  })
  
  -- Two failed tasks
  runner.run_task(win_id, {
    id = "test-run",
    label = "Test Run",
    command = "sleep 4 && exit 1", -- Will fail after 4 seconds
  })
  
  runner.run_task(win_id, {
    id = "build-check",
    label = "Build Check",
    command = "sleep 5 && exit 1", -- Will fail after 5 seconds
  })
end

-- Enable the plugin
function M.enable()
  M.config.defaults.auto_run = true
  M.create_autocommands()
  vim.notify("Smart Commit enabled", vim.log.levels.INFO)
end

-- Disable the plugin
function M.disable()
  M.config.defaults.auto_run = false
  vim.api.nvim_del_augroup_by_name("SmartCommit")
  vim.notify("Smart Commit disabled", vim.log.levels.INFO)
end

-- Toggle the plugin state
function M.toggle()
  if M.config.defaults.auto_run then
    M.disable()
  else
    M.enable()
  end
end

-- Initialize with default settings if not explicitly set up
M.setup()

return M
