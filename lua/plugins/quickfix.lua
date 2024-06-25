return {
  {
    "yorickpeterse/nvim-pqf",
    config = function()
      require("pqf").setup()
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },
}
