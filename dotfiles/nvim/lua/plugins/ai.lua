return {
  -- {
  --   "ThePrimeagen/99",
  --   dependencies = {
  --     "saghen/blink.compat",
  --   },
  --   config = function()
  --     local _99 = require("99")
  --     local cwd = vim.uv.cwd()
  --     local basename = vim.fs.basename(cwd)
  --     _99.setup({
  --       provider = _99.Providers.OpenCodeProvider,
  --       -- model = "openrouter/google/gemini-3.1-flash-lite-preview",
  --       model = "opencode/big-pickle",
  --       logger = {
  --         level = _99.DEBUG,
  --         path = "/tmp/" .. basename .. ".99.debug",
  --         print_on_error = true,
  --       },
  --       tmp_dir = "/tmp/" .. basename .. ".99.debug",
  --
  --       -- NOTE: blink doesn't work for some reason :/
  --       -- completion = {
  --       --   source = "blink",
  --       -- },
  --     })
  --   end,
  --   keys = {
  --     {
  --       "<leader>av",
  --       function()
  --         require("99").visual()
  --       end,
  --       mode = "v",
  --       desc = "99 visual",
  --     },
  --     {
  --       "<leader>ax",
  --       function()
  --         require("99").stop_all_requests()
  --       end,
  --       desc = "99 stop all requests",
  --     },
  --     {
  --       "<leader>as",
  --       function()
  --         require("99").search()
  --       end,
  --       desc = "99 search",
  --     },
  --     {
  --       "<leader>ag",
  --       function()
  --         require("99").vibe()
  --       end,
  --       desc = "99 generate",
  --     },
  --     {
  --       "<leader>al",
  --       function()
  --         require("99").view_logs()
  --       end,
  --       desc = "99 view logs",
  --     },
  --     {
  --       "<leader>ao",
  --       function()
  --         require("99").vibe()
  --       end,
  --       desc = "99 open previous prompt",
  --     },
  --   },
  -- },
  {
    "nickjvandyke/opencode.nvim",
    version = "*", -- Latest stable release
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.g.opencode_opts = {
        server = {
          start = false,
          stop = false,
          toggle = false,
        },
      }
      vim.o.autoread = true

      local ask = require("opencode").ask
      local cmd = require("opencode").command
      local op = require("opencode").operator
      local select = require("opencode").select
      local toggle = require("opencode").toggle

      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        select()
      end, { desc = "Select opencode" })
      vim.keymap.set({ "n", "t" }, "<leader>at", function()
        toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>ao", function()
        return op("@this ")
      end, { desc = "Add range to opencode", expr = true })
      vim.keymap.set("n", "<leader>al", function()
        return op("@this ") .. "_"
      end, { desc = "Add line to opencode", expr = true })

      vim.keymap.set({ "n", "x" }, "<leader>ae", function()
        ask("Explain @this and its context", { submit = true })
      end, { desc = "Explain code" })
      vim.keymap.set({ "n", "x" }, "<leader>af", function()
        ask("Fix @diagnostics", { submit = true })
      end, { desc = "Fix diagnostics" })
      vim.keymap.set({ "n", "x" }, "<leader>ad", function()
        ask("Add comments documenting @this", { submit = true })
      end, { desc = "Document code" })
      vim.keymap.set({ "n", "x" }, "<leader>ar", function()
        ask("Review @this for correctness and readability", { submit = true })
      end, { desc = "Review code" })
      vim.keymap.set({ "n", "x" }, "<leader>ai", function()
        ask("Implement @this", { submit = true })
      end, { desc = "Implement code" })
      vim.keymap.set({ "n", "x" }, "<leader>az", function()
        ask("Optimize @this for performance and readability", { submit = true })
      end, { desc = "Optimize code" })
      vim.keymap.set({ "n", "x" }, "<leader>aT", function()
        ask("Add tests for @this", { submit = true })
      end, { desc = "Test code" })

      vim.keymap.set("n", "<leader>a[", function()
        cmd("session.half.page.up")
      end, { desc = "Scroll opencode up" })
      vim.keymap.set("n", "<leader>a]", function()
        cmd("session.half.page.down")
      end, { desc = "Scroll opencode down" })
      vim.keymap.set("n", "<leader>au", function()
        cmd("session.undo")
      end, { desc = "Undo opencode" })
      vim.keymap.set("n", "<leader>aU", function()
        cmd("session.redo")
      end, { desc = "Redo opencode" })
    end,
  },
}
