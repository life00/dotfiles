---
name: jupyter
description: Work with .ipynb and Quarto .qmd notebooks in this repo. Use when a task involves notebook files, kernels, or running/reviewing notebook code.
---

Notebooks here are edited as Quarto `.qmd` (nvim, jupytext). The `.qmd` is the source of truth; `.ipynb` is a generated pair.

Rules:

1. For anything structural (new cells, edits, reordering), prefer the `.qmd` or `.ipynb` file directly with normal file edits.
2. After writing to a `.qmd`, sync its `.ipynb` pair with `jupytext --sync file.qmd` (and vice versa) so nvim's buffer stays consistent. Never leave a pair desynced.
3. To run code in a real Jupyter kernel, use the `jupyter` MCP tools:
   - `connect_to_jupyter(kernel_name="python3")` first
   - `use_notebook(path=...)` to attach the file
   - `insert_cell` / `edit_cell_source` / `execute_cell` for cell work
   - `execute_code` for quick experiments outside the notebook
4. When a notebook task is done, verify with `quarto render file.qmd` and fix any errors.

The MCP server's kernel is separate from any nvim/Molten session — treat kernel state as disposable; re-run cells after edits.