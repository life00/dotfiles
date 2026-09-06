-- priority for blink.cmp suggestions
-- local source_priority = {
--   snippets = 4,
--   lsp = 3,
--   path = 2,
--   buffer = 1,
-- }

return {
  ------------------------------------------------------------
  ---                     blink.cmp
  ------------------------------------------------------------
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- "echasnovski/mini.snippets",
    },
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = "default",
        ["<CR>"] = {},
        ["<S-CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      -- sources = {
      --   -- this doesn't actually order the priority
      --   -- see: https://github.com/Saghen/blink.cmp/issues/1098
      --   default = { "snippets", "lsp", "path", "buffer" },
      --   providers = {
      --     snippets = {
      --       opts = {
      --         friendly_snippets = true,
      --         extended_filetypes = {
      --           md = { "loremipsum" },
      --         },
      --       },
      --     },
      --   },
      -- },
      -- workaround to make priority work
      -- fuzzy = {
      --   sorts = {
      --     function(a, b)
      --       local a_priority = source_priority[a.source_id]
      --       local b_priority = source_priority[b.source_id]
      --       if a_priority ~= b_priority then
      --         return a_priority > b_priority
      --       end
      --     end,
      --     -- defaults
      --     "score",
      --     "sort_text",
      --   },
      -- },
      -- use mini.snippets for snippets engine
      snippets = { preset = "luasnip" },
    },
  },
}
