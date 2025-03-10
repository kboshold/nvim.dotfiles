if true then
  return {}
end

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "zbirenbaum/copilot.lua",
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { file_types = { "markdown", "Avante" } },
    ft = { "markdown", "Avante" },
  },
  opts = {
    provider = "copilot",
    copilot = {
      model = "claude-3.7-sonnet",
    },
    auto_suggestions_provider = "copilot", -- optional but recommended
    behaviour = {
      auto_suggestions = false, -- experimental feature, recommended to disable
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
      minimize_diff = true,
    },
    windows = {
      position = "right",
      wrap = true,
      width = 30,
      input = {
        height = 5,
      },
      edit = {
        border = "single",
        start_insert = true,
      },
      ask = {
        floating = true,
        start_insert = true,
        border = "single",
      },
    },
  },
}
