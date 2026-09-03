return {
  --------------------------------------------------
  --              markdown preview
  --------------------------------------------------
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    lazy = true,
    -- uncomment when using auto start
    -- ft = { "markdown" },
    -- for the commented config make sure to run: `yarn add tslib` in /home/user/etc/data/nvim/lazy/markdown-preview.nvim
    -- build = function()
    --   vim.fn["mkdp#util#install"]()
    -- end,
    build = "cd app && yarn install",
    init = function()
      -- set to 1, nvim will open the preview window after entering the markdown buffer
      -- vim.g.mkdp_auto_start = 1
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = { imageFormat = "svg" },
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "relative",
        hide_yaml_meta = 0,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        -- content_editable = v:false,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_markdown_css = "/home/user/.cfg/nvim/styles/preview.css"
      vim.g.mkdp_page_title = "${name}"
      vim.g.mkdp_browser = "chromium-markdown-preview"
    end,
    keys = {
      {
        "<leader>cp",
        ft = { "markdown" },
        -- this allows to keep markdown-preview.nvim lazy until toggled
        function()
          vim.fn["mkdp#util#toggle_preview"]()
        end,
        -- "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
