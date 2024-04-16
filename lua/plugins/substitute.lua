return {
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

    keymap.set("n", "sx", require("substitute.exchange").operator, { desc = "Exchange with motion", noremap = true })
    keymap.set("n", "sxx", require("substitute.exchange").line, { desc = "Exchange line", noremap = true })
    keymap.set("x", "X", require("substitute.exchange").visual, { desc = "Exchange visual selection", noremap = true })
    keymap.set("n", "sxc", require("substitute.exchange").cancel, { desc = "Cancel exchange", noremap = true })
  end,
}
