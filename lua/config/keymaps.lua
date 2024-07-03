-- helpers
local set = vim.keymap.set
local nset = function(...) set("n", ...) end
local vset = function(...) set("v", ...) end
local iset = function(...) set("i", ...) end
local tset = function(...) set("t", ...) end
local set4 = function(...) set({"n", "i", "x", "o" }, ...) end

-- save with alt-s
set({ "i", "x", "n", "s" }, "<A-s>", "<cmd>w<cr><esc>", { desc = "Save File", silent = true })
-- ignore ctrl-s (tmux prefix)
set({ "i", "x", "n", "s" }, "<C-s>", "<NOP>", { desc = "which_key_ignore" })

-- quit
nset("<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
-- select all
nset("<Leader>a", "ggVG<c-$>", { desc = "Select All" })

-- vset("y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

-- better indenting
vset("<", "<gv")
vset(">", ">gv")
-- make . work for visual mode
vset('.', ':norm.<CR>', { desc = "Repeat Normal Mode Command"})
-- when going to the end of the line in visual mode ignore whitespace characters
vset('$', 'g_')
-- clear search with <esc>
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua (via lazyvim)
-- set( "n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })

-- buffers
nset("<leader>bq", ":bufdo bd<CR>", { desc = "Close all open buffers" })
nset("<leader>bn", ":bnext<CR>", { desc = "Next Buffer", silent = true })
nset("<leader>bN", ":blast<CR>", { desc = "Last Buffer", silent = true })
nset("<leader>bp", ":bprev<CR>", { desc = "Previous Buffer", silent = true })
nset("<leader>bP", ":bfirst<CR>", { desc = "First Buffer", silent = true })
nset("<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
nset("<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
nset("[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
nset("]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
nset("<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
nset("<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- nset("<leader>bd", LazyVim.ui.bufremove, { desc = "Delete Buffer" })
nset("<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
-- windows
nset("<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
nset("<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
nset("<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
nset("<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
nset("<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
nset("<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- nset("<leader>wm", function() LazyVim.toggle.maximize() end, { desc = "Maximize Toggle" })

-- tabs
nset("<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
nset("<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
nset("<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
nset("<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
nset("<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
nset("<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
nset("<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- undotree
nset("<leader>U", ":UndotreeToggle<CR>", { desc = "Undo Tree" })
-- nset("<leader>U", ":Telescope undo<cr>", { desc = "Undo Tree" })
nset("U", "<C-r>", { desc = "Redo" })

nset("<leader>uh", function() require("telescope").extensions.notify.notify() end, { desc = "Notification History" })

-- flash
set({ "n", "x", "o" }, "gh", function() require("flash").jump() end, { desc = "Flash" })
set({ "n", "x", "o" }, "gH", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- tmux
set4("<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left", silent = true })
nset("<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down", silent = true })
nset("<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up", silent = true })
set4("<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right", silent = true })

-- nset("<leader>nc", ":Neorg toggle-concealer<cr>", { desc = "neorg toggle concealer" })

-- viewport moves
nset("zh", "zH", { desc = "Half screen to the left" })
nset("zl", "zL", { desc = "Half screen to the right" })
-- Resize window using <ctrl> arrow keys
nset("<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
nset("<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
nset("<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
nset("<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- cursor position hacks
nset("J", "mzJ`z", { desc = "Join Lines" })
nset("<C-d>", "<C-d>zz^", { desc = "Scroll Down" })
nset("<C-u>", "<C-u>zz^", { desc = "Scroll Up" })
-- nset("n", "nzzzv", { desc = "Next Search" })
-- nset("N", "Nzzzv", { desc = "Previous Search" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
nset("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
nset("N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
set({"x", "o"}, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set({"x", "o"}, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- better up/down
set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
-- Move Lines
nset("<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
nset("<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
iset("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
iset("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vset("<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
vset("<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

nset("<leader>z", "za", { desc = "Toggle Fold" })

nset("<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search + replace under cursor" })

nset("<leader>m", [[<cmd>set nomore<bar>40messages<bar>set more<CR>]], { desc = "Show messages" })


-- lazy
nset("<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
-- nset("<leader>L", function() LazyVim.news.changelog() end, { desc = "LazyVim Changelog" })

-- floating terminal
-- local lazyterm = function() LazyVim.terminal(nil, { cwd = LazyVim.root() }) end
-- nset("<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
-- nset("<leader>fT", function() LazyVim.terminal() end, { desc = "Terminal (cwd)" })
-- nset("<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
-- nset("<c-_>", lazyterm, { desc = "which_key_ignore" })
-- Terminal Mappings
tset("<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
tset("<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
tset("<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
tset("<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
tset("<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
tset("<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
tset("<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- new file
nset("<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

nset("<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
nset("<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

nset("[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
nset("]q", vim.cmd.cnext, { desc = "Next Quickfix" })
-- commenting
nset("gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
nset("gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- highlights under cursor
nset("<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
nset("<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

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


vim.api.nvim_set_keymap( "v", "<leader>S", [[:lua StartFindAndReplaceSelection()<CR>]], { noremap = true, silent = true, desc = "Search + replace selection" })

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

vset("<leader>cf", function() FormatSelection() end, { desc = "Format selection" })

-- formatting
-- set({ "n", "v" }, "<leader>cf", function()
--   LazyVim.format({ force = true })
-- end, { desc = "Format" })

nset("<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

nset("<leader>fy", function() CopyRelativePath() end, { desc = "Copy Relative Path" })
nset("<leader>fY", function() CopyPath() end, { desc = "Copy Path" })


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

-- illuminate
nset("<C-n>", function() require("illuminate").goto_next_reference() end, { desc = "Go to next reference" })
nset("<C-p>", function() require("illuminate").goto_prev_reference() end, { desc = "Go to previous reference" })

vset("<leader>d", [["_d]], { desc = "Delete selection" })

-- alt delete in insert mode deletes words
iset("<M-BS>", "<C-W>", { noremap = true, silent = true })


-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
nset("<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
nset("]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
nset("[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
nset("]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
nset("[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
nset("]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
nset("[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- more granular undo break points
iset("=", "=<c-g>u")
-- iset("<Space>", "<Space><c-g>u")
-- iset("<CR>", "<c-g>u<CR>")
iset(",", ",<c-g>u")
iset(".", ".<c-g>u")
iset(";", ";<c-g>u")

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
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tu", [[<Cmd> lua GoToUnitTestFile()<CR>]], { desc = "Go to Unit Test File" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>ti", [[<Cmd> lua GoToIntegrationTestFile()<CR>]], { desc = "Go to Integration Test File" })
end

function SetUnitTestFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tb", [[<Cmd> lua GoToSourceFile()<CR>]], { desc = "Go to Source File" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>ti", [[<Cmd> lua GoToIntegrationTestFile()<CR>]], { desc = "Go to Integration Test File" })
end

function SetIntegrationTestFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tb", [[<Cmd> lua GoToSourceFile()<CR>]], { desc = "Go to Source File" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tu", [[<Cmd> lua GoToUnitTestFile()<CR>]], { desc = "Go to Unit Test File" })
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
    autocmd BufRead,BufNewFile */app/**/*.rb :lua SetSourceFileKeymaps()
    autocmd BufRead,BufNewFile */spec/unit/**/*.rb :lua SetUnitTestFileKeymaps()
    autocmd BufRead,BufNewFile */spec/integration/**/*.rb :lua SetIntegrationTestFileKeymaps()
    autocmd BufRead,BufNewFile */spec/**/*_spec.rb :lua SetRspecFileKeymaps()
  augroup END
]])

nset(
  "<leader>uT",
  function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end,
  { desc = "Toggle Treesitter Highlight" }
)

-- nset(
--   "<leader>ub",
--   function() LazyVim.toggle("background", false, {"light", "dark"}) end,
--   { desc = "Toggle Background" }
-- )

-- "Multiple Cursors"
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-- https://github.com/akinsho/dotfiles/blob/45c4c17084d0aa572e52cc177ac5b9d6db1585ae/.config/nvim/plugin/mappings.lua#L298
--
-- -- Functions for multiple cursors
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]], true, true, true)

function SetupMultipleCursors()
  vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", [[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]], { silent = true })
end

-- 1. Position the cursor anywhere in the word you wish to change;
-- 2. Or, visually make a selection;
-- 3. Hit cn, type the new word, then go back to Normal mode;
-- 4. Hit `.` n-1 times, where n is the number of replacements.

nset("cn", "*``cgn", { desc = "Initiate multiple cursors" })
vset("cn", [[g:mc . "``cgn"]], { desc = "Initiate multiple cursors", expr = true, noremap = true, silent = true })
nset("cN", "*``cgN", { desc = "Initiate multiple cursors (in backwards direction)" })
vset("cN", [[g:mc . "``cgN"]], { desc = "Initiate multiple cursors (in backwards direction)", expr = true, noremap = true, silent = true })

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.

nset("cq", [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>*``qz]], { desc = "Initiate multiple cursor macro" })
vset("cq", [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . g:mc . "``qz"]], { desc = "Initiate multiple cursor macro", expr = true, noremap = true, silent = true })
nset("cQ", [[:\<C-u>call v:lua.SetupMultipleCursors()<CR>#``qz]], { desc = "Initiate multiple cursor macro (backwards)" })
vset("cQ", [[":\<C-u>call v:lua.SetupMultipleCursors()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]], { desc = "Initiate multiple cursor macro (backwards)", expr = true, noremap = true, silent = true })

nset("<leader>cR", "<Cmd>LspRestart<CR>", { desc = "Restart LSP" })
nset("<leader>cL", "<Cmd>LspLog<CR>", { desc = "Open LSP Logs" })
-- nset("<leader>ub", function()
--   require("dropbar.api").pick()
-- end, { desc = "Dropbar" })


-- nset("<leader>uw", function() LazyVim.toggle("wrap") end, { desc = "Toggle Word Wrap" })
-- nset("<leader>uL", function() LazyVim.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
-- nset("<leader>ul", function() LazyVim.toggle.number() end, { desc = "Toggle Line Numbers" })
-- nset("<leader>ud", function() LazyVim.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })


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
  local cwd = vim.fn.getcwd()
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

_G.lazygit_target_buffer = nil
-- Start Lazygit with custom keymaps
function StartLazygit()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = { border = "single"},
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<c-e>", string.format([[<cmd>lua LazygitEdit(%d)<CR>]], _G.lazygit_target_buffer), { noremap = true, silent = true})
    end
  })
  local _lazygit_toggle = function()
    lazygit:toggle()
  end
  local current_buffer = vim.api.nvim_get_current_buf()
  _G.lazygit_target_buffer = current_buffer
  _lazygit_toggle()
end

nset("<leader>gg", [[<Cmd>lua StartLazygit()<CR>]], { noremap = true, silent = true, desc = "Lazygit (root dir)" })

-- nset("<leader>gb", LazyVim.lazygit.blame_line, { desc = "Git Blame Line" })
-- nset("<leader>gB", LazyVim.lazygit.browse, { desc = "Git Browse" })
-- nset("<leader>gf", function()
--   local git_path = vim.api.nvim_buf_get_name(0)
--   LazyVim.lazygit({args = { "-f", vim.trim(git_path) }})
-- end, { desc = "Lazygit Current File History" })
--
-- nset("<leader>gl", function()
--   LazyVim.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
-- end, { desc = "Lazygit Log" })
-- nset("<leader>gL", function()
--   LazyVim.lazygit({ args = { "log" } })
-- end, { desc = "Lazygit Log (cwd)" })


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
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>d', '<cmd>lua RemoveQuickfixItem()<CR>', { noremap = true, silent = true, desc = "Remove Quickfix Item" })
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
iset('/', 'v:lua.magic_key()', { noremap = true, expr = true, silent = true })

-- Update last_key_time on each keypress
vim.cmd([[
  augroup UpdateKeyPressTime
    autocmd!
    autocmd InsertCharPre * lua _G.last_key_time = vim.fn.reltimefloat(vim.fn.reltime())
  augroup END
]])
