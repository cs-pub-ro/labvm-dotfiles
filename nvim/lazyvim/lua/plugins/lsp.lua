-- LSP features, ported from astrocore/astrolsp
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false }, -- astrolsp: inlay_hints = false
      servers = {
        clangd = {
          -- cpp pack: clangd needs utf-8 offsets
          capabilities = { offsetEncoding = "utf-8" },
        },
      },
    },
  },
}
