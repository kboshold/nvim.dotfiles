data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='0' height='0' viewBox='0 0 0 0'><text x='0' y='0' font-size='0' fill='#000'>Real developers use dark mode. You seem to be a real developer!</text></svg>
<div align='center'>
   <p>
      <a href="https://github.com/kpalatzky/nvim.dotfiles#is=awesome">
         <picture>
            <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="./docs/assets/logo_dark.svg">
            <img alt="Logo with the Lettering Neovim and a lazy ninja on the left" src="./docs/assets/logo_light.sv">
         </picture>
      </a>
   </p>
   <p>
      <a href="https://github.com/kpalatzky/nvim.dotfiles/blob/master/LICENSE">
         <picture>
            <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="https://img.shields.io/github/license/kpalatzky/nvim.dotfiles.svg?color=cba6f7&labelColor=b4befe">
            <img src="https://img.shields.io/github/license/kpalatzky/nvim.dotfiles.svg?color=8839ef" alt="MIT License"/>
         </picture>
      </a>
      <a href="https://github.com/neovim/neovim#is-also-awesome">
         <picture>
            <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="https://img.shields.io/badge/%3E%3D0.10.0-a6e3a1?logo=neovim&label=neovim&labelColor=74c7ec&logoColor=313244">
            <img alt="Logo with the Lettering Neovim and a lazy ninja on the left" src="https://img.shields.io/badge/%3E%3D0.10.0-40a02b?logo=neovim&label=neovim&labelColor=1e66f5">
         </picture>
       </a>
      <picture>
         <source media="(prefers-color-scheme: dark)" type="image/svg+xml" srcset="data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPScwJyBoZWlnaHQ9JzAnIHZpZXdCb3g9JzAgMCAwIDAnPjx0ZXh0IHg9JzAnIHk9JzAnIGZvbnQtc2l6ZT0nMCcgZmlsbD0nIzAwMCc+RWNodGUgRW50d2lja2xlciB2ZXJ3bmVkbmUgZGVuIERhcmsgTW9kZS4gRHUgYmlzdCBhbnNjaGVpbmVuZCBlaW4gZWNodGVyIEVudHdpY2tsZXIhPC90ZXh0Pjwvc3ZnPg==">
         <img alt="This logo recommends users to use a dark mode if they are not already doing so." src="https://img.shields.io/badge/Please%20really%20consider%20using%20a%20dark%20mode.%20Thanks-fab387?style=for-the-badge">
      </picture>
   </p>
   <hr>
   <p>
      <h3>⚠️🚧 This project is not yet working at all. Please do not use it 🚧⚠️<h3>
      <h3>💤 Want to be a lazy neo ninja? 💤</h3>
      <div>My personal Neovim configuration.</div>
   </p>
</div>

## ✨ Get started

### ⚡️ Requirements

| Tool       | Version   | Usage                                                                                 | Note                                                                                                      |
| ---------- | --------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Neovim     | >= 0.10.0  | <img src="https://img.shields.io/badge/required-800000?style=flat" alt="Required"/>   | [Installation Guide](https://github.com/neovim/neovim/blob/master/INSTALL.md#is-also-awesome)             |
| Git        | >= 2.19.0 | <img src="https://img.shields.io/badge/required-800000?style=flat" alt="Required"/>   | [Download](https://git-scm.com/downloads#is-also-awesome)                                                 |
| NerdFont   | -         | <img src="https://img.shields.io/badge/suggested-392361?style=flat" alt="Suggested"/> | [Download](https://www.nerdfonts.com/font-downloads#is-also-awesome) (i.e. `JetBrainsMono Nerd Font`)     |
| C Compiler | -         | <img src="https://img.shields.io/badge/suggested-392361?style=flat" alt="Suggested"/> | See [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#requirements) |
| ripgrep    | >= 14.1.0 | <img src="https://img.shields.io/badge/suggested-392361?style=flat" alt="Suggested"/> | [Installation](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation)                     |
| fd         | >= 10.1.0 | <img src="https://img.shields.io/badge/suggested-392361?style=flat" alt="Suggested"/> | [Installation](https://github.com/sharkdp/fd?tab=readme-ov-file#installation)                             |


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

Start Neovim:
```sh
nvim
```

#### 🦄 Uni-Line Installation

> [!WARNING]  
> This does a little more than the script above*. It also checks the necessary dependencies and tries to install them.
> You will of course be asked before the installation. 
> 
> *I will implement it in the future!

```sh
curl https://github.com/kboshold/nvim.dotfiles/install.sh | bash
```

#### 🧙‍♂️ Using my dotfiles

The [kboshold/dotfiles](https://github.com/kboshold/dotfiles) also include the latest version of this Neovim configuration. So if you want to use them, you do not have to do anything at all! 🤯

### ⚙️ Configuration



## 🫅 Usage

### ⌨️ Keymaps

> [!TIP]  
> You can of course also view the keymaps directly in Neovim with `:nmap`, `:vmap` as usual (Typing `:help map` in Neovim will give you more info.)


> [!IMPORTANT]  
> The following keymaps are automatically extracted from the code via a pipeline and inserted here. Therefore, make sure that you have the latest version. 

<!-- generated-keymaps-start --!>

<!-- generated-keymaps-end --!>
