return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose" },
  config = true,
  keys = {
    -- Diff current branch with origin/main
    {
      "<leader>gdm",
      function()
        require("diffview").open({ "origin/main" })
      end,
      desc = "Diff: current branch vs origin/main",
    },
    -- Diff uncommitted changes (working tree)
    {
      "<leader>gds",
      function()
        require("diffview").open({})
      end,
      desc = "Diff: uncommitted changes",
    },
  },
}
