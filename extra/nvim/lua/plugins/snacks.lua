return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        replace_netrw = true,
        trash = false,
      },
    },
    keys = {
      {
        "<leader>E",
        function()
          local sel = vim.fn.tempname()
          local dir = vim.fn.expand("%:p:h")
          Snacks.terminal({ "lf", "-selection-path", sel, dir ~= "" and dir or vim.fn.getcwd() }, {
            win = { position = "float", border = "rounded" },
            auto_close = true,
            interactive = true,
          })
          local buf = vim.api.nvim_get_current_buf()
          -- open picked files when lf exits
          vim.api.nvim_create_autocmd("TermClose", {
            callback = function(ev)
              if ev.buf ~= buf then
                return
              end
              vim.schedule(function()
                if vim.fn.filereadable(sel) == 1 then
                  for _, f in ipairs(vim.fn.readfile(sel)) do
                    vim.cmd.edit(vim.fn.fnameescape(f))
                  end
                  vim.fn.delete(sel)
                end
              end)
              return true
            end,
          })
        end,
        desc = "lf (pick files)",
      },
    },
  },
}
