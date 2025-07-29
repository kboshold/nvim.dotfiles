-- Flexible TypeScript LSP Configuration
-- Multiple ways to control which TypeScript server to use:
-- 1. Environment variable: NVIM_TS_SERVER=vtsls or NVIM_TS_SERVER=typescript-tools
-- 2. Local flag in this file
-- 3. Global vim variable: vim.g.typescript_server = "vtsls" or "typescript-tools"

local function get_typescript_server()
  -- Priority order: vim global -> environment variable -> local flag
  if vim.g.typescript_server then
    return vim.g.typescript_server
  end

  local env_server = os.getenv("NVIM_TS_SERVER")
  if env_server then
    return env_server
  end

  -- Default fallback - change this to your preference
  return "typescript-tools" -- or "vtsls"
end

local typescript_server = get_typescript_server()

-- Validate the server choice
if typescript_server ~= "vtsls" and typescript_server ~= "typescript-tools" then
  vim.notify(
    string.format("Invalid TypeScript server: %s. Using typescript-tools as fallback.", typescript_server),
    vim.log.levels.WARN
  )
  typescript_server = "typescript-tools"
end

-- Show which server is being used
vim.notify(string.format("Using TypeScript server: %s", typescript_server), vim.log.levels.INFO)

if typescript_server == "typescript-tools" then
  return {
    -- Disable vtsls
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          vtsls = { enabled = false },
          tsserver = { enabled = false },
        },
      },
    },

    -- Enable typescript-tools
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      opts = {
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = "all",
          tsserver_max_memory = 4096,
          complete_function_calls = true,
          include_completions_with_insert_text = true,
          code_lens = "off",
          disable_member_code_lens = true,

          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },

          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      },
      config = function(_, opts)
        require("typescript-tools").setup(opts)

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = true })
        end

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          callback = function()
            -- TypeScript Tools specific commands
            map("n", "<leader>cto", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
            map("n", "<leader>ctu", "<cmd>TSToolsRemoveUnused<cr>", "Remove Unused")
            map("n", "<leader>ctd", "<cmd>TSToolsRemoveUnusedImports<cr>", "Remove Unused Imports")
            map("n", "<leader>cta", "<cmd>TSToolsAddMissingImports<cr>", "Add Missing Imports")
            map("n", "<leader>ctf", "<cmd>TSToolsFixAll<cr>", "Fix All")
            map("n", "<leader>ctr", "<cmd>TSToolsRenameFile<cr>", "Rename File")
            map("n", "<leader>ctg", "<cmd>TSToolsGoToSourceDefinition<cr>", "Go to Source Definition")
            map("n", "<leader>ctF", "<cmd>TSToolsFileReferences<cr>", "File References")
            map("n", "<leader>ctR", "<cmd>TSToolsRestart<cr>", "Restart TypeScript Server")
            map("n", "<leader>ctS", "<cmd>TSToolsSelectTSVersion<cr>", "Select TypeScript Version")
          end,
        })

        -- Auto-organize imports on save (optional)
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
          callback = function()
            local clients = vim.lsp.get_clients({ bufnr = 0, name = "typescript-tools" })
            if #clients > 0 then
              vim.cmd("TSToolsOrganizeImports")
            end
          end,
        })
      end,
    },
  }
else -- vtsls
  return {
    -- Import the TypeScript extra
    { import = "lazyvim.plugins.extras.lang.typescript" },

    -- Disable typescript-tools
    {
      "pmizio/typescript-tools.nvim",
      enabled = false,
    },

    -- Enhanced vtsls configuration
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          vtsls = {
            enabled = true,
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
              javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
            },
          },
        },
      },
    },

    -- Add vtsls-specific keymaps
    {
      "neovim/nvim-lspconfig",
      opts = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          callback = function()
            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = true })
            end

            -- vtsls specific commands (using LSP commands)
            map("n", "<leader>cto", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.organizeImports" } },
              })
            end, "Organize Imports")

            map("n", "<leader>ctu", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.removeUnused" } },
              })
            end, "Remove Unused")

            map("n", "<leader>cta", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.addMissingImports" } },
              })
            end, "Add Missing Imports")

            map("n", "<leader>ctf", function()
              vim.lsp.buf.code_action({
                apply = true,
                context = { only = { "source.fixAll" } },
              })
            end, "Fix All")
          end,
        })
      end,
    },
  }
end
