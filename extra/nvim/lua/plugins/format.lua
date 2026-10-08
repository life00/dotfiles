return {
  --------------------------------------------------
  --                  formatter
  --------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        bash = { "shfmt" },
        r = { "styler" },
        quarto = { "injected" },
        go = { "gofumpt" },
        tex = { "tex-fmt" },
        bib = { "bibtex-tidy" },
      },
      formatters = {
        shfmt = {
          -- set indentation as 2 spaces
          prepend_args = { "-i", "2" },
        },
        ["tex-fmt"] = {
          -- don't wrap long lines (indent defaults to 2 spaces)
          prepend_args = { "-n" },
        },
      },
    },
  },
}
