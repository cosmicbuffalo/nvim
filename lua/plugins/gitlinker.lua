return {
  -- shortcuts for github things
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
      local mapping = {
        ["<leader>gy"] = { desc = "Copy GitHub link" },
      }
      local wk = require("which-key")
      wk.register(mapping, { mode = "n" })
      wk.register(mapping, { mode = "v" })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>go",
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { desc = "Open in GitHub", silent = true }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<leader>go",
        '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { desc = "Open in GitHub", silent = true }
      )
      -- not actually a gitlinker feature but included in here since it's similar
      vim.keymap.set(
        "n",
        "<leader>gp",
        ':VimuxRunCommand "pr"<CR>',
        { desc = "Create or open PR in GitHub", silent = true }
      )
    end,
  },
}
