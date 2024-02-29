return {
  { "cosmicbuffalo/darkplus.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "darkplus",
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "css",
        "javascript",
        "html",
        "slim",
      })
    end,
  },
  {
    "m00qek/baleia.nvim",
    config = function()
      require("baleia").setup({})
    end,
  },
}
