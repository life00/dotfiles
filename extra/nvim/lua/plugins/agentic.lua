return {
  {
    "carlos-algms/agentic.nvim",
    opts = {
      acp_providers = {
        ["omp-acp"] = {
          name = "omp",
          command = "omp",
          args = { "acp" },
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("agentic").toggle()
        end,
        mode = { "n", "v" },
        desc = "Agentic chat",
      },
      {
        "<leader>as",
        function()
          require("agentic").add_selection_or_file_to_context()
        end,
        mode = { "n", "v" },
        desc = "Add to agent context",
      },
    },
  },
}
