return {
  -- {
  --   "echanovski/mini.pairs",
  --   enabled = false
  -- },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {
      check_ts = true,
    }
  }
}
