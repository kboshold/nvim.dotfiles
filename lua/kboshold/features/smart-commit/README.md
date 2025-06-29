# Smart Commit for Neovim

A Neovim plugin that enhances the Git commit workflow by providing automated tasks and feedback when writing commit messages.

## Features

- Automatically activates when opening a Git commit buffer
- Can be toggled on/off with a keybinding
- Respects environment variable `SMART_COMMIT_ENABLED=0` to disable for specific commits

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  dir = vim.fn.stdpath("config") .. "/lua/kboshold/features/smart-commit",
  name = "smart-commit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("kboshold.features.smart-commit").setup({
      enabled = true,
      auto_run = true,
    })
  end,
}
```

## Usage

The plugin activates automatically when you open a Git commit buffer (e.g., when running `git commit`).

### Commands

- Toggle the plugin: `<leader>sc`

### Configuration

```lua
require("kboshold.features.smart-commit").setup({
  enabled = true,  -- Enable the plugin on startup
  auto_run = true, -- Automatically run when opening a commit buffer
})
```

## License

MIT
