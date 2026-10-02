return {
  --------------------------------------------------
  --                  formatter
  --------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
        json = { "prettier" },
        javascript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
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
          -- set indentation as 2 spaces
          prepend_args = { "-n" },
        },
      },
    },
  },
}
