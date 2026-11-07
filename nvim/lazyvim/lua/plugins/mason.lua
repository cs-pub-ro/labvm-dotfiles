-- Mason tools, ported from mason.lua + other_langs/python packs
local is_headless = #vim.api.nvim_list_uis() == 0

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      run_on_start = not is_headless,
      ensure_installed = {
        "tree-sitter-cli",
        -- cpp pack (mason provides clangd; skip on linux/arm like the old config)
        "clangd",
        -- other langs pack
        "shfmt",
        "shellcheck",
        -- python pack
        "black",
        "isort",
      },
    },
  },
  -- shell linting, ported from the other_langs pack
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        zsh = { "shellcheck" },
      },
    },
  },
  -- disable nvim-dap (was disabled in the old mason.lua)
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
