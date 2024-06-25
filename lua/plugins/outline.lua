
return {
  -- symbol outline viewer
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>co", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    opts = {
      outline_window = {
        show_numbers = false,
        show_relative_numbers = false,
        auto_close = false,
        auto_jump = true,
      },
      outline_items = {
        show_symbol_lineno = true
      }
    },
  },
}
