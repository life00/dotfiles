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
        -- the default root_dir is $HOME, and languageserver's workspace index
        -- scans it synchronously on `initialized` (minutes); root at the project instead
        r_language_server = {
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, {
              ".git",
              "DESCRIPTION",
              function(name)
                return name:match("%.Rproj$") ~= nil
              end,
            })
            on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
          end,
        },
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
