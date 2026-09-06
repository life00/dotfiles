return {
  --------------------------------------------------
  --                  neogit
  --------------------------------------------------
  {
    "NeogitOrg/neogit",
    lazy = true,
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>gg", ":Neogit<cr>", desc = "Neogit" },
    },
    opts = {
      disable_hint = true,
      graph_style = "unicode",
      disable_line_numbers = false,
      status = {
        recent_commit_count = 20,
      },
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { " ", " " },
        section = { " ", " " },
      },
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },
  --------------------------------------------------
  --                  diffview
  --------------------------------------------------
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
    lazy = true,
    cmd = "DiffviewOpen",
    keys = {
      { "<leader>gd", ":DiffviewOpen<cr>", desc = "Diffview" },
      { "<leader>gD", ":DiffviewClose<cr>", desc = "Diffview" },
    },
  },
}
