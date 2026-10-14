return {
  "folke/sidekick.nvim",
  opts = {
    -- NES needs the Copilot LSP, which is not used
    nes = { enabled = false },
  },
  keys = {
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Toggle Claude",
    },
  },
}
