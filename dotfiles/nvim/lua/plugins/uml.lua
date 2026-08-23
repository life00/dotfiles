return {
  -- syntax and filetype detection for plantuml
  {
    "aklt/plantuml-syntax",
    lazy = true,
    ft = "plantuml",
  },
  -- plantuml preview
  {
    "https://gitlab.com/itaranto/plantuml.nvim",
    version = "*",
    lazy = true,
    ft = "plantuml",
    keys = {
      {
        "<leader>cp",
        "<Cmd>PlantUML<CR>",
        mode = { "n" },
        ft = { "plantuml" },
        noremap = true,
        silent = true,
        desc = "Preview PlantUML",
      },
    },
    config = function()
      require("plantuml").setup({
        renderer = {
          type = "imv",
          options = {
            format = "png",
          },
        },
        render_on_write = true,
      })
    end,
  },
}
