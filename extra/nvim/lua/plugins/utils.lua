return {
  --------------------------------------------------
  --                   undotree
  --------------------------------------------------
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = true,
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>cu", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle undotree" },
    },
  },
  --------------------------------------------------
  --              academic dictionary
  --------------------------------------------------
  {
    "ficcdaf/academic.nvim",
    lazy = true,
    ft = { "markdown", "tex" },
  },
  --------------------------------------------------
  --                emoji picker
  --------------------------------------------------
  {
    "allaman/emoji.nvim",
    ft = "markdown",
    keys = {
      { "<leader>se", "<cmd>lua require('emoji').insert()<cr>", desc = "Insert emoji" },
    },
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
