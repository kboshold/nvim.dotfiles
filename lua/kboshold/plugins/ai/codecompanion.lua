if true then
  return {}
end

return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "saghen/blink.cmp",
      opts = {
        sources = {
          default = { "codecompanion" },
          providers = {
            codecompanion = {
              name = "CodeCompanion",
              module = "codecompanion.providers.completion.blink",
              enabled = true,
            },
          },
        },
      },
    },
  },
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
    },
    opts = {
      -- Set debug logging
      -- log_level = "DEBUG",
    },
  },
}
