-- Example Smart Commit configuration with Copilot integration
-- Save this as ~/.smart-commit.lua or as a project-specific .smart-commit.lua

return {
  defaults = {
    auto_run = true,
    sign_column = true,
    status_window = {
      enabled = true,
      position = "bottom",
      refresh_rate = 100,
    },
  },
  tasks = {
    -- Generate commit message using Copilot
    ["commit-message"] = {
      extend = "generate-commit-message",
      id = "commit-message",
      label = "Generate Commit Message",
      icon = "󰚩",
    },
    
    -- Analyze staged changes for potential issues
    ["analyze-code"] = {
      extend = "analyze-staged",
      id = "analyze-code",
      label = "Analyze Code",
      icon = "󰌵",
    },
    
    -- Extend the base PNPM task for lint
    ["pnpm-lint"] = {
      extend = "pnpm",
      id = "pnpm-lint",
      label = "Lint Check",
      icon = "",
      script = "lint",
    },
    
    -- Extend the base PNPM task for typecheck
    ["pnpm-typecheck"] = {
      extend = "pnpm",
      id = "pnpm-typecheck",
      label = "Type Check",
      icon = "",
      script = "typecheck",
    },
  },
}
