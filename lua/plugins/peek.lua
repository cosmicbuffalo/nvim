return {}

return {
  {
    "cloudsftp/peek.nvim",
    branch = "bundle",
    config = function()
      require("peek").setup()
    end,
    build = "deno task --quiet build:fast",
  },
}
