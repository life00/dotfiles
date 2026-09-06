-- catppuccin colors
local colors = {
  base = "#24273a",
  red = "#ed8796",
  flamingo = "#f0c6c6",
  crust = "#181926",
  mantle = "#1e2030",
  peach = "#f5a97f",
  mauve = "#c6a0f6",
  green = "#a6da95",
  blue = "#8aadf4",
  text = "#cad3f5",
  overlay2 = "#939ab7",
  surface0 = "#363a4f",
  surface1 = "#494d64",
}
-- required for lualine config
local Util = require("lazyvim.util")

return {
  --------------------------------------------------
  --                  color scheme
  --------------------------------------------------
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      custom_highlights = {
        Folded = { fg = colors.flamingo, bg = colors.surface0, bold = true },
        markdownH1 = { bold = true },
        markdownH2 = { bold = true },
        markdownH3 = { bold = true },
        markdownH4 = { bold = true },
        markdownH5 = { bold = true },
        markdownH6 = { bold = true },
        -- also apply to other similar variables just in case
        Headline1 = { bold = true },
        Headline2 = { bold = true },
        Headline3 = { bold = true },
        Headline4 = { bold = true },
        Headline5 = { bold = true },
        Headline6 = { bold = true },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },
  --------------------------------------------------
  --                  dashboard
  --------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
  ⠀⠀⠀⠀⠀⠀⠀⡠⠖⢤⡀⠀⠀⠀⠀⠀⢀⠔⠲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠑⣆⣀⣀⣀⣀⠎⠀⠀⠈⢣⡀⠤⠤⢴⣶⣶⣦⡤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠛⠙⠟⠘⠟⠀⠀⠀⠀⠀⠀⠀⠀⡘⡿⠯⠟⠀⢿⣿⣿⠟⠒⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠉⠈⢉⡁⡇⠀⠀⢠⣶⣄⠀⡀⣶⢀⠀⢠⣶⡄⠀⠀⣊⣉⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢢⠀⠀⠀⠀⠀⠀⢀⠀⠀
  ⠈⠉⠁⠀⢸⠂⠀⠀⠈⠉⠁⠈⠛⠛⠛⠀⠈⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡀⠀⠀⢠⣾⣿⣿⠆
  ⠀⠀⠀⠀⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⣠⣿⣄⢙⠏⠀
  ⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠘⢿⡿⠋⠀⠀
  ⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠦⠚⠁⠀⠀⠀
  ⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡎⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠙⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠸⣀⡰⠒⠒⠒⠒⢲⠂⢰⠖⠒⠒⠒⠒⠒⠒⢆⣀⠶⠒⠒⠒⠒⢆⣠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  ⠀⠀⠀⠀⠀⠀⠀⠛⠂⠒⠒⠐⠒⠒⠒⠒⠒⠒⠒⠒⠐⠓⠒⠓⠚⠓⠒⠐⠐⠒⠒⠓⠒⠲⠒⠓⠐⠛⠓⠒⠒⠀⠀⠀⠀⠀
]],
          --     ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
          --     ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
          --     ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
          --     ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
          --     ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
          --     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
          -- ⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣶⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          -- ⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣄⣀⡀⣠⣾⡇⠀⠀⠀⠀
          -- ⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀
          -- ⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⢿⣿⣿⡇⠀⠀⠀⠀
          -- ⣶⣿⣦⣜⣿⣿⣿⡟⠻⣿⣿⣿⣿⣿⣿⣿⡿⢿⡏⣴⣺⣦⣙⣿⣷⣄⠀⠀⠀
          -- ⣯⡇⣻⣿⣿⣿⣿⣷⣾⣿⣬⣥⣭⣽⣿⣿⣧⣼⡇⣯⣇⣹⣿⣿⣿⣿⣧⠀⠀
          -- ⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠸⣿⣿⣿⣿⣿⣿⣿⣷⠀
        },
        sections = {
          { section = "header" },
          { section = "startup" },
          { pane = 2, section = "keys", gap = 1, padding = 2 },
          { pane = 2, section = "projects" },
        },
      },
    },
  },
  --------------------------------------------------
  --                  status line
  --------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("lazyvim.config").icons

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = {
            normal = {
              -- a = { fg = colors.blue, bg = colors.crust, gui = "bold" },
              a = { fg = colors.blue, bg = colors.crust },
              b = { fg = colors.text, bg = colors.crust },
              c = { fg = colors.text, bg = colors.mantle },
              x = { fg = colors.blue, bg = colors.mantle },
              y = { fg = colors.blue, bg = colors.crust },
              z = { fg = colors.blue, bg = colors.crust },
            },
            insert = {
              a = { fg = colors.green, bg = colors.crust },
              b = { fg = colors.text, bg = colors.crust },
              c = { fg = colors.text, bg = colors.mantle },
              x = { fg = colors.green, bg = colors.mantle },
              y = { fg = colors.green, bg = colors.crust },
              z = { fg = colors.green, bg = colors.crust },
            },
            visual = {
              a = { fg = colors.mauve, bg = colors.crust },
              b = { fg = colors.text, bg = colors.crust },
              c = { fg = colors.text, bg = colors.mantle },
              x = { fg = colors.mauve, bg = colors.mantle },
              y = { fg = colors.mauve, bg = colors.crust },
              z = { fg = colors.mauve, bg = colors.crust },
            },
            command = {
              a = { fg = colors.peach, bg = colors.crust },
              b = { fg = colors.text, bg = colors.crust },
              c = { fg = colors.text, bg = colors.mantle },
              x = { fg = colors.peach, bg = colors.mantle },
              y = { fg = colors.peach, bg = colors.crust },
              z = { fg = colors.peach, bg = colors.crust },
            },
            replace = {
              a = { fg = colors.red, bg = colors.crust },
              b = { fg = colors.text, bg = colors.crust },
              c = { fg = colors.text, bg = colors.mantle },
              x = { fg = colors.red, bg = colors.mantle },
              y = { fg = colors.red, bg = colors.crust },
              z = { fg = colors.red, bg = colors.crust },
            },
            terminal = {
              a = { fg = colors.overlay2, bg = colors.crust },
              b = { fg = colors.text, bg = colors.crust },
              c = { fg = colors.text, bg = colors.mantle },
              x = { fg = colors.overlay2, bg = colors.mantle },
              y = { fg = colors.overlay2, bg = colors.crust },
              z = { fg = colors.overlay2, bg = colors.crust },
            },
            -- -- idk what this is
            inactive = {
              a = { fg = colors.overlay2, bg = colors.crust },
              b = { fg = colors.text, bg = colors.crust },
              c = { fg = colors.text, bg = colors.mantle },
              x = { fg = colors.overlay2, bg = colors.mantle },
              y = { fg = colors.overlay2, bg = colors.crust },
              z = { fg = colors.overlay2, bg = colors.crust },
            },
          },
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = {
            {
              function()
                return " "
              end,
              separator = { left = "", right = "" },
              padding = { left = 1, right = 0 },
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              -- color = Util.ui.fg("Statement"),
              padding = { left = 0, right = 1 },
              separator = { left = "", right = "" },

            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              -- color = Util.ui.fg("Constant"),
              padding = { left = 0, right = 1 },
              separator = { left = "", right = "" },

            },
          },
          lualine_b = {
            {
              function()
                if vim.bo.filetype == "text" or vim.bo.filetype == "tex" or vim.bo.filetype == "markdown" then
                  if not (vim.fn.wordcount().visual_words == nil) then
                    return " " .. tostring(vim.fn.wordcount().visual_words)
                  else
                    return " " .. tostring(vim.fn.wordcount().words)
                  end
                else
                  return ""
                end
              end,
              color = { fg = colors.flamingo },
              separator = { left = "", right = "" },
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              separator = { left = "", right = "" },
            },

            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = { fg = Snacks.util.color("Debug") },
              separator = { left = "", right = "" },

            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = Snacks.util.color("Debug") },
              separator = { left = "", right = "" },
            },
          },
          lualine_c = {
            Util.lualine.root_dir(),
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { Util.lualine.pretty_path() },
            {
              "aerial",
              sep = " ", -- separator between symbols
              sep_icon = "", -- separator between icon and symbol

              -- The number of symbols to render top-down. In order to render only 'N' last
              -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
              -- be used in order to render only current symbol.
              depth = 5,

              -- When 'dense' mode is on, icons are not rendered near their symbols. Only
              -- a single icon that represents the kind of current symbol is rendered at
              -- the beginning of status line.
              dense = false,

              -- The separator to be used to separate symbols in dense mode.
              dense_sep = ".",

              -- Color the symbol icons.
              colored = true,
            },
          },
          lualine_x = {},
          lualine_y = {
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              separator = { left = "", right = "" },
            },

            {
              "branch",
              icon = { "" },
              color = { fg = colors.peach },
              separator = { left = "", right = "" },
            },
          },
          lualine_z = {
            {
              function()
                return ""
              end,
              color = { fg = colors.mauve },
              separator = { left = "", right = "" },
              padding = { left = 1, right = 0 },
            },
            {
              "progress",
              color = { fg = colors.mauve },
            },
            {
              "location",
              padding = { left = 0, right = 1 },
              separator = { left = "", right = "" },
              color = { fg = colors.mauve },
            },
          },
        },
        extensions = { "lazy", "mason" },
      }
    end,
  },
}
