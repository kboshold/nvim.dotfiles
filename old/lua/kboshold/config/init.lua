if vim.fn.has("nvim-0.9.0") == 0 then
  vim.api.nvim_echo({
    { "LazyVim requires Neovim >= 0.9.0\n", "ErrorMsg" },
    { "Press any key to exit", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd([[quit]])
  return {}
end

require('kboshold.config.options')
require('kboshold.config.autocmd')
require('kboshold.config.lazy')
require('kboshold.config.keymaps')

vim.cmd [[colorscheme catppuccin]]
