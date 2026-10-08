return {
  --------------------------------------------------
  --                   vimtex
  --------------------------------------------------
  -- NOTE: installing vimtex manually instead of using
  -- tex extra because I want to use treesitter syntax.
  -- With tex extra the vimtex syntax is used.
  {
    "lervag/vimtex",
    lazy = true,
    ft = { "bib", "tex", "latex" },
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_quickfix_mode = 0
      -- vim.g.vimtex_compiler_method = "pdflatex"
      vim.g.vimtex_compiler_method = "latexmk"
      -- disable vimtex syntax in favor of treesitter
      vim.g.vimtex_syntax_enabled = 0
    end,
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex" },
    },
  },
}
