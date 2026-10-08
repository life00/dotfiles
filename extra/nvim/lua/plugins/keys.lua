return {
  --------------------------------------------------
  --                  which key
  --------------------------------------------------
  {
    "folke/which-key.nvim",
    opts = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>t", group = "terminal" },
      })
    end,
  },
  --------------------------------------------------
  --                 spider keys
  --------------------------------------------------
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    -- dependencies = {
    --   "theHamsta/nvim_rocks",
    --   build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
    --   config = function()
    --     require("nvim_rocks").ensure_installed("luautf8")
    --   end,
    -- },
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-w",
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-e",
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-b",
      },
      {
        "<C-f>",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = "i",
        desc = "Spider-w",
      },
      {
        "<C-b>",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = "i",
        desc = "Spider-b",
      },
    },
  },
  --------------------------------------------------
  --                 origami
  --------------------------------------------------
  {
    -- this plugin also alters the fold configuration
    "chrisgrieser/nvim-origami",
    lazy = true,
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = {
      -- keep folds while searching (default temporarily opens them)
      pauseFoldsOnSearch = false,
    },
  },
  --------------------------------------------------
  --                 mini surround
  --------------------------------------------------
  -- NOTE: configured here because the extra has partially broken keymaps
  -- its not possible to surround with multiple characters at the same time
  {
    "nvim-mini/mini.surround",
    opts = {
      silent = true,
    },
  },
  --------------------------------------------------
  --                    flash
  --------------------------------------------------
  {
    "folke/flash.nvim",
    opts = {
      modes = { char = { jump_labels = true } },
    },
    keys = function()
      -- Define the filetypes you want to exclude
      local excluded_filetypes = { "qf", "netrw", "TelescopePrompt" }

      return {
        {
          "<CR>",
          mode = { "n", "o", "v" },
          function()
            -- check if the current filetype is in the excluded list
            if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
              -- send the actual Enter key behavior
              return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
            end

            -- otherwise run flash
            require("flash").jump()
          end,
          desc = "Flash jump",
        },
      }
    end,
  },
}
