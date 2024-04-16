-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local km = vim.keymap
km.set("i", "hh", "<ESC>", { desc = "Exit insert mode" })
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
end, { desc = "Flash Treesitter"})

-- tmux
km.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
km.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
km.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
km.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })

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
-- km.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection" }) -- Use s instead

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

local function get_ruby_gems_directory()
  local command = "gem env gemdir"
  local handle = io.popen(command, "r") -- Run the command and open for reading
  if handle == nil then
    vim.notify("Failed to run command: " .. command)
    return nil
  end
  local gem_dir = handle:read("*a") -- Read the entire output
  handle:close()

  -- Trim any trailing whitespace or new lines
  gem_dir = string.gsub(gem_dir, "^%s*(.-)%s*$", "%1")

  if gem_dir == "" then
    vim.notify("No gems directory found.")
    return nil
  end

  return gem_dir .. "/gems"
end

km.set("n", "<leader>fG", function()
  local gem_dir = get_ruby_gems_directory()
  if gem_dir == nil then
    return nil
  end
  require("telescope.builtin").find_files({ cwd = gem_dir })
end, { desc = "Find Ruby Gem File" })



-- word motions that ignore underscores with Alt held down
function CurrentCharIsUnderscore()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col + 1, col + 1)
  return char == "_"
end
function CommandIgnoringUnderscores(cmd)
  local old_iskeyword = vim.opt.iskeyword:get()
  vim.opt.iskeyword:remove("_")
  vim.cmd(cmd)
  if CurrentCharIsUnderscore() then
    vim.cmd(cmd)
  end
  vim.opt.iskeyword = old_iskeyword
end
km.set("n", "<M-w>", ':lua CommandIgnoringUnderscores("normal! w")<CR>', {
  noremap = true,
  silent = true,
  desc = "Next word (ignoring underscores)"
})
km.set("n", "<M-b>", ':lua CommandIgnoringUnderscores("normal! b")<CR>', {
  noremap = true,
  silent = true,
  desc = "Previous word (ignoring underscores)"
})
km.set("n", "<M-e>", ':lua CommandIgnoringUnderscores("normal! e")<CR>', {
  noremap = true,
  silent = true,
  desc = "End of next word (ignoring underscores)"
})
km.set("n", "g<M-e>", ':lua CommandIgnoringUnderscores("normal! ge")<CR>', {
  noremap = true,
  silent = true,
  desc = "End of previous word (ignoring underscores)"
})

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

function RunRubocopOnSelection()
  -- Capture the current visual selection
  local old_reg = vim.fn.getreg('') -- Save the current register
  vim.cmd('normal! "xy') -- Yank the visual selection into register x

  -- Write the yanked text to a temporary file
  local temp_file = "/tmp/nvim_rubocop_format_temp.rb"
  local f = io.open(temp_file, "w")
  f:write(vim.fn.getreg('x')) -- Write the content of register x
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
  vim.cmd("normal! gv\"_d`<kma")
  -- vim.api.nvim_exec("'<,'>delete _", false) -- Delete the selection, avoiding the clipboard
  vim.api.nvim_put(lines, 'l', true, true) -- 'l' to insert linewise

  -- Auto-indent the inserted lines
  -- Adjusting to use the calculated range based on actual content inserted
  -- vim.cmd(insert_start_line .. "," .. insert_end_line .. "normal! =")
  -- Move to mark 'a', then visually select to the end of the inserted content and indent
  vim.cmd("normal! `aV`]=j^")

  -- Restore the previous register
  vim.fn.setreg('', old_reg)

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
km.set("n", "<localleader>`", [[ciw`<c-r>"`<esc>]], { desc = "Wrap word in ``" })
km.set("v", "<localleader>`", [[c`<c-r>"`<esc>]], { desc = "Wrap selection in ``" })

-- more granular undo break points
km.set("i", "=", "=<c-g>u")
km.set("i", "<Space>", "<Space><c-g>u")
km.set("i", "<CR>", "<c-g>u<CR>")
km.set("i", ",", ",<c-g>u")

km.set("n", "<leader>e", function()
    local current_file = vim.fn.expand("%:p")
    -- vim.notify("current_file" .. current_file)
    require("neo-tree.command").execute({
      toggle = true,
      source = "filesystem",
      dir = require("lazyvim.util").root(),
      reveal = current_file,
    })
  end,
  { desc = "Explorer NeoTree (Root Dir)" }
)

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

function OpenOrCreatePR()
  -- Get the current branch name
  local handle = io.popen("git branch --show-current")
  local branch = handle:read("*a"):gsub("%s+", "")
  handle:close()

  if branch == "" then
    print("No active Git branch found.")
    return
  end

  -- Check if a PR already exists for the current branch (simplified approach)
  handle = io.popen("gh pr list --search 'head:" .. branch .. " ' -L 1")
  local prExists = handle:read("*a") ~= ""
  handle:close()

  if prExists then
    -- Navigate to the existing PR in the browser
    os.execute("gh pr view --web")
  else
    -- Open GitHub PR creation page for this branch in the browser
    os.execute("gh pr create --web")
  end
end

-- Setting the keymap in Neovim
vim.api.nvim_set_keymap('n', '<space>gp', '<cmd>lua OpenOrCreatePR()<CR>', {noremap = true, silent = true, desc = "Open or create PR in browser" })

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
