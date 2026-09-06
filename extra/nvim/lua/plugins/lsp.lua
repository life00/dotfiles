return {
  --------------------------------------------------
  --                  mason
  --------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "bibtex-tidy",
        "bash-language-server",
        "shfmt",
        "shellcheck",
        "goimports",
        "gofumpt",
        "texlab",
        "tex-fmt",
        -- doesn't compile in nixos and I don't use it anyways
        -- "r-languageserver",
      },
    },
  },
  --------------------------------------------------
  --                  lsp config
  --------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- r_language_server = {},
        bashls = {},
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
      inlay_hints = { enabled = true },
    },
  },
  --------------------------------------------------
  --                  linter
  --------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        shellcheck = { "sh" },
      },
      linters = {
        shellcheck = {},
      },
    },
  },
}
