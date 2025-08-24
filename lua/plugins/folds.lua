return {
  {
    "cosmicbuffalo/lazy_ufo_recipe",
    opts = {
      enable_next_line_virt_text = true,
    },
  },
  {
    "cosmicbuffalo/fold-preview.nvim",
    branch = "fix-eventignore",
    dependencies = {
      "cosmicbuffalo/keymap-amend.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      require("fold-preview").setup({
        default_keybindings = false,
      })
      local map = require("fold-preview").mapping
      local keymap = vim.keymap
      keymap.amend = require("keymap-amend")

      keymap.amend("n", "<right>", map.show_close_preview_open_fold, { desc = "Preview/open fold" })
      keymap.amend("n", "<left>", map.close_preview, { desc = "Close fold preview" })
      keymap.amend("n", "za", map.close_preview, { desc = "Toggle fold under cursor" })
      keymap.amend("n", "zo", map.close_preview, { desc = "Open fold under cursor" })
      keymap.amend("n", "zO", map.close_preview, { desc = "Open all folds under cursor" })
      keymap.amend("n", "zR", map.close_preview, { desc = "Open all folds" })
      keymap.amend("n", "zc", map.close_preview_without_defer, { desc = "Close fold under cursor" })
      keymap.amend("n", "zC", map.close_preview_without_defer, { desc = "Close all folds under cursor" })
      keymap.amend("n", "zM", map.close_preview_without_defer, { desc = "Close all folds" })
    end,
  },
}
