-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local km = vim.keymap
km.set("n", "<Leader>a", "ggVG<c-$>", { desc = "Select All" })

km.set("v", "y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

-- undotree
-- km.set("n", "<leader>U", ":UndotreeToggle<cr>", { desc = "Undo Tree" })
vim.api.nvim_set_keymap("n", "<leader>U", ":Telescope undo<cr>", { desc = "Undo Tree" })
km.set("n", "U", "<C-r>", { desc = "Redo" })

km.set("n", "<leader>uh", function()
  require("telescope").extensions.notify.notify()
end, { desc = "Notification History" })

-- tmux
km.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
km.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
km.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
km.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })

km.set("n", "<leader>nc",":Neorg toggle-concealer<cr>", { desc = "neorg toggle concealer"})

-- cursor position hacks
km.set("n", "J", "mzJ`z", { desc = "Join Lines" })
km.set("n", "<C-d>", "<C-d>zz^", { desc = "Scroll Down" })
km.set("n", "<C-u>", "<C-u>zz^", { desc = "Scroll Up" })
km.set("n", "n", "nzzzv", { desc = "Next Search" })
km.set("n", "N", "Nzzzv", { desc = "Previous Search" })

--
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

-- km.set("n", "<leader>e", function()
--   require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
--   require("edgy").toggle()
-- end, { desc = "Toggle Sidebar" })

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

km.set("v", "<leader>d", [["_d]], { desc = "Delete selection" })

-- alt delete in insert mode deletes words
vim.api.nvim_set_keymap("i", "<M-BS>", "<C-W>", { noremap = true, silent = true })

-- text wrapping hacks
km.set("n", "<localleader>[", [[ciw[<c-r>"]<esc>]], { desc = "Wrap word in []" })
km.set("v", "<localleader>[", [[c[<c-r>"]<esc>]], { desc = "Wrap selection in []" })
km.set("n", "<localleader>(", [[ciw(<c-r>")<esc>]], { desc = "Wrap word in ()" })
km.set("v", "<localleader>(", [[c(<c-r>")<esc>]], { desc = "Wrap selection in ()" })
km.set("n", "<localleader>{", [[ciw{<c-r>"}<esc>]], { desc = "Wrap word in {}" })
km.set("v", "<localleader>{", [[c{<c-r>"}<esc>]], { desc = "Wrap selection in {}" })
km.set("n", "<localleader>'", [[ciw'<c-r>"'<esc>]], { desc = "Wrap word in ''" })
km.set("v", "<localleader>'", [[c'<c-r>"'<esc>]], { desc = "Wrap selection in ''" })
km.set("n", '<localleader>"', [[ciw"<c-r>""<esc>]], { desc = 'Wrap word in ""' })
km.set("v", '<localleader>"', [[c"<c-r>"<esc>]], { desc = 'Wrap selection in ""' })
km.set("n", '<localleader>`', [[ciw`<c-r>"`<esc>]], { desc = 'Wrap word in ``' })
km.set("v", '<localleader>`', [[c`<c-r>"`<esc>]], { desc = 'Wrap selection in ``' })

-- more granular undo break points
km.set("i", "=", "=<c-g>u")
km.set("i", "<Space>", "<Space><c-g>u")
km.set("i", "<CR>", "<c-g>u<CR>")
km.set("i", ",", ",<c-g>u")

-- Test file navigation
function GoToUnitTestFile()
  local current_file = vim.fn.expand("%:p")

  if string.match(current_file, "lib/.*%.rb") then
    local unit_test_file = string.gsub(current_file, "lib/(.*)%.rb", "spec/unit/%1_spec.rb")
    vim.cmd("e" .. unit_test_file)
  elseif string.match(current_file, "spec/integration/.*_spec%.rb") then
    local unit_test_file = string.gsub(current_file, "spec/integration/(.*)_spec%.rb", "spec/unit/%1_spec.rb")
    vim.cmd("e" .. unit_test_file)
  end
end

function GoToIntegrationTestFile()
  local current_file = vim.fn.expand("%:p")

  if string.match(current_file, "lib/.*%.rb") then
    local unit_test_file = string.gsub(current_file, "lib/(.*)%.rb", "spec/integration/%1_spec.rb")
    vim.cmd("e" .. unit_test_file)
  elseif string.match(current_file, "spec/unit/.*_spec%.rb") then
    local integration_test_file = string.gsub(current_file, "spec/unit/(.*)_spec%.rb", "spec/integration/%1_spec.rb")
    vim.cmd("e" .. integration_test_file)
  end
end

function GoToSourceFile()
  local current_file = vim.fn.expand("%:p")

  if string.match(current_file, "spec/unit/.*_spec%.rb") then
    local lib_file = string.gsub(current_file, "spec/unit/(.*)_spec%.rb", "lib/%1.rb")
    vim.cmd("e" .. lib_file)
  elseif string.match(current_file, "spec/integration/.*_spec%.rb") then
    local lib_file = string.gsub(current_file, "spec/integration/(.*)_spec%.rb", "lib/%1.rb")
    vim.cmd("e" .. lib_file)
  end
end

function CopyRspecContextCommand()
  local current_file = vim.fn.expand("%")
  local context_line = vim.fn.search([[^\s*context]], "bnc")

  if context_line == 0 then
    vim.notify("No context found above the current line.")
    CopyRspecDescribeCommand()
    return
  end

  local context_command = "rspec " .. current_file .. ":" .. context_line
  vim.fn.setreg("+", context_command)
  vim.notify("RSpec command copied to clipboard: " .. context_command)
end

function CopyRspecDescribeCommand()
  local current_file = vim.fn.expand("%")
  local describe_line = vim.fn.search([[^\s*describe]], "bnc")

  if describe_line == 0 then
    vim.notify("No describe found above the current line.")
    CopyRspecFileCommand()
    return
  end

  local describe_command = "rspec " .. current_file .. ":" .. describe_line
  vim.fn.setreg("+", describe_command)
  vim.notify("RSpec command copied to clipboard: " .. describe_command)
end

function CopyRspecFileCommand()
  local current_file = vim.fn.expand("%")
  if not string.match(current_file, "_spec.rb$") then
    vim.notify("Not a spec file.", "warn")
    return
  end
  local rspec_command = "rspec " .. current_file
  vim.fn.setreg("+", rspec_command)
  vim.notify("RSpec command copied to clipboard: " .. rspec_command)
end

function CopyRspecExampleCommand()
  local current_file = vim.fn.expand("%")
  local current_line = vim.fn.line(".")
  local example_command = "rspec " .. current_file .. ":" .. current_line
  vim.fn.setreg("+", example_command)
  vim.notify("RSpec command copied to clipboard: " .. example_command)
end

function SetSourceFileKeymaps()
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tu",
    [[<Cmd> lua GoToUnitTestFile()<CR>]],
    { desc = "Go to Unit Test File" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>ti",
    [[<Cmd> lua GoToIntegrationTestFile()<CR>]],
    { desc = "Go to Integration Test File" }
  )
end

function SetUnitTestFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tb", [[<Cmd> lua GoToSourceFile()<CR>]], { desc = "Go to Source File" })
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>ti",
    [[<Cmd> lua GoToIntegrationTestFile()<CR>]],
    { desc = "Go to Integration Test File" }
  )
end

function SetIntegrationTestFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tb", [[<Cmd> lua GoToSourceFile()<CR>]], { desc = "Go to Source File" })
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tu",
    [[<Cmd> lua GoToUnitTestFile()<CR>]],
    { desc = "Go to Unit Test File" }
  )
end

function SetRspecFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tyc", [[<Cmd> lua CopyRspecContextCommand()<CR>]], { desc = "Copy Rspec context command" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tyd", [[<Cmd> lua CopyRspecDescribeCommand()<CR>]], { desc = "Copy Rspec describe command" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tyf", [[<Cmd> lua CopyRspecFileCommand()<CR>]], { desc = "Copy Rspec file command" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tye", [[<Cmd> lua CopyRspecExampleCommand()<CR>]], { desc = "Copy Rspec example command" })
end

vim.cmd([[
  augroup TestNavigationKeymaps
    autocmd!
    autocmd BufRead,BufNewFile */lib/**/*.rb :lua SetSourceFileKeymaps()
    autocmd BufRead,BufNewFile */spec/unit/**/*.rb :lua SetUnitTestFileKeymaps()
    autocmd BufRead,BufNewFile */spec/integration/**/*.rb :lua SetIntegrationTestFileKeymaps()
    autocmd BufRead,BufNewFile */spec/**/*_spec.rb :lua SetRspecFileKeymaps()
  augroup END
]])

-- "Multiple Cursors"
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-- https://github.com/akinsho/dotfiles/blob/45c4c17084d0aa572e52cc177ac5b9d6db1585ae/.config/nvim/plugin/mappings.lua#L298
--
-- -- Functions for multiple cursors
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]], true, true, true)

function SetupMultipleCursors()
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<Enter>",
    [[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]],
    { silent = true }
  )
end

-- 1. Position the cursor anywhere in the word you wish to change;
-- 2. Or, visually make a selection;
-- 3. Hit cn, type the new word, then go back to Normal mode;
-- 4. Hit `.` n-1 times, where n is the number of replacements.

km.set("n", "cn", "*``cgn", { desc = "Initiate multiple cursors" })
km.set(
  "v",
  "cn",
  [[g:mc . "``cgn"]],
  { desc = "Initiate multiple cursors", expr = true, noremap = true, silent = true }
)
km.set("n", "cN", "*``cgN", { desc = "Initiate multiple cursors (in backwards direction)" })
km.set(
  "v",
  "cN",
  [[g:mc . "``cgN"]],
  { desc = "Initiate multiple cursors (in backwards direction)", expr = true, noremap = true, silent = true }
)

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.

km.set("n", "cq", [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>*``qz]], { desc = "Initiate multiple cursor macro" })
km.set(
  "v",
  "cq",
  [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . g:mc . "``qz"]],
  { desc = "Initiate multiple cursor macro", expr = true, noremap = true, silent = true }
)
km.set(
  "n",
  "cQ",
  [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>#``qz]],
  { desc = "Initiate multiple cursor macro (backwards)" }
)
km.set(
  "v",
  "cQ",
  [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
  { desc = "Initiate multiple cursor macro (backwards)", expr = true, noremap = true, silent = true }
)

km.set("n", "<leader>cR", "<Cmd>LspRestart<CR>", { desc = "Restart LSP" })
km.set("n", "<leader>cL", "<Cmd>LspLog<CR>", { desc = "Open LSP Logs" })
-- km.set("n", "<leader>ub", function()
--   require("dropbar.api").pick()
-- end, { desc = "Dropbar" })

local Util = require("lazyvim.util")

function isValidFilePath(path)
  -- Check for characters not allowed in a file path
  if path:match('[<>:"|?*]') then
    return false
  end

  -- Check for the presence of at least one '/' or one '.'
  if not (path:match("[/]") or path:match("[.]")) then
    return false
  end

  -- Check for an absolute path (starting with a slash) or a relative path (not containing any illegal characters)
  if path:match("^/") or path:match("^[a-zA-Z0-9_/\\%.%-%s]+$") then
    return true
  end

  return false
end

function LazygitEdit(original_buffer)
  -- git current terminal channel
  local bufnr = vim.fn.bufnr("%")
  local channel_id = vim.fn.getbufvar(bufnr, "terminal_job_id")

  if channel_id == nil then
    print("No terminal job ID found.")
    return
  end

  -- Use <c-o> to copy the relative file path to the system clipboard in Lazygit
  vim.fn.chansend(channel_id, "\15") -- \15 is <c-o>
  -- Give some time for the copy operation to complete
  vim.cmd("sleep 200m")

  if not isValidFilePath(vim.fn.getreg("+")) then
    print("Invalid file path copied to clipboard")
    return
  end

  -- Close Lazygit
  vim.cmd("close")

  -- Get the copied relative file path from the system clipboard
  local rel_filepath = vim.fn.getreg("+")

  -- Combine with the current working directory to get the full path
  local cwd = Util.root.get()
  local abs_filepath = cwd .. "/" .. rel_filepath

  print("Opening " .. abs_filepath)

  -- focus on the original window
  local winid = vim.fn.bufwinid(original_buffer)
  if winid ~= -1 then
    vim.fn.win_gotoid(winid)
  else
    print("Could not find the original window")
    return
  end

  -- Open the file in a new buffer
  vim.cmd("e " .. abs_filepath)
end

-- Start Lazygit with custom keymaps
function StartLazygit()
  local current_buffer = vim.api.nvim_get_current_buf()
  local float_term = Util.terminal.open({ "lazygit" }, { cwd = Util.root.get(), esc_esc = false, ctrl_hjkl = false })
  local created_buffer = float_term.buf
  -- set the custom keymap for "<c-e>" within it
  vim.api.nvim_buf_set_keymap(
    created_buffer,
    "t",
    "<c-e>",
    string.format([[<Cmd>lua LazygitEdit(%d)<CR>]], current_buffer),
    { noremap = true, silent = true }
  )
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>gg",
  [[<Cmd>lua StartLazygit()<CR>]],
  { noremap = true, silent = true, desc = "Lazygit (root dir)" }
)

