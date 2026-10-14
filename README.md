<div align='center'>
   <p>
      <a href="https://github.com/kboshold/nvim.dotfiles">
         <picture>
            <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="./docs/assets/logo_dark.svg">
            <img alt="Logo with the Lettering Neovim and a lazy ninja on the left" src="./docs/assets/logo_light.svg">
         </picture>
      </a>
   </p>
   <p>
      <a href="https://github.com/kboshold/nvim.dotfiles/blob/main/LICENSE">
         <picture>
            <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="https://img.shields.io/github/license/kboshold/nvim.dotfiles.svg?color=cba6f7&labelColor=b4befe">
            <img src="https://img.shields.io/github/license/kboshold/nvim.dotfiles.svg?color=8839ef" alt="MIT License"/>
         </picture>
      </a>
      <a href="https://github.com/neovim/neovim">
         <picture>
            <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="https://img.shields.io/badge/%3E%3D0.11.0-a6e3a1?logo=neovim&label=neovim&labelColor=74c7ec&logoColor=313244">
            <img alt="Neovim 0.11 is required" src="https://img.shields.io/badge/%3E%3D0.11.0-40a02b?logo=neovim&label=neovim&labelColor=1e66f5">
         </picture>
       </a>
      <a href="https://github.com/neovim/neovim/releases/tag/v0.12.0">
         <picture>
            <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="https://img.shields.io/badge/0.12.0-a6e3a1?logo=neovim&label=neovim&labelColor=74c7ec&logoColor=313244">
            <img alt="Neovim 0.12 is supported" src="https://img.shields.io/badge/0.12.0-40a02b?logo=neovim&label=neovim&labelColor=1e66f5">
         </picture>
       </a>
   </p>
   <hr>
   <p>
      <h3>💤 Want to be a lazy neo ninja? 💤</h3>
      <div>My personal Neovim configuration.</div>
   </p>
</div>

## ✨ Get started

### ⚡ Requirements

| Tool       | Version   | Usage                                                                                 | Note                                                                                                      |
| ---------- | --------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Neovim     | >= 0.11.0 | <img src="https://img.shields.io/badge/required-f491ac?style=flat" alt="Required"/>   | [Installation Guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)             |
| Git        | >= 2.19.0 | <img src="https://img.shields.io/badge/required-f491ac?style=flat" alt="Required"/>   | [Download](https://git-scm.com/downloads)                                                 |
| NerdFont   | -         | <img src="https://img.shields.io/badge/suggested-cba6f7?style=flat" alt="Suggested"/> | [Download](https://www.nerdfonts.com/font-downloads) (i.e. `JetBrainsMono Nerd Font`)     |
| C Compiler | -         | <img src="https://img.shields.io/badge/suggested-cba6f7?style=flat" alt="Suggested"/> | See [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#requirements) |
| ripgrep    | >= 14.1.0 | <img src="https://img.shields.io/badge/suggested-cba6f7?style=flat" alt="Suggested"/> | [Installation](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation)                     |
| fd         | >= 10.1.0 | <img src="https://img.shields.io/badge/suggested-cba6f7?style=flat" alt="Suggested"/> | [Installation](https://github.com/sharkdp/fd?tab=readme-ov-file#installation)                             |
| fzf        | >= 0.60.0 | <img src="https://img.shields.io/badge/suggested-cba6f7?style=flat" alt="Suggested"/> | [Installation](https://github.com/sharkdp/fd?tab=readme-ov-file#installation)                             |

### 🛠️ Installation

Make a backup of your current Neovim files:

```sh
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Clone this repository:

```sh
git clone https://github.com/kboshold/nvim.dotfiles ~/.config/nvim
```

Install all dependencies:

```sh
nvim --headless -c 'Lazy install' -c 'qa'
```

Now you can use `nvim` and enjoy the configuration! 🎉

## 🍱 What's in the bento?

Built on [LazyVim](https://www.lazyvim.org/). Below is the stuff on top.

#### 🎨 Look & feel
- Catppuccin Mocha with a 9-color indent cycle (custom `Indent*` / `IndentScope*` highlights)
- Snacks dashboard with custom ASCII branding
- Lualine with a mode-colored `CursorLineNr` (sampled from the current mode's lualine highlight)
- Rainbow delimiters, render-markdown, thin colorcolumn rulers (`config/ruler.lua`)

#### 🤖 AI
- [Sidekick](https://github.com/folke/sidekick.nvim) (LazyVim `ai.sidekick` extra): AI CLI integration (Claude, etc.), NES disabled

#### 🔍 Navigation
- Snacks picker + explorer (auto-opens on `nvim` with no args or a directory; skipped for piped input)
- [Oil.nvim](https://github.com/stevearc/oil.nvim) floating browser (`<leader>oo`/`<leader>od`)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) (`<C-h/j/k/l>`)

#### 🧠 Language / LSP
- Vue/TypeScript via the LazyVim `lang.vue` extra (vue_ls + vtsls with `@vue/typescript-plugin`)
- Prisma, Nix (alejandra), Python, Ansible, Docker, Helm, JSON, Markdown, SQL, Tailwind, YAML (via LazyVim extras)
- lazydev for Lua + Neovim API awareness

#### ✍️ Completion & formatting
- [blink.cmp](https://github.com/saghen/blink.cmp)
- Conform with a `from_node_modules` resolver — prefers the project's local `eslint_d` / `prisma` / `jsonsort` over globals, falls back cleanly

#### 🔧 Git
- AI commit messages via the Codex CLI: auto-filled on `git commit` when the message is empty, `<leader>gm` regenerates
- Diffview, mini-diff, Octo (PR/issue review)

#### 🔐 Secrets
- [cloak.nvim](https://github.com/laytan/cloak.nvim) — auto-masks values in `.env*` files

### ⌨️ Keymaps

> [!TIP]
> The full list is discoverable via [which-key](https://github.com/folke/which-key.nvim) (just press `<leader>` and wait) or `<leader>sk`. The table below only lists the custom bindings on top of LazyVim defaults.

| Mapping | Mode | Description |
| ------- | ---- | ----------- |
| `dih` / `cih` / `vih` | n | Delete / change / select the TS node at cursor |
| `gf` | n | Open file under cursor; supports `:line` and `:line-line` suffix |
| `<leader>e` | n | Toggle snacks explorer (reuses open pane) |
| `<leader>oo` / `<leader>od` | n | Oil browser / floating preview |
| `<leader>gdm` / `<leader>gds` / `<leader>gdu` | n | Diffview: branch vs `origin/main` / uncommitted / commits ahead of upstream |
| `<leader>um` | n | Toggle render-markdown |
| `<leader>gm` | n | In a commit buffer: regenerate the commit message (auto-generated on `git commit` via `codex exec`) (`vim.g.ai_commit_model`, default `gpt-6-luna`) |
| `<leader>aa` / `as` | n | Sidekick: toggle CLI / select CLI |
| `<leader>at` / `av` | n / x | Send current node / selection to Sidekick |
| `<leader>ap` | n / x | Sidekick prompt picker |
| `<leader>ac` | n | Toggle Sidekick Claude |
| `<C-.>` | any | Switch focus to Sidekick |
| `<C-h/j/k/l>` / `<C-\>` | n | Tmux-aware pane navigation |

### 🧰 Custom commands

| Command | Description |
| ------- | ----------- |
| `:PathCopyName` | Copy filename to clipboard |
| `:PathCopyRelative` | Copy relative path |
| `:PathCopyRelativeFull` | Relative path + current (or visual) line range |
| `:PathCopyAbsolute` | Copy absolute path |
| `:PathCopyAbsoluteFull` | Absolute path + line range |

### 🩺 Health check

`scripts/check.sh` runs Neovim headless and reports startup time, LSP clients per sample file, notify errors and `:checkhealth` problems. It uses `NVIM_APPNAME=nvim-opt` by default (symlink `~/.config/nvim-opt` to this repo); `scripts/install.lua` installs mason tools and parsers in that isolated instance.

`scripts/smoke.lua` is a lighter check (config loads, no errors) that CI runs on every push and PR together with `stylua --check`.

Markdown linting uses `.markdownlint-cli2.yaml` as base config (MD013, MD033, MD041 off) and skips Claude/Codex Ctrl+G prompt files. tailwindcss only starts in projects with a Tailwind/PostCSS config or a `tailwindcss` dependency.

Use `:InspectTree` (built in) to inspect the treesitter tree.
