return {
  {
    "anuvyklack/windows.nvim",
    -- enabled = false,
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()

      vim.keymap.set("n", "<leader>wm", "<Cmd>WindowsMaximize<CR>", { desc = "Maximize window (toggle)" })
      vim.keymap.set("n", "<leader>wh", "<Cmd>WindowsMaximizeHorizontally<CR>", { desc = "Maximize window horizontally" })
      vim.keymap.set("n", "<leader>wv", "<Cmd>WindowsMaximizeVertically<CR>", { desc = "Maximize window vertically" })
      vim.keymap.set("n", "<leader>we", "<Cmd>WindowsEqualize<CR>", { desc = "Equalize windows" })
      vim.keymap.set("n", "<leader>wa", "<Cmd>WindowsToggleAutowidth<CR>", { desc = "Toggle window autowidth" })
      vim.keymap.set("n", "<C-w>a", "<Cmd>WindowsToggleAutowidth<CR>", { desc = "Toggle window autowidth" })
    end,
  },
}
