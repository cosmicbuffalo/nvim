return {
  { "nvim-neotest/neotest-plenary" },
  -- { "nvim-neotest/neotest-rspec" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = { "neotest-plenary", "neotest-rspec" },
    },
  },
}
