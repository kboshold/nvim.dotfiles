-- ===========================================================================
-- Example .smart-commit.lua for a TypeScript/Prisma project
-- Place this file in your project root directory
-- ===========================================================================

return {
  defaults = {
    concurrency = 6, -- Allow more tasks to run in parallel
    timeout = 45000, -- Longer timeout for complex operations
  },
  tasks = {
    -- Extend pnpm task to run linting
    ["pnpm-lint"] = {
      extend = "pnpm-lint",
      label = "ESLint Project Check",
      icon = "󰱺",
      timeout = 30000,
    },
    
    -- Create a pnpm task for Prisma generate
    ["pnpm-prisma-generate"] = {
      id = "pnpm-prisma-generate",
      label = "Generate Prisma Client",
      icon = "󰆼",
      fn = function()
        local pnpm = require("kboshold.features.smart-commit.predefined.pnpm")
        local task = pnpm.create_pnpm_task("prisma:generate", {
          id = "pnpm-prisma-generate",
          label = "Generate Prisma Client"
        })
        return task.fn()
      end,
      when = function()
        -- Only run if we have Prisma schema
        return vim.fn.filereadable("prisma/schema.prisma") == 1
      end,
    },
    
    -- Extend pnpm task to run typecheck, depends on Prisma generation
    ["pnpm-typecheck"] = {
      extend = "pnpm-typecheck",
      label = "TypeScript Type Check",
      icon = "󰛦",
      depends_on = { "pnpm-prisma-generate" }, -- Wait for Prisma types
      when = function()
        -- Only run if we have TypeScript config
        return vim.fn.filereadable("tsconfig.json") == 1
      end,
    },
    
    -- Optional: Disable some predefined tasks for this project
    ["analyze-staged"] = false, -- We don't need staged analysis for this project
  },
}
