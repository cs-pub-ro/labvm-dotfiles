-- C/Cpp language plugins

local uname = (vim.uv or vim.loop).os_uname()
local is_linux_arm = uname.sysname == "Linux" and (uname.machine == "aarch64" or vim.startswith(uname.machine, "arm"))

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("keep", opts.config, {
        clangd = {
          capabilities = {
            offsetEncoding = "utf-8",
          },
        },
      })
      if not is_linux_arm then opts.servers = require("astrocore").list_insert_unique(opts.servers, { "clangd" }) end
    end,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      treesitter = {
        ensure_installed = { "cpp", "c", "objc", "cuda", "proto", },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      local tools = { }
      if not is_linux_arm then table.insert(tools, "clangd") end
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, tools)
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      if not is_linux_arm then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "clangd" })
      end
    end,
  },
}
