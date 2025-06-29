-- Smart Commit Copilot Tasks
-- Author: kboshold

local M = {}

-- Get the current Git branch name
---@return string|nil The current branch name or nil if not in a Git repository
local function get_current_branch()
  local result = vim.fn.system("git rev-parse --abbrev-ref HEAD")
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get current Git branch", vim.log.levels.WARN)
    return nil
  end
  return vim.trim(result)
end

-- Get the staged changes as a diff
---@return string The staged changes as a diff
local function get_staged_changes()
  local result = vim.fn.system("git diff --staged")
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get staged changes", vim.log.levels.WARN)
    return ""
  end
  return result
end

-- Parse branch name to determine commit type and scope
---@param branch_name string The branch name to parse
---@return string type The commit type (feat, fix, etc.)
---@return string|nil scope The commit scope or nil if not found
local function parse_branch_name(branch_name)
  -- Default values
  local type = "feat"
  local scope = nil
  
  -- Try to match branch pattern: feat/scope, feature/scope, bugfix/scope, hotfix/scope
  local pattern = "^(feat|feature|bugfix|hotfix)/([a-zA-Z0-9_-]+)"
  local branch_type, branch_scope = branch_name:match(pattern)
  
  if branch_type then
    -- Normalize "feature" to "feat"
    if branch_type == "feature" then
      type = "feat"
    else
      type = branch_type
    end
    
    -- Check if scope is purely numeric (issue number)
    if branch_scope:match("^%d+$") then
      scope = "#" .. branch_scope
    else
      scope = branch_scope
    end
  end
  
  return type, scope
end

-- Construct the commit prefix based on type and scope
---@param type string The commit type
---@param scope string|nil The commit scope
---@return string The formatted commit prefix
local function construct_commit_prefix(type, scope)
  if scope then
    return type .. "(" .. scope .. "): "
  else
    return type .. ": "
  end
end

-- Generate a commit message using Copilot
---@param prefix string The commit prefix (e.g., "feat(scope): ")
---@param staged_diff string The staged changes as a diff
---@return string The generated commit message
local function generate_commit_message(prefix, staged_diff)
  -- Check if CopilotChat is available
  if not pcall(require, "CopilotChat") then
    vim.notify("CopilotChat.nvim is not available", vim.log.levels.ERROR)
    return prefix .. "Add changes"
  end
  
  local CopilotChat = require("CopilotChat")
  
  -- Limit the diff size to avoid overwhelming Copilot
  local max_diff_size = 5000
  if #staged_diff > max_diff_size then
    staged_diff = staged_diff:sub(1, max_diff_size) .. "\n... (diff truncated)"
  end
  
  -- Construct the prompt for Copilot
  local prompt = string.format([[
Given the commit prefix `%s`, write a concise and informative commit message subject and body based on the following staged changes:

%s

Format your response as a complete commit message with a subject line (max 72 chars) and an optional body separated by a blank line.
Do not include the prefix in your response, as I will add it automatically.
Focus on WHAT changed and WHY, not HOW.
]], prefix, staged_diff)

  -- Call Copilot to generate the message
  local response = CopilotChat.ask(prompt, {})
  
  -- Process the response
  if response and response ~= "" then
    -- Remove any markdown formatting that might be in the response
    response = response:gsub("```[%w]*\n", ""):gsub("```", "")
    return prefix .. response
  else
    return prefix .. "Add changes"
  end
end

-- Task to generate a commit message
---@type SmartCommitTask
M.generate_commit_message = {
  id = "generate-commit-message",
  label = "Generate Commit Message",
  icon = "󰚩",
  command = function()
    -- Get the current branch name
    local branch_name = get_current_branch()
    if not branch_name then
      return "echo 'Failed to get current branch'"
    end
    
    -- Parse branch name to get type and scope
    local type, scope = parse_branch_name(branch_name)
    
    -- Construct the commit prefix
    local prefix = construct_commit_prefix(type, scope)
    
    -- Get staged changes
    local staged_diff = get_staged_changes()
    
    -- Generate the commit message
    local commit_message = generate_commit_message(prefix, staged_diff)
    
    -- Insert the commit message into the buffer
    local bufnr = vim.fn.bufnr("COMMIT_EDITMSG")
    if bufnr ~= -1 then
      -- Clear the buffer first (except for any comments)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local comment_start_line = 0
      for i, line in ipairs(lines) do
        if line:match("^%s*#") then
          comment_start_line = i - 1
          break
        end
      end
      
      if comment_start_line > 0 then
        vim.api.nvim_buf_set_lines(bufnr, 0, comment_start_line, false, {})
      end
      
      -- Insert the commit message
      local message_lines = {}
      for line in commit_message:gmatch("[^\r\n]+") do
        table.insert(message_lines, line)
      end
      
      vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, message_lines)
      
      return "echo 'Commit message generated'"
    else
      return "echo 'COMMIT_EDITMSG buffer not found'"
    end
  end,
}

-- Task to analyze staged changes
---@type SmartCommitTask
M.analyze_staged = {
  id = "analyze-staged",
  label = "Analyze Staged Changes",
  icon = "󰌵",
  command = function()
    -- Get staged changes
    local staged_diff = get_staged_changes()
    if staged_diff == "" then
      return "echo 'No staged changes to analyze'"
    end
    
    -- Check if CopilotChat is available
    if not pcall(require, "CopilotChat") then
      vim.notify("CopilotChat.nvim is not available", vim.log.levels.ERROR)
      return "echo 'CopilotChat.nvim is not available'"
    end
    
    local CopilotChat = require("CopilotChat")
    
    -- Limit the diff size
    local max_diff_size = 5000
    if #staged_diff > max_diff_size then
      staged_diff = staged_diff:sub(1, max_diff_size) .. "\n... (diff truncated)"
    end
    
    -- Construct the prompt for Copilot
    local prompt = string.format([[
Analyze the following staged changes for potential issues:
1. Debug statements (console.log, print, etc.)
2. Commented-out code
3. Obvious errors or bugs
4. TODOs or FIXMEs
5. Sensitive information (API keys, tokens, etc.)

Provide a brief summary of any issues found:

%s
]], staged_diff)

    -- Call Copilot to analyze the changes
    local response = CopilotChat.ask(prompt, {})
    
    -- Process the response
    if response and response ~= "" then
      -- Remove any markdown formatting
      response = response:gsub("```[%w]*\n", ""):gsub("```", "")
      
      -- Create a temporary buffer to show the analysis
      local analysis_bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(analysis_bufnr, "buftype", "nofile")
      vim.api.nvim_buf_set_option(analysis_bufnr, "bufhidden", "wipe")
      vim.api.nvim_buf_set_name(analysis_bufnr, "SmartCommit-Analysis")
      
      -- Split the response into lines
      local analysis_lines = {}
      for line in response:gmatch("[^\r\n]+") do
        table.insert(analysis_lines, line)
      end
      
      -- Set the buffer content
      vim.api.nvim_buf_set_lines(analysis_bufnr, 0, -1, false, analysis_lines)
      
      -- Open the buffer in a split
      vim.cmd("split")
      vim.api.nvim_win_set_buf(0, analysis_bufnr)
      
      return "echo 'Analysis complete'"
    else
      return "echo 'Failed to analyze staged changes'"
    end
  end,
}

return M
