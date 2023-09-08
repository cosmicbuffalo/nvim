return {
  {
    "cloudsftp/peek.nvim",
    enabled = false,
    branch = "bundle",
    config = function()
      require("peek").setup()
    end,
    build = "deno task --quiet build:fast",
  },
}
