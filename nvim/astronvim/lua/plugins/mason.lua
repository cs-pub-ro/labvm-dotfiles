-- Customize Mason

local is_headless = #vim.api.nvim_list_uis() == 0

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      run_on_start = not is_headless,
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        -- "lua-language-server",
        -- install formatters
        -- "stylua",
        -- install debuggers
        -- "debugpy",
        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
