return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Use the nix-provided marksman on PATH; the mason binary crashes on NixOS
      marksman = { mason = false },
    },
  },
}
