-- Smart Commit Plugin for Neovim
-- Author: kboshold

-- Import dependencies
local ui = require("kboshold.features.smart-commit.ui")
local types = require("kboshold.features.smart-commit.types")
local runner = require("kboshold.features.smart-commit.runner")
local config_loader = require("kboshold.features.smart-commit.config")

---@class SmartCommit
local M = {}

-- Default configuration
---@type SmartCommitConfig
M.config = config_loader.defaults

-- Setup function to initialize the plugin with user config
---@param opts SmartCommitConfig|nil User configuration table
function M.setup(opts)
  -- Load configuration from files
  local file_config = config_loader.load_config()
  
  -- Start with defaults, then apply file config, then apply setup opts
  M.config = vim.tbl_deep_extend("force", M.config, file_config)
  
  -- Merge user config from setup() if provided
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
  
  -- Track which buffers have already been processed
  local processed_buffers = {}
  
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "COMMIT_EDITMSG",
    callback = function(args)
      -- Check if this buffer has already been processed
      local bufnr = args.buf
      if processed_buffers[bufnr] then
        return
      end
      
      -- Mark this buffer as processed
      processed_buffers[bufnr] = true
      
      -- Check if auto_run is enabled and if SMART_COMMIT_ENABLED env var is not set to 0
      local env_disabled = vim.env.SMART_COMMIT_ENABLED == "0"
      
      if M.config.defaults.auto_run and not env_disabled then
        M.on_commit_buffer_open(bufnr)
      end
    end,
    desc = "Smart Commit activation on git commit",
  })
  
  -- Clean up processed buffers when they are deleted
  vim.api.nvim_create_autocmd("BufDelete", {
    group = augroup,
    pattern = "COMMIT_EDITMSG",
    callback = function(args)
      processed_buffers[args.buf] = nil
    end,
    desc = "Clean up Smart Commit tracking for deleted buffers",
  })
end

-- Handler for when a commit buffer is opened
function M.on_commit_buffer_open(bufnr)
  local win_id = vim.fn.bufwinid(bufnr)
  
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
  
  -- Run tasks from configuration with dependency tracking
  runner.run_tasks_with_dependencies(win_id, M.config.tasks)
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
