return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {
      check_ts = true,
    }
  },
  -- jump between more complex pairs with %
  -- also does highlighting of destination pairs
  {
    'andymass/vim-matchup'
  }
}
