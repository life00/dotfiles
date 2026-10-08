return {
  { "mason.nvim", enabled = false },
  { "mason-lspconfig.nvim", enabled = false },
  { "mason-nvim-dap.nvim", enabled = false },

  --------------------------------------------------
  --                  lsp config
  --------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        r_language_server = {},
        bashls = {},
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },
  --------------------------------------------------
  --                  linter
  --------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
      },
    },
  },
}
