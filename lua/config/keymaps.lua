-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local km = vim.keymap

km.set("n", "<Leader>a", "ggVG<c-$>", { desc = "Select All" })

km.set("v", "y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
km.set("n", "<leader>'", mark.add_file, { desc = "Add file to harpoon" })
km.set("n", "<C-'>", ui.toggle_quick_menu, { desc = "Harpoon Quick Menu" })
km.set("n", "<C-n>", function()
  ui.nav_file(1)
end, { desc = "Harpoon File 1" })

km.set("n", "<C-e>", function()
  ui.nav_file(2)
end, { desc = "Harpoon File 2" })

km.set("n", "<C-i>", function()
  ui.nav_file(3)
end, { desc = "Harpoon File 3" })

km.set("n", "<C-o>", function()
  ui.nav_file(4)
end, { desc = "Harpoon File 4" })

km.set("n", "<C-<tab>>", function()
  ui.nav_file(5)
end, { desc = "Harpoon File 5" })

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
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to clipboard" })

vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search + replace under cursor" })
vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })