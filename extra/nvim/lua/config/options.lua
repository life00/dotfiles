-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- wrap the text
vim.opt.wrap = true

-- set main spelling language
vim.opt.spelllang = "en_us"

-- enable spelling
vim.opt.spell = true

-- set conceal level to 1
vim.opt.conceallevel = 1

-- set netrw browser viewer
vim.g.netrw_browsex_viewer = "rifle"

-- configure folding
vim.opt.foldlevel = 0
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.require'lazyvim.util'.treesitter.foldexpr()"
