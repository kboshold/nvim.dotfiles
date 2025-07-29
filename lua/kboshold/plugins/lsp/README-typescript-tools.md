# TypeScript Tools Integration

This directory contains the configuration for integrating `pmizio/typescript-tools.nvim` with LazyVim, replacing the default vtsls LSP server.

## Files Overview

- `typescript-tools.lua` - Basic typescript-tools configuration
- `typescript-tools-advanced.lua` - Advanced configuration example with all options
- `disable-vtsls.lua` - Disables vtsls to prevent conflicts
- `vue.lua` - Updated Vue.js configuration that works with typescript-tools

## Key Features

### TypeScript Tools Commands
- `<leader>cto` - Organize imports
- `<leader>ctu` - Remove unused variables
- `<leader>ctd` - Remove unused imports
- `<leader>cta` - Add missing imports
- `<leader>ctf` - Fix all issues
- `<leader>ctr` - Rename file
- `<leader>ctg` - Go to source definition
- `<leader>ctF` - Show file references

### Advantages over vtsls
1. **Better Performance** - Separate diagnostic server
2. **More Features** - Additional TypeScript-specific commands
3. **Better Integration** - Direct tsserver communication
4. **Customizable** - Extensive configuration options

## Configuration Options

### Basic Settings
```lua
settings = {
  separate_diagnostic_server = true,
  publish_diagnostic_on = "insert_leave",
  expose_as_code_action = "all",
  tsserver_max_memory = 4096,
}
```

### Advanced Settings
- Inlay hints configuration
- Format options (mirrors VSCode)
- File preferences
- JSX close tag support
- Code lens options

## Vue.js Integration

The Vue configuration has been updated to use Volar in "Take Over Mode" which works better with typescript-tools than the previous vtsls-dependent setup.

## Best Practices

1. **Memory Management** - Increase `tsserver_max_memory` for large projects
2. **Diagnostics** - Use `separate_diagnostic_server = true` for better performance
3. **Auto-formatting** - Enable auto-organize imports on save
4. **Inlay Hints** - Configure based on your preference for code readability

## Troubleshooting

If you experience issues:

1. Restart the TypeScript server: `<leader>ctR`
2. Check if multiple TypeScript servers are running: `:LspInfo`
3. Ensure vtsls is properly disabled
4. For Vue projects, make sure Volar is in Take Over Mode

## Migration Notes

- Removed `lazyvim.plugins.extras.lang.typescript` from lazyvim.json
- Updated Vue configuration to work without vtsls dependency
- All standard LSP keymaps still work (gd, gr, K, etc.)
- Added typescript-tools specific commands with `<leader>ct` prefix
