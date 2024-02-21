return {
  {
    "folke/flash.nvim",
    opts = {
      labels = "neiotsrahdcmglpufbjywxzq",
      modes = {
        search = {
          enabled = false,
        },
        -- treesitter = {
        --   -- labels = "neiotsrahdcmglpufbjywxzq",
        -- },
      },
    },
    keys = {
      { "s", false },
      { "S", false },
      { "q", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "Q", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    }
  },
}
