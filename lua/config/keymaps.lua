-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local km = vim.keymap

km.set("n", "<Leader>a", "ggVG<c-$>", { desc = "Select All" })

km.set("v", "y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

-- undotree
km.set("n", "<leader>U", ":UndotreeToggle<cr>", { desc = "Undo Tree" })

km.set("n", "<leader>um", function()
  require("telescope").extensions.notify.notify()
end, { desc = "Notification History" })

-- tmux
km.set("n", "<C-h>", ":TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
km.set("n", "<C-j>", ":TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
km.set("n", "<C-k>", ":TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
km.set("n", "<C-l>", ":TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })

-- cursor position hacks
km.set("n", "J", "mzJ`z", { desc = "Join Lines" })
km.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
km.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
km.set("n", "n", "nzzzv", { desc = "Next Search" })
km.set("n", "N", "Nzzzv", { desc = "Previous Search" })

-- greatest remap ever
km.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })

-- next greatest remap ever : asbjornHaland
km.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
km.set("n", "<leader>Y", [["+Y]], { desc = "Yank to clipboard" })

km.set("n", "<leader>z", "za", { desc = "Toggle Fold" })
km.set(
  "n",
  "<leader>S",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search + replace under cursor" }
)
-- km.set(
--   "v",
--   "<leader>S",
--   [[:s/\<<C-r>"\>/<C-r>"//gI<Left><Left><Left>]],
--   { noremap = true, silent = false, expr = false, desc = "Search + replace selection" }
-- )
km.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

-- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/config/keymaps.lua
-- for some reason can't get these to work
-- local ui = require("harpoon.ui")
-- km.set("n", "<M-n>", function()
--   ui.nav_file(1)
-- end, { silent = true, noremap = true, desc = "which_key_ignore" })
--
-- km.set("n", "<M-e>", function()
--   ui.nav_file(2)
-- end, { silent = true, noremap = true, desc = "which_key_ignore" })
--
-- km.set("n", "<M-i>", function()
--   ui.nav_file(3)
-- end, { silent = true, noremap = true, desc = "which_key_ignore" })
--
-- km.set("n", "<M-o>", function()
--   ui.nav_file(4)
-- end, { silent = true, noremap = true, desc = "which_key_ignore" })

vim.api.nvim_set_keymap(
  "n",
  "<leader>bc",
  [[:let @+=system("git rev-parse --show-toplevel")[:-2] . "/" . fnamemodify(expand("%"), ":~:.")<CR>]],
  { noremap = true, silent = true, desc = "Copy relative path" }
)

km.set("n", "<leader>fF", function()
  require("telescope.builtin").find_files({
    find_command = { "rg", "--files", "--hidden", "-g", "!{.git,node_modules,redux_devtools,tmp,vendor}" },
    no_ignore = true,
  })
end, { desc = "Find Files (cwd)" })
