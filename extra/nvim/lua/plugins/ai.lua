return {
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
        },
      }
      vim.o.autoread = true

      local ask = require("opencode").ask
      local cmd = require("opencode").command
      local op = require("opencode").operator
      local select = require("opencode").select

      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        ask("@this: ")
      end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>as", function()
        select()
      end, { desc = "Select opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>ao", function()
        return op("@this ")
      end, { desc = "Add range to opencode", expr = true })
      vim.keymap.set("n", "<leader>al", function()
        return op("@this ") .. "_"
      end, { desc = "Add line to opencode", expr = true })

      vim.keymap.set({ "n", "x" }, "<leader>ae", function()
        ask("Explain @this and its context")
      end, { desc = "Explain code" })
      vim.keymap.set({ "n", "x" }, "<leader>af", function()
        ask("Fix @diagnostics")
      end, { desc = "Fix diagnostics" })
      vim.keymap.set({ "n", "x" }, "<leader>ad", function()
        ask("Add comments documenting @this")
      end, { desc = "Document code" })
      vim.keymap.set({ "n", "x" }, "<leader>ar", function()
        ask("Review @this for correctness and readability")
      end, { desc = "Review code" })
      vim.keymap.set({ "n", "x" }, "<leader>ai", function()
        ask("Implement @this")
      end, { desc = "Implement code" })
      vim.keymap.set({ "n", "x" }, "<leader>az", function()
        ask("Optimize @this for performance and readability")
      end, { desc = "Optimize code" })
      vim.keymap.set({ "n", "x" }, "<leader>aT", function()
        ask("Add tests for @this")
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
