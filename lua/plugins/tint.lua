return {
  {
    -- dim inactive windows
    "levouh/tint.nvim",
    -- TODO: need to figure out how to get this plugin to ignore dropbar
    enabled = false,

    config = function()
      require("tint").setup({
        tint = -15,
        tint_background_colors = true,
        highlight_ignore_patterns = { "DropBar*" },
        -- focus_change_events = {
        --   focus = { "FocusGained", "WinEnter", "VimEnter", "BufEnter", "BufWinEnter" },
        --   unfocus = { "FocusLost", "WinLeave", "VimLeave", "BufLeave", "BufWinLeave" }
        -- }
        --
        window_ignore_function = function(winid)
          local bufid = vim.api.nvim_win_get_buf(winid)
          local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
          local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

          -- Do not tint `terminal` or floating windows, tint everything else
          return buftype == "terminal" or floating
        end,
      })
    end,
  },
}
