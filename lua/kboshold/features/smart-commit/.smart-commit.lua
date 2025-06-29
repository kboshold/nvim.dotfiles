-- Smart Commit Configuration
-- This file defines tasks for the Smart Commit plugin

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
    -- PNPM Lint task
    ["pnpm-lint"] = {
      id = "pnpm-lint",
      label = "PNPM Lint",
      icon = "󰉁",
      extend = "pnpm",
      script = "lint",
    },
    
    -- PNPM Prisma Generate task
    ["pnpm-prisma-generate"] = {
      id = "pnpm-prisma-generate",
      label = "PNPM Prisma Generate",
      icon = "󰆼",
      extend = "pnpm",
      script = "prisma generate",
    },
    
    -- PNPM Typecheck task (depends on prisma generate)
    ["pnpm-typecheck"] = {
      id = "pnpm-typecheck",
      label = "PNPM Typecheck",
      icon = "󰯱",
      extend = "pnpm",
      script = "typecheck",
      depends_on = { "pnpm-prisma-generate" },
    },
    
    -- Copilot message task
    ["copilot-message"] = {
      extend = "generate-commit-message",
      label = "Generate Commit Message with Copilot",
      icon = "󰚩",
    },
  },
}
