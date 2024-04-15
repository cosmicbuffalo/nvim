return {
  "bloznelis/before.nvim",
  config = function()
    local before = require("before")
    before.setup({
      history_size = 30,
      telescope_for_preview = true,
    })

    -- Jump to previous entry in the edit history
    vim.keymap.set("n", "<M-o>", before.jump_to_last_edit, { desc = "Go to previous edit" })

    -- Jump to next entry in the edit history
    vim.keymap.set("n", "<M-i>", before.jump_to_next_edit, { desc = "Go to next edit" })

    -- Move edit history to quickfix (or telescope)
    vim.keymap.set("n", "<leader>oe", before.show_edits, { desc = "Open edit list" })
  end,
}
