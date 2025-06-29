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

-- Parse branch name to determine commit scope
---@param branch_name string The branch name to parse
---@return string|nil scope The commit scope or nil if not found
local function get_commit_scope()
  local branch = get_current_branch()
  if not branch then
    return nil
  end
  
  local scope = ""
  if branch ~= "main" and branch ~= "develop" then
    scope = branch:match("^[^/]+/(.+)")

    if scope and scope:match("%-") then
      local ticket_num = scope:match("^(%d+)%-?")
      if ticket_num then
        scope = "#" .. ticket_num
      else
        local jira_ticket = scope:match("^([A-Z]+%-[0-9]+)%-?")
        if jira_ticket then
          scope = jira_ticket
        else
          scope = "#" .. scope:match("^([^-]+)")
        end
      end
    end
  end

  return scope
end

-- Task to generate a commit message
---@type SmartCommitTask
M.generate_commit_message = {
  id = "generate-commit-message",
  label = "Generate Commit Message",
  icon = "󰚩",
  command = function()
    -- Get commit scope from branch name
    local scope = get_commit_scope()
    
    -- Get staged changes
    local staged_diff = get_staged_changes()
    
    -- Check if CopilotChat is available
    if not pcall(require, "CopilotChat") then
      vim.notify("CopilotChat.nvim is not available", vim.log.levels.ERROR)
      return "echo 'CopilotChat.nvim is not available'"
    end
    
    local CopilotChat = require("CopilotChat")
    local bufnr = vim.fn.bufnr("COMMIT_EDITMSG")
    
    if bufnr == -1 then
      return "echo 'COMMIT_EDITMSG buffer not found'"
    end
    
    -- Construct the prompt for Copilot based on the old prompt.lua
    local prompt = [[
Write a conventional commits style (https://www.conventionalcommits.org/en/v1.0.0/) commit message for my changes. Please create only the code block without further explanations.

**Requirements:**

- Title: under 50 characters and talk imperative. Follow this rule: If applied, this commit will <commit message>
- Body: wrap at 72 characters
- Include essential information only
- Format as `gitcommit` code block
- Prepend a header with the lines to replace. It should only replace the lines in font of the first comment.
- Use `]] .. (scope or "") .. [[` as the scope. If the scope is empty then skip it. If it includes a `#`, also add it in the scope.
- End the commit body with a newline followed by 52 hyphens as a comment starting with `#`.
- Add some usefull comments about the code after the ruler as a comment
-- Is debbuging output in the newly added code. If so, add the files and line number or write `None`.
-- Possible errors introduced by the newly created code
-- Possible optimizations that should be added to the new code
-- It is not allowed to have any multiline code in this comment. Always refer to files and their line number.

Use the following example as reference. Do only use it to understand the format but dont use the information of it.

```gitcommit
feat(scope): add login functionality

Implement user authentication flow with proper validation
and error handling. Connects to the auth API endpoint.

# --------------------------------------------------
# Debugging Output:
# - [main.js:34](./src/main.js:34): Usage of `debugger` statement.
# - [compiler.js:528](./src/compiler.js:528): Usage of `console.log`.
#
# Possible Issues:
# - [main.js:45](./src/main.js:45): Missing check for `null`.
#
# Possible Optimizations:
# - [main.js:156](./src/main.js:156): Use `let` instead of `var`
# - [main.js:195](./src/main.js:195): Optimize the data structure to improve performance
#
```

Only create the commit message. Do not explain anything!
]]

    -- Create a task to track status
    local task_completed = false
    
    -- Use headless mode with callback
    CopilotChat.ask(prompt, {
      headless = true,
      context = {
        "git:staged",
        "file:`.git/COMMIT_EDITMSG`",
      },
      callback = function(response)
        if not response or response == "" then
          vim.notify("Failed to generate commit message", vim.log.levels.ERROR)
          task_completed = true
          return
        end
        
        -- Extract the gitcommit code block if present
        local commit_message = response:match("```gitcommit\n(.-)\n```")
        if not commit_message then
          -- If no code block found, just clean up markdown formatting
          commit_message = response:gsub("```[%w]*\n", ""):gsub("```", "")
        end
        
        -- Insert the commit message into the buffer
        vim.schedule(function()
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
          vim.notify("Commit message generated", vim.log.levels.INFO)
        end)
        
        task_completed = true
      end
    })
    
    -- Return a command that will be shown in the UI while waiting for the callback
    return "echo 'Generating commit message with Copilot...'"
  end,
}

return M
