-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- disable spellchecking in terminals and man pages
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toggleterm", "terminal", "man" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- autocmd to automatically create lists in markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.formatoptions:append("r") -- <CR> in insert mode
    -- vim.opt_local.formatoptions:append("o") -- o in normal mode
    vim.opt_local.comments = {
      "b:- [ ]", -- tasks
      "b:- [x]",
      "b:*", -- unordered list
      "b:-",
      "b:+",
      "b:1.", -- numbers
    }
  end,
})
