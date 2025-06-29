-- ===========================================================================
-- Example .smart-commit.lua configuration file
-- ===========================================================================
-- This file should be placed in your project root or Neovim config directory
-- It demonstrates extending predefined tasks and creating custom ones

return {
  defaults = {
    concurrency = 2, -- Reduce concurrency for testing
    timeout = 10000, -- Shorter timeout for testing
  },
  tasks = {
    -- Simple test task
    ["test-echo"] = {
      id = "test-echo",
      label = "Test Echo",
      icon = "�",
      command = "echo 'Smart Commit is working!'",
    },
    
    -- Extend the predefined pnpm task to run linting  
    ["pnpm-lint"] = {
      extend = "pnpm-lint",
      label = "Linting (Project Specific)",
      icon = "󰱺",
      timeout = 30000,
    },
    
    -- Disable some tasks for testing
    ["analyze-staged"] = false,
    ["generate-commit-message"] = false,
  },
}
