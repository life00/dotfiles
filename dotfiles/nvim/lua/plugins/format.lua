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
        r = { "r_styler" },
        go = { "gofumpt" },
        tex = { "tex-fmt" },
        bib = { "bibtex-tidy" },
      },
      formatters = {
        -- from https://github.com/echasnovski/nvim
        r_styler = {
          command = "R",
          -- A list of strings, or a function that returns a list of strings
          -- Return a single string instead of a list to run the command in a shell
          args = { "-s", "-e", "styler::style_file(commandArgs(TRUE)[1])", "--args", "$FILENAME" },
          stdin = false,
        },
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
