return {
  --------------------------------------------------
  --                  treesitter
  --------------------------------------------------

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- additional to LazyVim's defaults
      ensure_installed = {
        "r",
        "latex",
        "bibtex",
        "go",
      },
      highlight = {
        enable = true, -- false will disable the whole extension
        -- disable = { "markdown", "latex" }, -- list of language that will be disabled
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
