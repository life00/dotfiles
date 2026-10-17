return {
  {
    "l3aro/omp.nvim",
    lazy = false, -- keys alone would lazy-load it; setup() and :OmpAsk must exist at startup
    init = function()
      vim.g.omp_nvim_no_keymaps = true
    end,
    keys = {
      {
        "<leader>aa",
        function()
          require("omp_nvim").ask()
        end,
        mode = { "n", "x" },
        desc = "omp: ask",
      },
      {
        "<leader>aA",
        function()
          require("omp_nvim").ask({ hold = true })
        end,
        mode = { "n", "x" },
        desc = "omp: ask & hold",
      },
    },
  },
}
