-- helpers
local set = vim.keymap.set
local nset = function(...) set("n", ...) end
local vset = function(...) set("v", ...) end
local iset = function(...) set("i", ...) end
local tset = function(...) set("t", ...) end

-- save with alt-s
set({ "i", "x", "n", "s" }, "<A-s>", "<cmd>w<cr><esc>", { desc = "Save File", silent = true })
-- ignore ctrl-s (tmux prefix)
set({ "i", "x", "n", "s" }, "<C-s>", "<NOP>", { desc = "which_key_ignore" })

-- quit
nset("<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
-- select all
nset("<Leader>va", "ggVG<c-$>", { desc = "Select All" })

-- lazy
nset("<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- lsp
nset("<leader>cR", "<Cmd>LspRestart<CR>", { desc = "Restart LSP" })
nset("<leader>cL", "<Cmd>LspLog<CR>", { desc = "Open LSP Logs" })

-- make . work for visual mode
vset(".", ":norm.<CR>", { desc = "Repeat Normal Mode Command" })
-- clear search with <esc>
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- buffers
nset("<leader>bq", ":bufdo bd<CR>", { desc = "Close all open buffers" })
nset("<leader>bn", ":bnext<CR>", { desc = "Next Buffer", silent = true })
nset("<leader>bN", ":blast<CR>", { desc = "Last Buffer", silent = true })
nset("<leader>bp", ":bprev<CR>", { desc = "Previous Buffer", silent = true })
nset("<leader>bP", ":bfirst<CR>", { desc = "First Buffer", silent = true })
nset("<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
nset("<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- nset("[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- nset("]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
nset("<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
nset("<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- windows
nset("<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
nset("<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
nset("<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
nset("<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- tabs
nset("<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
nset("<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
nset("<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
nset("<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
nset("<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
nset("<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
nset("<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- more granular undo break points
iset("=", "=<c-g>u")
iset(",", ",<c-g>u")
iset(".", ".<c-g>u")
iset(";", ";<c-g>u")
nset("U", "<C-r>", { desc = "Redo" })

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
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
nset("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
nset("N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
-- when going to the end of the line in visual mode ignore whitespace characters
vset("$", "g_")
-- better indenting
vset("<", "<gv")
vset(">", ">gv")
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
-- delete selection to void register
vset("<leader>d", [["_d]], { desc = "Delete selection" })

-- fold shortcut
nset("<leader>z", "za", { desc = "Toggle Fold" })

-- find and replace
nset("<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search + replace under cursor" })
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
vset(
  "<leader>S",
  [[:lua StartFindAndReplaceSelection()<CR>]],
  { noremap = true, silent = true, desc = "Search + replace selection" }
)

-- messages
nset("<leader>m", [[<cmd>set nomore<bar>40messages<bar>set more<CR>]], { desc = "Show messages" })

-- Terminal Mappings
tset("<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
tset("<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
tset("<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
tset("<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
tset("<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
tset("<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
tset("<c-_>", "<cmd>close<cr>", { desc = "Toggle Terminal" })

-- new file
nset("<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- quickfix navigation
nset("<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
nset("<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
nset("[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
nset("]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- comments above and below
nset("gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
nset("gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- highlight inspection
nset("<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
nset("<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- switch back and forth between color schemes
local current_colorscheme = vim.g.colors_name
local previous_colorscheme = nil
function SwitchColorScheme()
  if previous_colorscheme then
    local temp = current_colorscheme
    current_colorscheme = previous_colorscheme
    previous_colorscheme = temp
    vim.notify("Changing color scheme to " .. current_colorscheme)
    vim.cmd("colorscheme " .. current_colorscheme)
  else
    vim.notify("No previous color scheme to switch to")
  end
end
-- Function to update colorscheme variables when a new colorscheme is set
function UpdateColorscheme()
  local new_colorscheme = vim.g.colors_name
  if new_colorscheme ~= current_colorscheme then
    previous_colorscheme = current_colorscheme
    current_colorscheme = new_colorscheme
  end
end
-- Autocommand to detect colorscheme changes
vim.cmd([[
  augroup UpdateColorscheme
    autocmd!
    autocmd ColorScheme * lua UpdateColorscheme()
  augroup END
]])
nset("<leader>uc", "<cmd>lua SwitchColorScheme()<cr>", { desc = "Last Color Scheme", noremap = true, silent = true })


-- format selections (more reliable rubocop)
function RunRubocopOnSelection()
  -- Capture the current visual selection
  local old_reg = vim.fn.getreg("") -- Save the current register
  vim.cmd('normal! "xy') -- Yank the visual selection into register x

  -- Write the yanked text to a temporary file
  local temp_file = "/tmp/nvim_rubocop_format_temp.rb"
  local f = io.open(temp_file, "w")
  f:write(vim.fn.getreg("x")) -- Write the content of register x
  f:close()

  -- Format the temporary file with RuboCop
  os.execute("rubocop -a -c ~/Blitz/.rubocop.yml " .. temp_file .. " > /dev/null 2>&1")

  -- Read the formatted content back
  f = io.open(temp_file, "r")
  local formatted_content = f:read("*all"):close()
  local lines = {}
  for line in formatted_content:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  -- Replace the current selection with the formatted content
  -- - Delete the original selection with _ to avoid changing the default register
  -- Set a mark 'a' at the start of the original selection to return to it later
  vim.cmd('normal! gv"_d`<kma')
  -- vim.api.nvim_exec("'<,'>delete _", false) -- Delete the selection, avoiding the clipboard
  vim.api.nvim_put(lines, "l", true, true) -- 'l' to insert linewise

  -- Auto-indent the inserted lines
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
    -- TODO: make this fallback to conform instead of lsp
    vim.lsp.buf.format({
      async = true,
      range = {
        ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
        ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
      },
    })
  end
end
vset("<leader>cf", FormatSelection, { desc = "Format selection" })

-- create executables
nset("<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

-- copy paths
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
      relative_path = "~" .. file_path:sub(#home_dir + 1)
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
    relative_path = "~" .. file_path:sub(#home_dir + 1)
  else
    relative_path = file_path -- Use absolute path as a fallback
  end
  os.execute("echo '" .. relative_path .. "\\c' | pbcopy")
  vim.notify("Copied path to clipboard: " .. relative_path)
end
nset("<leader>fy", CopyRelativePath, { desc = "Copy Relative Path" })
nset("<leader>fY", CopyPath, { desc = "Copy Path" })

-- illuminate
nset("<C-n>", require("illuminate").goto_next_reference, { desc = "Go to next reference" })
nset("<C-p>", require("illuminate").goto_prev_reference, { desc = "Go to previous reference" })


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
local function toggleDiagnostics()
  local enabled = nil
  if vim.diagnostic.is_enabled then
    enabled = vim.diagnostic.is_enabled()
  elseif vim.diagnostic.is_disabled then
    enabled = not vim.diagnostic.is_disabled()
  end
  enabled = not enabled

  if enabled then
    vim.diagnostic.enable()
    vim.notify("Enabled diagnostics", { title = "Diagnostics", level = vim.log.levels.INFO })
  else
    vim.diagnostic.disable()
    vim.notify("Disabled diagnostics", { title = "Diagnostics", level = vim.log.levels.WARN })
  end
end
nset("<leader>ud", toggleDiagnostics, { desc = "Toggle Diagnostics" })

-- treesitter highlights
nset("<leader>uT", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    vim.notify("Disabled Treesitter Highlights")
  else
    vim.treesitter.start()
    vim.notify("Enabled Treesitter Highlights")
  end
end, { desc = "Toggle Treesitter Highlight" })

local function toggleOption(option, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return vim.notify("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option", level = vim.log.levels.INFO })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if vim.opt_local[option]:get() then
    vim.notify("Enabled " .. option, { title = "Option", level = vim.log.levels.INFO })
  else
    vim.notify("Disabled " .. option, { title = "Option", level = vim.log.levels.WARN })
  end
end
nset("<leader>uw", function() toggleOption("wrap") end, { desc = "Toggle Word Wrap" })
nset("<leader>ub", function() toggleOption("background", { "light", "dark"}) end, { desc = "Toggle Background" })

function RemoveQuickfixItem()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local qf_list = vim.fn.getqflist()
  if #qf_list > 0 then
    table.remove(qf_list, line)
    vim.fn.setqflist(qf_list, "r")

    if #qf_list == 0 then
      vim.cmd("cclose")
    else
      vim.cmd("copen")
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
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<leader>d",
      "<cmd>lua RemoveQuickfixItem()<CR>",
      { noremap = true, silent = true, desc = "Remove Quickfix Item" }
    )
  end,
})


