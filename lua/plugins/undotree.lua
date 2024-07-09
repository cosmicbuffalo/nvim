return {
  -- visualize and restore branching undo history
  {
    "mbbill/undotree",
    cmd = "Undotree",
    keys = {
      { "<leader>U", ":UndotreeToggle<CR>", desc = "Undo Tree" },
      { "<leader>sU", ":Telescope undo<cr>", desc = "Undo Tree (Telescope)" },
    }
  },
}
