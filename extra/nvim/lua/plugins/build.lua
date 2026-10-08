return {
  --------------------------------------------------
  --              build control
  --------------------------------------------------
  {
    "jedrzejboczar/toggletasks.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    lazy = true,
    config = function()
      require("toggletasks").setup({
        tasks = {
          {
            name = "Make default target with entr",
            cmd = "ls [Mm]akefile && ls * | entr make",
            tags = { "build", "make", "entr" },
          },
          {
            name = "Make default",
            cmd = "make",
            tags = { "build", "make" },
          },
          {
            name = "C compile and run",
            cmd = "clang -Wall -Wextra -g ${file} -o ${file:r} && ${file:r}",
            tags = { "c", "build", "run" },
          },
          {
            name = "Go build",
            cmd = "go build ./...",
            tags = { "go", "build" },
          },
          {
            name = "Go test",
            cmd = "go test",
            tags = { "go", "test" },
          },
        },
        scan = {
          global_cwd = false,
          tab_cwd = false,
          win_cwd = false,
          lsp_root = false,
        },
        toggleterm = {
          -- https://github.com/jedrzejboczar/toggletasks.nvim/issues/14
          -- https://github.com/jedrzejboczar/toggletasks.nvim/issues/15
          on_create = function()
            vim.notify("Task spawned", vim.log.levels.INFO)
          end,
          on_exit = function(term, job, exit_code, name)
            local Task = require("toggletasks.task")
            local task = Task.get(term._task_id)
            if not task then
              return
            end
            if exit_code == 0 then
              vim.notify("Task successful: " .. task.config.name, vim.log.levels.INFO)
              -- task:shutdown()
            else
              vim.notify("Task failed: " .. task.config.name, vim.log.levels.ERROR)
            end
          end,
        },
      })
    end,
    cmd = { "Telescope toggletasks spawn", "Telescope toggletasks select" },
    keys = {
      {
        "<leader>ct",
        "<cmd>Telescope toggletasks spawn<cr>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "Spawn tasks",
      },
      {
        "<leader>cT",
        "<cmd>Telescope toggletasks select<cr>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "Select running tasks",
      },
    },
  },
}
