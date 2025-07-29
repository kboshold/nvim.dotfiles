-- Advanced typescript-tools configuration example
-- Rename this file to typescript-tools.lua to use instead of the basic version

return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
  opts = {
    -- LSP server settings
    settings = {
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",

      -- Enable all code actions
      expose_as_code_action = "all",

      -- Custom tsserver path (useful for monorepos)
      -- tsserver_path = "./node_modules/typescript/lib/tsserver.js",

      -- Plugins for styled-components, emotion, etc.
      tsserver_plugins = {
        -- "@styled/typescript-styled-plugin",
      },

      -- Increase memory limit for large projects
      tsserver_max_memory = 8192,

      -- Format options (mirrors VSCode settings)
      tsserver_format_options = {
        allowIncompleteCompletions = false,
        allowRenameOfImportPath = false,
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        insertSpaceAfterConstructor = false,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
        insertSpaceAfterTypeAssertion = false,
        insertSpaceBeforeFunctionParenthesis = false,
        placeOpenBraceOnNewLineForFunctions = false,
        placeOpenBraceOnNewLineForControlBlocks = false,
        semicolons = "ignore",
      },

      -- File preferences (mirrors VSCode settings)
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        importModuleSpecifier = "shortest",
        includePackageJsonAutoImports = "auto",
      },

      -- Enable function call completions
      complete_function_calls = true,
      include_completions_with_insert_text = true,

      -- Enable CodeLens for implementations and references
      code_lens = "implementations_only",
      disable_member_code_lens = true,

      -- Enable JSX close tag
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
    },
  },
  config = function(_, opts)
    require("typescript-tools").setup(opts)

    -- Enhanced keymaps with which-key integration
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = true })
    end

    -- Create autocmd for TypeScript/JavaScript files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      callback = function()
        -- Import management
        map("n", "<leader>cto", "<cmd>TSToolsOrganizeImports<cr>", "Organize Imports")
        map("n", "<leader>ctu", "<cmd>TSToolsRemoveUnused<cr>", "Remove Unused")
        map("n", "<leader>ctd", "<cmd>TSToolsRemoveUnusedImports<cr>", "Remove Unused Imports")
        map("n", "<leader>cta", "<cmd>TSToolsAddMissingImports<cr>", "Add Missing Imports")

        -- Code actions
        map("n", "<leader>ctf", "<cmd>TSToolsFixAll<cr>", "Fix All")
        map("n", "<leader>ctr", "<cmd>TSToolsRenameFile<cr>", "Rename File")

        -- Navigation
        map("n", "<leader>ctg", "<cmd>TSToolsGoToSourceDefinition<cr>", "Go to Source Definition")
        map("n", "<leader>ctF", "<cmd>TSToolsFileReferences<cr>", "File References")

        -- Additional useful commands
        map("n", "<leader>ctR", "<cmd>TSToolsRestart<cr>", "Restart TypeScript Server")
        map("n", "<leader>ctS", "<cmd>TSToolsSelectTSVersion<cr>", "Select TypeScript Version")
      end,
    })

    -- Auto-organize imports on save (optional)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
      callback = function()
        -- Only run if typescript-tools is attached to the buffer
        local clients = vim.lsp.get_clients({ bufnr = 0, name = "typescript-tools" })
        if #clients > 0 then
          vim.cmd("TSToolsOrganizeImports")
          vim.cmd("TSToolsRemoveUnused")
        end
      end,
    })
  end,
}
