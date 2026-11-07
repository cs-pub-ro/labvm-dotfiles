-- Python, ported from the old python.lua pack
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
      },
    },
  },
  -- lightweight venv picker (needs fd on $PATH)
  {
    "linux-cultist/venv-selector.nvim",
    enabled =
      vim.fn.executable("fd") == 1 or vim.fn.executable("fdfind") == 1 or vim.fn.executable("fd-find") == 1,
    cmd = "VenvSelect",
    keys = { { "<Leader>lv", "<cmd>VenvSelect<CR>", desc = "Select VirtualEnv" } },
  },
}
