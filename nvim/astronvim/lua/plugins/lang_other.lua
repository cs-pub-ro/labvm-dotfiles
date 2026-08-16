-- Other language plugins

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      -- Note: nvim-treesitter is now just a parser download utility; features are
      -- configured through AstroCore's `treesitter` module
      treesitter = {
        ensure_installed = {
          "bash", "yaml", "markdown", "markdown_inline", "json", "yaml",
          "dockerfile", "html", "javascript", "css", "lua"
        }
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "shfmt", "shellcheck" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        zsh = { "shellcheck" },
      },
    },
  },
}
