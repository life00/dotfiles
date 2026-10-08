-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- sets ^l as spellcheck shortcut
vim.keymap.set("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { noremap = true, silent = true, desc = "Correct spelling" })

-- Jump to the next non empty and non comment line with C-n or back C-p
vim.keymap.set(
  { "n", "v" },
  "<C-n>",
  "<Cmd>call search('^\\(#\\|--\\|//\\)\\@!.\\+')<CR>",
  { noremap = true, silent = true, desc = "Jump to next line of code" }
)

-- Jump to previous line of code
vim.keymap.set(
  { "n", "v" },
  "<C-p>",
  "<Cmd>call search('^\\(#\\|--\\|//\\)\\@!.\\+', 'b')<CR>",
  { noremap = true, silent = true, desc = "Jump to previous line of code" }
)

-- remap gx for normal mode to open file under cursor
-- the default keymap is not working well for me
vim.keymap.set({ "n" }, "gx", function()
  vim.ui.open(vim.fn.expand("<cfile>"))
end, { noremap = true, silent = true, desc = "Open file under cursor" })

-- bufferline.nvim alt+num keymaps
for i = 1, 5 do
  vim.keymap.set({ "n", "v" }, "<A-" .. i .. ">", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    noremap = true,
    silent = true,
    desc = "Go to buffer " .. i,
  })
end
