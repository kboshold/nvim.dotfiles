return {
  "kboshold/smart-commit.nvim",
  dir = "/home/kboshold/workspace/config/smart-commit.nvim",
  name = "smart-commit",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "CopilotC-Nvim/CopilotChat.nvim", -- Required for commit message generation
  },
  config = function()
    require("smart-commit").setup({
      defaults = {
        auto_run = true,
        sign_column = true,
        hide_skipped = true,
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
      function()
        require("smart-commit").toggle()
      end,
      desc = "Toggle Smart Commit",
    },
  },
}
