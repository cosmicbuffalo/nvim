return {
  {
    -- dim inactive windows
    "levouh/tint.nvim",
    config = function()
      require("tint").setup({
        tint = -20
      })
    end,
  },
}
