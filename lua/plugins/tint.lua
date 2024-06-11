return {
  {
    -- dim inactive windows
    "levouh/tint.nvim",
    enabled = false,
    config = function()
      require("tint").setup({
        tint = -15,
        tint_background_colors = true,
        -- focus_change_events = {
        --   focus = { "FocusGained", "WinEnter", "VimEnter", "BufEnter", "BufWinEnter" },
        --   unfocus = { "FocusLost", "WinLeave", "VimLeave", "BufLeave", "BufWinLeave" }
        -- }
      })
    end,
  },
}
