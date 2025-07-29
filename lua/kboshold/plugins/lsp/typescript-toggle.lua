-- Toggle between vtsls and typescript-tools
-- Set this flag to choose your TypeScript LSP server
local USE_TYPESCRIPT_TOOLS = true -- Set to false to use vtsls instead

if USE_TYPESCRIPT_TOOLS then
  -- TypeScript Tools Configuration
  return {
    -- Disable vtsls when using typescript-tools
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

          -- Inlay hints
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

        -- TypeScript Tools specific keymaps
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = true })
        end

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          callback = function()
            map("n", "<leader>cto", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
            map("n", "<leader>ctu", "<cmd>TSToolsRemoveUnused<cr>", "Remove Unused")
            map("n", "<leader>ctd", "<cmd>TSToolsRemoveUnusedImports<cr>", "Remove Unused Imports")
            map("n", "<leader>cta", "<cmd>TSToolsAddMissingImports<cr>", "Add Missing Imports")
            map("n", "<leader>ctf", "<cmd>TSToolsFixAll<cr>", "Fix All")
            map("n", "<leader>ctr", "<cmd>TSToolsRenameFile<cr>", "Rename File")
            map("n", "<leader>ctg", "<cmd>TSToolsGoToSourceDefinition<cr>", "Go to Source Definition")
            map("n", "<leader>ctF", "<cmd>TSToolsFileReferences<cr>", "File References")
            map("n", "<leader>ctR", "<cmd>TSToolsRestart<cr>", "Restart TypeScript Server")
          end,
        })
      end,
    },
  }
else
  -- vtsls Configuration (LazyVim default)
  return {
    -- Re-enable the TypeScript extra
    { import = "lazyvim.plugins.extras.lang.typescript" },

    -- Ensure typescript-tools is disabled
    {
      "pmizio/typescript-tools.nvim",
      enabled = false,
    },

    -- Optional: Custom vtsls configuration
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          vtsls = {
            enabled = true,
            -- Add any custom vtsls settings here
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
            },
          },
        },
      },
    },
  }
end
