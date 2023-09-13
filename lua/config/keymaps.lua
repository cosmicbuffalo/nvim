-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local km = vim.keymap

km.set("n", "<Leader>a", "ggVG<c-$>", { desc = "Select All" })

km.set("v", "y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

-- undotree
km.set("n", "<leader>U", ":UndotreeToggle<cr>", { desc = "Undo Tree" })

km.set("n", "<leader>uh", function()
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

function StartFindAndReplaceSelection()
  -- Yank the current selection
  vim.cmd([[normal! gvy]])

  -- Get the yanked text from the unnamed register
  local selected_text = vim.fn.getreg('"')

  -- Escape any special characters in the text
  local escaped_text = vim.fn.escape(selected_text, "/\\")

  -- Populate the command line with the substitute command
  local cmd = ":%s/" .. escaped_text .. "/" .. escaped_text .. "/gI"
  vim.fn.feedkeys(":" .. cmd, "t")

  -- Move the cursor three spaces to the left to get to the end of the replacement text
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left><Left><Left>", true, true, true), "n", true)
end

vim.api.nvim_set_keymap(
  "v",
  "<leader>S",
  [[:lua StartFindAndReplaceSelection()<CR>]],
  { noremap = true, silent = true, desc = "Search + replace selection" }
)

km.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

km.set("n", "<leader>fy", function()
  CopyRelativePath()
end, { desc = "Copy relative path" })

function CopyRelativePath()
  local current_dir = vim.fn.expand("%:p:h")
  vim.fn.chdir(current_dir)

  local root_dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file_path = vim.fn.expand("%:p")
  local relative_path = file_path:sub(#root_dir + 2)

  os.execute("echo '" .. relative_path .. "\\c' | pbcopy")
end

km.set("n", "<leader>fF", function()
  require("telescope.builtin").find_files({
    find_command = {
      "rg",
      "--files",
      "--hidden",
      "--no-ignore",
      "-g",
      "!{.git,node_modules,redux_devtools,tmp,vendor}",
    },
  })
end, { desc = "Find Files (cwd)" })

km.set("n", "<C-n>", function()
  require("illuminate").goto_next_reference()
end, { desc = "Go to next reference" })

km.set("n", "<C-p>", function()
  require("illuminate").goto_prev_reference()
end, { desc = "Go to previous reference" })

-- always insert at the correct indentation when inserting on a blank line
function SmartInsert()
  local line = vim.fn.getline(".")
  if string.match(line, "^%s*$") then
    vim.api.nvim_feedkeys("_ddko", "t", false)
  else
    -- Regular behavior for 'i'
    vim.api.nvim_feedkeys("i", "n", false)
  end
end

vim.api.nvim_set_keymap("n", "i", [[<Cmd>lua SmartInsert()<CR>]], { noremap = true, silent = true })

function SmartTab()
  local line = vim.fn.getline(".")
  if string.match(line, "^%s*$") then -- TODO: make this allow tabs after first tab on an otherwise all whitespace line
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "n", false)
    vim.api.nvim_feedkeys("_ddko", "t", false)
  else
    local tab = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    vim.api.nvim_feedkeys(tab, "n", false)
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", [[<Cmd>lua SmartTab()<CR>]], { noremap = true, silent = true })

-- more granular undo break points
km.set("i", "=", "=<c-g>u")
km.set("i", "<Space>", "<Space><c-g>u")
km.set("i", "<CR>", "<c-g>u<CR>")
km.set("i", ",", ",<c-g>u")
