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
    end,
    keys = {
      { "<leader>wm", "<Cmd>WindowsMaximize<CR>", desc = "Maximize window (toggle)" },
      { "<leader>wh", "<Cmd>WindowsMaximizeHorizontally<CR>", desc = "Maximize window horizontally" },
      { "<leader>wv", "<Cmd>WindowsMaximizeVertically<CR>", desc = "Maximize window vertically" },
      { "<leader>we", "<Cmd>WindowsEqualize<CR>", desc = "Equalize windows" },
      { "<leader>wa", "<Cmd>WindowsToggleAutowidth<CR>", desc = "Toggle window autowidth" },
      { "<C-w>a", "<Cmd>WindowsToggleAutowidth<CR>", desc = "Toggle window autowidth" },
    },
  },
}
