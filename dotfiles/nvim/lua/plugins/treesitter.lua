return {
  --------------------------------------------------
  --                  treesitter
  --------------------------------------------------

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "vim",
        "yaml",
        "r",
        "latex",
        "bibtex",
        "go",
        "c",
      },
      highlight = {
        enable = true, -- false will disable the whole extension
        -- disable = { "markdown", "latex" }, -- list of language that will be disabled
        -- have treesitter enabled but allow vim-markdown to only overwrite
        additional_vim_regex_highlighting = { "markdown", "latex" },
      },
    },
  },
  --------------------------------------------------
  --             treesitter context
  --------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- event = "VeryLazy",
    -- alternative event option for which it works
    event = "BufReadPre",
    -- does not work
    -- event = "BufReadPost",
    -- big thanks to this guy: https://github.com/utkarshgupta137/nvim-lazy/blob/main/lua/plugins/nvim-treesitter-context.lua
    opts = {
      on_attach = function()
        return vim.bo.filetype ~= "markdown"
      end,
    },
  },
}
