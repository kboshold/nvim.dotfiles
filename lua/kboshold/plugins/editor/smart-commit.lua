return {
  dir = vim.fn.stdpath("config") .. "/lua/kboshold/features/smart-commit",
  name = "smart-commit",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "CopilotC-Nvim/CopilotChat.nvim", -- Required for commit message generation
  },
  config = function()
    require("kboshold.features.smart-commit").setup({
      defaults = {
        auto_run = true,
        sign_column = true,
        status_window = {
          enabled = true,
          position = "bottom",
          refresh_rate = 100,
        },
      },
    })
  end,
  keys = {
    {
      "<leader>sc",
      function() require("kboshold.features.smart-commit").toggle() end,
      desc = "Toggle Smart Commit",
    },
  },
}
