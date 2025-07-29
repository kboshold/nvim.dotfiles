-- User commands to switch between TypeScript servers
return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Command to switch to typescript-tools
    vim.api.nvim_create_user_command("UseTypescriptTools", function()
      vim.g.typescript_server = "typescript-tools"
      vim.notify("Switched to typescript-tools. Restart Neovim to apply changes.", vim.log.levels.INFO)
    end, {
      desc = "Switch to typescript-tools LSP server",
    })

    -- Command to switch to vtsls
    vim.api.nvim_create_user_command("UseVtsls", function()
      vim.g.typescript_server = "vtsls"
      vim.notify("Switched to vtsls. Restart Neovim to apply changes.", vim.log.levels.INFO)
    end, {
      desc = "Switch to vtsls LSP server",
    })

    -- Command to show current TypeScript server
    vim.api.nvim_create_user_command("TypescriptServerStatus", function()
      local current_server = vim.g.typescript_server or os.getenv("NVIM_TS_SERVER") or "typescript-tools"
      vim.notify(string.format("Current TypeScript server: %s", current_server), vim.log.levels.INFO)

      -- Show active LSP clients for TypeScript files
      local clients = vim.lsp.get_clients()
      local ts_clients = {}
      for _, client in ipairs(clients) do
        if client.name == "typescript-tools" or client.name == "vtsls" or client.name == "tsserver" then
          table.insert(ts_clients, client.name)
        end
      end

      if #ts_clients > 0 then
        vim.notify(
          string.format("Active TypeScript LSP clients: %s", table.concat(ts_clients, ", ")),
          vim.log.levels.INFO
        )
      else
        vim.notify("No active TypeScript LSP clients found", vim.log.levels.WARN)
      end
    end, {
      desc = "Show current TypeScript server status",
    })

    -- Command to restart TypeScript server (works for both)
    vim.api.nvim_create_user_command("RestartTypescriptServer", function()
      local clients = vim.lsp.get_clients()
      local restarted = false

      for _, client in ipairs(clients) do
        if client.name == "typescript-tools" then
          vim.cmd("TSToolsRestart")
          restarted = true
          break
        elseif client.name == "vtsls" then
          vim.cmd("LspRestart vtsls")
          restarted = true
          break
        end
      end

      if not restarted then
        vim.notify("No TypeScript server found to restart", vim.log.levels.WARN)
      end
    end, {
      desc = "Restart the active TypeScript server",
    })
  end,
}
