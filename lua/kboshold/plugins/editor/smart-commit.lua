return {
  dir = vim.fn.stdpath("config") .. "/lua/kboshold/features/smart-commit",
  name = "smart-commit",
  config = function()
    require("kboshold.features.smart-commit").setup({})
  end,
}
