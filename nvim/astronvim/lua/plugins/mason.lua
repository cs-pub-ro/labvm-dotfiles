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
      ensure_installed = { "tree-sitter-cli", },
    },
  },
  -- disable nvim-dap
  {
    "jay-babu/mason-nvim-dap.nvim", enabled = false,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      -- opts variable is the default configuration table for the setup function call
      -- local null_ls = require "null-ls"

      -- Check supported formatters and linters
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

      -- Only insert new sources, do not replace the existing ones
      -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        -- Set a formatter
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
      })
    end,
  }
}
