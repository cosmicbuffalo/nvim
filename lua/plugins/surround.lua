return {

  {
    "kylechui/nvim-surround",
    -- version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        move_cursor = false,
        keymaps = {
          visual = "gs",
        }
      })
    end
  },
  {
    "echasnovski/mini.surround",
    enabled = false
  }

}
