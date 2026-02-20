return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    model = "gpt-4.1",
    show_help = false,
    window = {
      layout = "vertical",
      width = 0.3,
    },
  },
  config = function(_, opts)
    local chat = require("CopilotChat")

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true
        vim.opt_local.signcolumn = "no"
        vim.opt_local.wrap = true
        vim.opt_local.numberwidth = 3
      end,
    })

    chat.setup(opts)
  end,
}
