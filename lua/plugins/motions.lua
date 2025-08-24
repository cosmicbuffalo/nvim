return {
  {
    -- This thing is great
    "gbprod/substitute.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local substitute = require("substitute")

      substitute.setup()

      -- set keymaps
      local keymap = vim.keymap -- for conciseness
      keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion", noremap = true })
      keymap.set("n", "ss", substitute.line, { desc = "Substitute line", noremap = true })
      keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line", noremap = true })
      keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode", noremap = true })

      local exchange = require("substitute.exchange")
      keymap.set("n", "sx", exchange.operator, { desc = "Exchange with motion", noremap = true })
      keymap.set("n", "sxx", exchange.line, { desc = "Exchange line", noremap = true })
      keymap.set("x", "X", exchange.visual, { desc = "Exchange visual selection", noremap = true })
      keymap.set("n", "sxc", exchange.cancel, { desc = "Cancel exchange", noremap = true })
    end,
  },
  {
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
        "<M-g><M-e>",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-ge",
      },
    },
  },
  {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup()
    end,
  },
}
