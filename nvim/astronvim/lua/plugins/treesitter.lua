-- Customize Treesitter

local is_headless = #vim.api.nvim_list_uis() == 0

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
    },
    -- when in headless mode, always make ensure_installed synchronous
    sync_install = is_headless,
  },
}
