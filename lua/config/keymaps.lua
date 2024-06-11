-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local km = vim.keymap
km.set({ "i", "x", "n", "s" }, "<M-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
km.set({ "i", "x", "n", "s" }, "<C-s>", "<NOP>", { desc = "which_key_ignore" })

km.set("n", "<Leader>a", "ggVG<c-$>", { desc = "Select All" })

km.set("v", "y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

km.set("n", "<leader>bq", ":bufdo bd<CR>", { desc = "Close all open buffers" })

-- undotree
km.set("n", "<leader>U", ":UndotreeToggle<CR>", { desc = "Undo Tree" })
-- vim.api.nvim_set_keymap("n", "<leader>U", ":Telescope undo<cr>", { desc = "Undo Tree" })
km.set("n", "U", "<C-r>", { desc = "Redo" })

km.set("n", "<leader>uh", function()
  require("telescope").extensions.notify.notify()
end, { desc = "Notification History" })

-- flash
km.set({ "n", "x", "o" }, "gh", function()
  require("flash").jump()
end, { desc = "Flash" })
km.set({ "n", "x", "o" }, "gH", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

-- tmux
km.set({ "n", "i", "x", "o" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
km.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
km.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
km.set({ "n", "i", "x", "o" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })

km.set("n", "<leader>nc", ":Neorg toggle-concealer<cr>", { desc = "neorg toggle concealer" })

km.set("n", "zh", "zH", { desc = "Half screen to the left" })

-- cursor position hacks
km.set("n", "J", "mzJ`z", { desc = "Join Lines" })
km.set("n", "<C-d>", "<C-d>zz^", { desc = "Scroll Down" })
km.set("n", "<C-u>", "<C-u>zz^", { desc = "Scroll Up" })
km.set("n", "n", "nzzzv", { desc = "Next Search" })
km.set("n", "N", "Nzzzv", { desc = "Previous Search" })

--
-- greatest remap ever
km.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection" }) -- Use s instead

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

function RunRubocopOnSelection()
  -- Capture the current visual selection
  local old_reg = vim.fn.getreg("") -- Save the current register
  vim.cmd('normal! "xy')            -- Yank the visual selection into register x

  -- Write the yanked text to a temporary file
  local temp_file = "/tmp/nvim_rubocop_format_temp.rb"
  local f = io.open(temp_file, "w")
  f:write(vim.fn.getreg("x")) -- Write the content of register x
  f:close()

  -- Format the temporary file with RuboCop
  os.execute("rubocop -a -c ~/Blitz/.rubocop.yml " .. temp_file .. " > /dev/null 2>&1")

  -- Read the formatted content back
  f = io.open(temp_file, "r")
  local formatted_content = f:read("*all")
  f:close()
  local lines = {}
  for line in formatted_content:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  local insert_start_line = vim.fn.line("'<")
  local insert_end_line = insert_start_line + #lines - 1

  -- Replace the current selection with the formatted content
  -- - Delete the original selection with _ to avoid changing the default register
  -- Set a mark 'a' at the start of the original selection to return to it later
  vim.cmd('normal! gv"_d`<kma')
  -- vim.api.nvim_exec("'<,'>delete _", false) -- Delete the selection, avoiding the clipboard
  vim.api.nvim_put(lines, "l", true, true) -- 'l' to insert linewise

  -- Auto-indent the inserted lines
  -- Adjusting to use the calculated range based on actual content inserted
  -- vim.cmd(insert_start_line .. "," .. insert_end_line .. "normal! =")
  -- Move to mark 'a', then visually select to the end of the inserted content and indent
  vim.cmd("normal! `aV`]=j^")

  -- Restore the previous register
  vim.fn.setreg("", old_reg)

  -- Clean up: Remove the temporary file
  -- os.remove(temp_file)
end

function FormatSelection()
  local current_file = vim.fn.expand("%")
  if string.match(current_file, "%.rb$") then
    RunRubocopOnSelection()
  else
    vim.lsp.buf.format({
      async = true,
      range = {
        ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
        ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
      },
    })
  end
end

km.set("v", "<leader>cf", function() FormatSelection() end, { desc = "Format selection" })

km.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

km.set("n", "<leader>fy", function() CopyRelativePath() end, { desc = "Copy Relative Path" })
km.set("n", "<leader>fY", function() CopyPath() end, { desc = "Copy Path" })


function CopyRelativePath()
  local current_dir = vim.fn.expand("%:p:h")
  vim.fn.chdir(current_dir)

  -- Attempt to get the git root directory
  local root_dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file_path = vim.fn.expand("%:p")
  local relative_path

  if vim.v.shell_error == 0 then
    -- If inside a git repository
    relative_path = file_path:sub(#root_dir + 2)
  else
    -- If not inside a git repository, make path relative to home directory
    local home_dir = os.getenv("HOME")
    if file_path:find(home_dir) == 1 then
      relative_path = '~' .. file_path:sub(#home_dir + 1)
    else
      relative_path = file_path -- Use absolute path as a fallback
    end
  end

  os.execute("echo '" .. relative_path .. "\\c' | pbcopy")
  vim.notify("Copied relative path to clipboard: " .. relative_path)
end

function CopyPath()
  local current_dir = vim.fn.expand("%:p:h")
  vim.fn.chdir(current_dir)

  local file_path = vim.fn.expand("%:p")
  local relative_path

  local home_dir = os.getenv("HOME")
  if file_path:find(home_dir) == 1 then
    relative_path = '~' .. file_path:sub(#home_dir + 1)
  else
    relative_path = file_path -- Use absolute path as a fallback
  end
  os.execute("echo '" .. relative_path .. "\\c' | pbcopy")
  vim.notify("Copied path to clipboard: " .. relative_path)
end

km.set("n", "<C-n>", function()
  require("illuminate").goto_next_reference()
end, { desc = "Go to next reference" })

km.set("n", "<C-p>", function()
  require("illuminate").goto_prev_reference()
end, { desc = "Go to previous reference" })

km.set("v", "<leader>d", [["_d]], { desc = "Delete selection" })

-- alt delete in insert mode deletes words
vim.api.nvim_set_keymap("i", "<M-BS>", "<C-W>", { noremap = true, silent = true })


-- more granular undo break points
km.set("i", "=", "=<c-g>u")
km.set("i", "<Space>", "<Space><c-g>u")
km.set("i", "<CR>", "<c-g>u<CR>")
km.set("i", ",", ",<c-g>u")

-- Test file navigation
function GoToUnitTestFile()
  local current_file = vim.fn.expand("%:p")
  local unit_test_file = nil

  if string.match(current_file, "lib/.*%.rb") then
    unit_test_file = string.gsub(current_file, "lib/(.*)%.rb", "spec/unit/%1_spec.rb")
  elseif string.match(current_file, "app/.*%.rb") then
    unit_test_file = string.gsub(current_file, "app/(.*)%.rb", "spec/unit/%1_spec.rb")
  elseif string.match(current_file, "spec/integration/.*_spec%.rb") then
    unit_test_file = string.gsub(current_file, "spec/integration/(.*)_spec%.rb", "spec/unit/%1_spec.rb")
  end
  if io.open(unit_test_file, "r") == nil then
    vim.notify("No unit test file found, opening new buffer at path")
  end
  vim.cmd("e" .. unit_test_file)
end

function GoToIntegrationTestFile()
  local current_file = vim.fn.expand("%:p")
  local integration_test_file = nil
  if string.match(current_file, "lib/.*%.rb") then
    integration_test_file = string.gsub(current_file, "lib/(.*)%.rb", "spec/integration/%1_spec.rb")
  elseif string.match(current_file, "app/.*%.rb") then
    integration_test_file = string.gsub(current_file, "app/(.*)%.rb", "spec/integration/%1_spec.rb")
  elseif string.match(current_file, "spec/unit/.*_spec%.rb") then
    integration_test_file = string.gsub(current_file, "spec/unit/(.*)_spec%.rb", "spec/integration/%1_spec.rb")
  end
  if io.open(integration_test_file, "r") == nil then
    vim.notify("No integration test file found, opening new buffer at path")
  end
  vim.cmd("e" .. integration_test_file)
end

function GoToSourceFile()
  local current_file = vim.fn.expand("%:p")
  local lib_file = nil
  if string.match(current_file, "spec/unit/.*_spec%.rb") then
    lib_file = string.gsub(current_file, "spec/unit/(.*)_spec%.rb", "lib/%1.rb")
  elseif string.match(current_file, "spec/integration/.*_spec%.rb") then
    lib_file = string.gsub(current_file, "spec/integration/(.*)_spec%.rb", "lib/%1.rb")
  else
    vim.notify("Not a unit or integration test file", "error")
    return
  end

  if io.open(lib_file, "r") then
    vim.cmd("e" .. lib_file)
  elseif io.open(string.gsub(lib_file, "lib/", "app/"), "r") then
    vim.cmd("e" .. string.gsub(lib_file, "lib/", "app/"))
  else
    vim.notify("No source file found.", "error")
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

  local describe_command = "rspec " .. current_file .. ":" .. describe_line .. " --fail-fast"
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
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tyc",
    [[<Cmd> lua CopyRspecContextCommand()<CR>]],
    { desc = "Copy Rspec context command" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tyd",
    [[<Cmd> lua CopyRspecDescribeCommand()<CR>]],
    { desc = "Copy Rspec describe command" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tyf",
    [[<Cmd> lua CopyRspecFileCommand()<CR>]],
    { desc = "Copy Rspec file command" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tye",
    [[<Cmd> lua CopyRspecExampleCommand()<CR>]],
    { desc = "Copy Rspec example command" }
  )
end

vim.cmd([[
  augroup TestNavigationKeymaps
    autocmd!
    autocmd BufRead,BufNewFile */lib/**/*.rb :lua SetSourceFileKeymaps()
    autocmd BufRead,BufNewFile */app/**/*.rb :lua SetSourceFileKeymaps()
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

local Util = LazyVim

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

function RemoveQuickfixItem()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local qf_list = vim.fn.getqflist()
  if #qf_list > 0 then
    table.remove(qf_list, line)
    vim.fn.setqflist(qf_list, 'r')

    if #qf_list == 0 then
      vim.cmd('cclose')
    else
      vim.cmd('copen')
      if line > #qf_list then
        vim.api.nvim_win_set_cursor(0, { #qf_list, 0 }) -- Move cursor to the last item if removed item was the last
      else
        vim.api.nvim_win_set_cursor(0, { line, 0 })
      end
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>d', '<cmd>lua RemoveQuickfixItem()<CR>',
      { noremap = true, silent = true, desc = "Remove Quickfix Item" })
  end
})

-- vim.api.nvim_create_autocmd({"FileType", "ColorScheme"}, {
--   pattern = "qf",
--   callback = function()
--     vim.defer_fn(function()
--       vim.cmd("highlight CursorLine guibg=#1b2817") -- Change the color code as needed
--       vim.cmd("setlocal cursorline")
--     end, 100)
--   end
-- })

-- Global timer variable
_G.last_key_time = 0

-- Function to handle magic key behavior for "/"
_G.magic_key = function()
  local current_time = vim.fn.reltimefloat(vim.fn.reltime())
  local time_diff = current_time - _G.last_key_time

  -- Check if the time difference is within the desired threshold (e.g., 500 ms)
  if time_diff > 0.5 then
    -- Reset last_key_time
    _G.last_key_time = current_time
    return "/" -- Default behavior if time threshold is exceeded
  end

  -- Get the character before the cursor
  local col = vim.fn.col('.') - 1
  if col <= 0 then return end

  local prev_char = vim.fn.getline('.'):sub(col, col)
  local output = ""

  -- Define your magic key behavior
  if prev_char == "k" then
    output = "e"
  elseif prev_char == "a" then
    output = "nd"
  else
    output = "/" -- Default behavior if no condition matches
  end

  -- Update last_key_time
  _G.last_key_time = current_time

  -- Return the output to be inserted
  return output
end

-- Set up the mapping in insert mode
vim.api.nvim_set_keymap('i', '/', 'v:lua.magic_key()', { noremap = true, expr = true, silent = true })

-- Update last_key_time on each keypress
vim.cmd([[
  augroup UpdateKeyPressTime
    autocmd!
    autocmd InsertCharPre * lua _G.last_key_time = vim.fn.reltimefloat(vim.fn.reltime())
  augroup END
]])
