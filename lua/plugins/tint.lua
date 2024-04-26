return {
  {
    -- dim inactive windows
    "levouh/tint.nvim",
    -- enabled = false,
    config = function()
      require("tint").setup({
        tint = -20,
        focus_change_events = {
          focus = { "FocusGained", "WinEnter", "VimEnter", "BufEnter", "BufWinEnter" },
        }
      })
    end,
  },
}
