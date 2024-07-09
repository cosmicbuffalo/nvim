return {
  -- seamless navigation between vim and tmux panes
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "i", "x", "o" }, desc = "Tmux Navigate Left", silent = true },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Tmux Navigate Down", silent = true },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",  desc = "Tmux Navigate Up", silent = true },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "i", "x", "o" }, desc = "Tmux Navigate Right", silent = true },
    }
  },
}
