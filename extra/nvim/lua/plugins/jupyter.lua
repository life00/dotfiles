-- Schedule multi-cell molten runs with a small stagger
local dispatch = { gen = 0, next_delay = 0 }

local function cancel_dispatch()
  dispatch.gen = dispatch.gen + 1
end

local function setup_paced_runner()
  local runner = require("quarto.runner")
  local molten = require("quarto.runner.molten")
  if molten.paced then
    return
  end
  molten.paced = true

  local stagger_ms = 100
  local send = molten.run
  molten.run = function(cell, ignore_cols)
    local gen, delay = dispatch.gen, dispatch.next_delay
    local buf = vim.api.nvim_get_current_buf()
    dispatch.next_delay = dispatch.next_delay + stagger_ms
    vim.defer_fn(function()
      if gen ~= dispatch.gen or vim.api.nvim_get_current_buf() ~= buf then
        return
      end
      if not vim.api.nvim_buf_is_loaded(buf) then
        return
      end
      local ok, err = pcall(send, cell, ignore_cols)
      if not ok then
        vim.notify("[quarto] " .. tostring(err), vim.log.levels.ERROR)
      end
    end, delay)
  end

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("MoltenPacedDispatch", { clear = true }),
    callback = cancel_dispatch,
  })

  for _, name in ipairs({ "run_cell", "run_above", "run_below", "run_all", "run_range" }) do
    local run = runner[name]
    runner[name] = function(...)
      dispatch.gen = dispatch.gen + 1
      dispatch.next_delay = 0
      return run(...)
    end
  end
end

return {
  -- quarto-nvim
  -- for preview, LSP & suggestions integration, and code running
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    keys = {
      {
        -- preview with automatic cleanup of artifacts
        "<leader>cp",
        function()
          local root = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":r")
          require("quarto").quartoPreview({ args = "--execute --timeout 10" })
          local ok, out = pcall(vim.api.nvim_buf_get_var, 0, "quartoOutputBuf")
          if ok then
            vim.api.nvim_create_autocmd("TermClose", {
              callback = function()
                if vim.fn.expand("<abuf>") == tostring(out) then
                  vim.fn.delete(root .. ".html")
                  vim.fn.delete(root .. "_files", "rf")
                  for _, f in ipairs(vim.fn.glob(root .. ".quarto_ipynb*", false, true)) do
                    vim.fn.delete(f)
                  end
                end
              end,
            })
          end
        end,
        desc = "Quarto preview (auto-clean artifacts)",
      },
    },
    opts = {
      closePreviewOnExit = false,
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    config = function(_, opts)
      local quarto = require("quarto")
      quarto.setup(opts)
      setup_paced_runner()
    end,
  },
  -- jupytext
  -- for converting ipynb files to quarto
  -- NOTE: I wasn't able to get LSP working for ipynb files
  -- related discussion: <https://github.com/jmbuhr/otter.nvim/issues/154#issuecomment-2211434551>
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
        R = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },
  -- molten
  -- for running the code in jupyter environment
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    lazy = false,
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_auto_image_popup = true
      vim.g.molten_cover_empty_lines = true
      vim.g.molten_enter_output_behavior = "open_and_enter"
      vim.g.molten_image_provider = "none"
      vim.g.molten_wrap_output = true
      vim.g.molten_output_show_exec_time = false
      vim.g.molten_output_win_max_height = 32
      vim.g.molten_virt_text_max_lines = 8
      vim.g.molten_virt_text_output = true

      -- export session outputs into the ipynb on save, so quarto preview
      -- shows them (quarto never executes ipynb cells)
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.ipynb" },
        callback = function()
          if require("molten.status").initialized() == "Molten" then
            vim.cmd("MoltenExportOutput!")
          end
        end,
      })
    end,
    keys = {
      { "<leader>cji", ":MoltenInit<CR>", desc = "Molten initialize" },
      { "<leader>cjI", ":MoltenInfo<CR>", desc = "Molten info" },
      {
        "<leader>cjX",
        function()
          require("quarto.runner").run_all()
        end,
        desc = "Run all",
      },
      {
        "<leader>cjxk",
        function()
          require("quarto.runner").run_above()
        end,
        desc = "Run all above",
      },
      {
        "<leader>cjxj",
        function()
          require("quarto.runner").run_below()
        end,
        desc = "Run all below",
      },
      { "<leader>cjc", ":MoltenDelete<CR>", desc = "Clear active cell" },
      { "<leader>cjr", ":MoltenRestart<CR>", desc = "Restart Molten" },
      {
        "<leader>cjC",
        function()
          cancel_dispatch()
          vim.cmd("MoltenInterrupt")
        end,
        desc = "Cancel execution",
      },
      { "<leader>cjj", ":MoltenNext<CR>", desc = "Go to next cell" },
      { "<leader>cjk", ":MoltenPrev<CR>", desc = "Go to prev cell" },
      { "<leader>cjo", ":noautocmd MoltenEnterOutput<CR>", desc = "Enter output" },
      {
        "<C-cr>",
        function()
          if vim.bo.filetype == "quarto" then
            require("quarto.runner").run_cell()
          end
        end,
        desc = "Run cell",
      },
      { "<C-cr>", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Run visual" },
      { "<leader>cjp", ":MoltenImagePopup<CR>", desc = "Preview image" },
      { "<leader>cjni", ":MoltenImportOutput<CR>", desc = "Import notebook output" },
      { "<leader>cjne", ":MoltenExportOutput<CR>", desc = "Export notebook output" },
    },
  },
  -- aerial
  {
    "stevearc/aerial.nvim",
    opts = {
      backends = {
        _ = { "lsp", "treesitter", "markdown", "man" },
        -- skip lsp for quarto: otter-ls request() returns nil, so aerial warns
        -- "Error requesting document symbols" on every refresh
        quarto = { "treesitter", "markdown" },
      },
    },
  },
  -- venv selector
  -- configure keybinding to also appear in quarto
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    ft = { "python", "quarto" },
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = { "python", "quarto" } } },
  },
}
