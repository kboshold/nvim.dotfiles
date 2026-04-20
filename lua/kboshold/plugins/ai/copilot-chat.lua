return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatOpen" },
  main = "CopilotChat",
  init = function()
    local group = vim.api.nvim_create_augroup("kboshold_copilot_chat", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true
        vim.opt_local.signcolumn = "no"
        vim.opt_local.wrap = true
        vim.opt_local.numberwidth = 3
      end,
    })
  end,
  opts = {
    model = "gpt-4.1",
    show_help = false,
    window = {
      layout = "vertical",
      width = 0.3,
    },
  },
}
