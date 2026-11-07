-- Treesitter parsers, ported from cpp/other_langs/python/treesitter packs
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        -- cpp pack
        "cpp",
        "c",
        "objc",
        "cuda",
        "proto",
        -- python pack
        "python",
        "toml",
        -- other langs pack
        "bash",
        "yaml",
        "markdown",
        "markdown_inline",
        "json",
        "dockerfile",
        "html",
        "javascript",
        "css",
      },
    },
  },
}
