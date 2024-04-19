return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "<M-w>",
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-w",
    },
    {
      "<M-b>",
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-b",
    },
    {
      "<M-e>",
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-e",
    },
    {
      "g<M-e>",
      "<cmd>lua require('spider').motion('ge')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-ge",
    },
  },
}
