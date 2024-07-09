return {
  "bloznelis/before.nvim",
  opts = {
    history_size = 30,
    telescope_for_preview = true,
  },
  keys = {
    -- Jump to previous entry in the edit history
    {
      "<M-o>",
      function()
        require("before").jump_to_last_edit()
      end,
      desc = "Go to previous edit",
    },

    -- Jump to next entry in the edit history
    {
      "<M-i>",
      function()
        require("before").jump_to_next_edit()
      end,
      desc = "Go to next edit",
    },

    -- Show last 30 edits in telescope
    {
      "<leader>se",
      function()
        require("before").show_edits()
      end,
      desc = "Open edit list",
    },
  },
}
