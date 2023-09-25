return {
  {
    "anuvyklack/windows.nvim",
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
      vim.keymap.set("n", "<leader>we", "<Cmd>WindowsEqualize<CR>", { desc = "Equalize windows" })
    end,
  },
}
