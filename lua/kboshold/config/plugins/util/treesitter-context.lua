return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {
    "nvim-treesitter/nvim-treesitter"
  },
  event = "VeryLazy",
  opts = {
    mode = "cursor",
    max_lines = 5
  }
}

