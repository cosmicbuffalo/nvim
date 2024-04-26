
return {
  -- symbol outline viewer
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>co", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    opts = {
      outline_window = {
        auto_close = true,
      }
    },
  },
}
