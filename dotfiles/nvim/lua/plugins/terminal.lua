----
-- environment for toggleterm keymaps
----

-- trim spaces for toggleterm; I don't use any space sensitive languages
local trim_spaces = true
-- declare set_opfunc function for advanced REPL keymaps (file sending)
-- TODO: https://github.com/akinsho/toggleterm.nvim/issues/542
local set_opfunc = vim.fn[vim.api.nvim_exec(
  [[
    func s:set_opfunc(val)
    let &opfunc = a:val
    endfunc
    echon get(function('s:set_opfunc'), 'name')
  ]],
  true
)]

return {
  --------------------------------------------------
  --                  terminal
  --------------------------------------------------
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = true,
    cmd = "ToggleTerm",
    keys = {
      -- Open toggleterm horizontally
      {
        "<leader>T-",
        "<Cmd>ToggleTerm size=15 direction=horizontal<CR>",
        mode = { "v", "n" },
        noremap = true,
        silent = true,
        desc = "Open toggleterm horizontally",
      },
      -- Open toggleterm vertically
      {
        "<leader>T|",
        "<Cmd>ToggleTerm size=50 direction=vertical<CR>",
        mode = { "v", "n" },
        noremap = true,
        silent = true,
        desc = "Open toggleterm vertically",
      },
      -- Send current line to toggleterm
      {
        "<C-cr>",
        -- function()
        -- require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
        -- end,
        -- regex inside is specifically converted to work with (neo)vim regex
        -- original regex code: ^(?!#).+
        -- backslashes are added for lua not to complain
        -- it matches all non empty lines (those that have something which is not space)
        -- it does not match lines which start with # character
        "<Cmd>ToggleTermSendCurrentLine<CR><Cmd>call search('^\\(#\\)\\@!.\\+')<CR>",
        mode = "n",
        noremap = true,
        silent = true,
        ft = { "python", "r" },
        desc = "Send current line to toggleterm",
      },
      {
        "<leader>Ts",
        -- function()
        -- require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
        -- end,
        "<Cmd>ToggleTermSendCurrentLine<CR><Cmd>call search('^\\(#\\)\\@!.\\+')<CR>",
        mode = "n",
        noremap = true,
        silent = true,
        desc = "Send current line to toggleterm",
      },
      -- Send selection lines to toggleterm
      {
        "<C-cr>",
        function()
          require("toggleterm").send_lines_to_terminal("visual_lines", trim_spaces, { args = vim.v.count })
        end,
        mode = "v",
        ft = { "python", "r" },
        noremap = true,
        silent = true,
        desc = "Send selection lines to toggleterm",
      },
      {
        "<leader>Ts",
        function()
          require("toggleterm").send_lines_to_terminal("visual_lines", trim_spaces, { args = vim.v.count })
        end,
        mode = "v",
        noremap = true,
        silent = true,
        desc = "Send selection lines to toggleterm",
      },
      {
        -- Send file to toggleterm
        "<leader>Tf",
        function()
          set_opfunc(function(motion_type)
            require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
          end)
          vim.api.nvim_feedkeys("ggg@G''", "n", false)
        end,
        mode = "n",
        noremap = true,
        silent = true,
        desc = "Send file to toggleterm",
      },
    },
    config = true,
  },
}
