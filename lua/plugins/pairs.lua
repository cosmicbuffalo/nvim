return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {
      check_ts = true,
    },
  },
  -- jump between more complex pairs with %
  -- also does highlighting of destination pairs
  {
    "andymass/vim-matchup",
    lazy = false,
  },
  -- surround text with quotes, brackets, etc.
  {
    "kylechui/nvim-surround",
    -- enabled = false,
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        move_cursor = false,
        -- keymaps = {
        --   visual = "",
        -- }
      })
    end,
  },
}
