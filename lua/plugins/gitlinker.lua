return {
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
      local mapping = {
        ["<leader>gy"] = { desc = "Copy GitHub link" },
      }
      require("which-key").register(mapping, { mode = "n" })
      require("which-key").register(mapping, { mode = "v" })
    end,
  },
}
