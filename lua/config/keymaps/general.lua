local set = vim.keymap.set
local nset = function(...)
  set("n", ...)
end
local vset = function(...)
  set("v", ...)
end
local iset = function(...)
  set("i", ...)
end
local tset = function(...)
  set("t", ...)
end
local utils = require("config.utils")

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
-- remap using norm! in insert mode
function _G.wrapped_line_movement(mapping)
  vim.api.nvim_command("norm! " .. mapping)
end
iset("<Down>", '<cmd> lua wrapped_line_movement("gj")<cr>', { desc = "Down", noremap = true, silent = true })
iset("<Up>", '<cmd> lua wrapped_line_movement("gk")<cr>', { desc = "Up", noremap = true, silent = true })
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
function start_find_and_replace_selection()
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
  [[:lua start_find_and_replace_selection()<CR>]],
  { noremap = true, silent = true, desc = "Search + replace selection" }
)

-- messages
nset("<leader>xm", [[<cmd>set nomore<bar>40messages<bar>set more<CR>]], { desc = "Show messages" })

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

-- comments above and below
nset("gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
nset("gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- highlight inspection
nset("<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
nset("<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- create executables
nset("<leader>fx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

-- copy paths
function copy_relative_path()
  local path = utils.relative_path()
  os.execute("echo '" .. path .. "\\c' | pbcopy")
  vim.notify("Copied relative path to clipboard: " .. path)
end
function copy_path()
  local path = utils.path()
  os.execute("echo '" .. path .. "\\c' | pbcopy")
  vim.notify("Copied path to clipboard: " .. path)
end
nset("<leader>fy", copy_relative_path, { desc = "Copy Relative Path" })
nset("<leader>fY", copy_path, { desc = "Copy Path" })

-- Keymap to toggle case
local function toggle_case()
  local word = vim.fn.expand("<cword>")
  local new_word
  -- set mark to return to
  vim.cmd("normal mx")
  if word:match("_") then
    -- Convert snake_case to CamelCase
    new_word = word:gsub("_(%a)", function(c)
      return c:upper()
    end)
    new_word = new_word:gsub("^%l", string.upper)
  else
    -- Convert CamelCase to snake_case
    new_word = word:gsub("%u", function(c)
      return "_" .. c:lower()
    end)
    new_word = new_word:gsub("^_", "")
  end
  -- Perform substitution for the whole buffer
  local cmd = string.format("%%s/\\<%s\\>/%s/g", word, new_word)
  vim.cmd(cmd)
  -- jump back to beginning of the original word
  vim.cmd("normal `x")
end
nset("<A-~>", toggle_case, { noremap = true, silent = true, desc = "Toggle snake_case/CamelCase" })

-- illuminate
nset("<C-n>", require("illuminate").goto_next_reference, { desc = "Go to next reference" })
nset("<C-p>", require("illuminate").goto_prev_reference, { desc = "Go to previous reference" })

-- alt delete in insert mode deletes words
iset("<M-BS>", "<C-W>", { noremap = true, silent = true })

-- diagnostic
nset("<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
nset("]d", utils.next_diagnostic(), { desc = "Next Diagnostic" })
nset("[d", utils.prev_diagnostic(), { desc = "Prev Diagnostic" })
nset("]e", utils.next_diagnostic("ERROR"), { desc = "Next Error" })
nset("[e", utils.prev_diagnostic("ERROR"), { desc = "Prev Error" })
nset("]w", utils.next_diagnostic("WARN"), { desc = "Next Warning" })
nset("[w", utils.prev_diagnostic("WARN"), { desc = "Prev Warning" })
nset("<leader>ud", utils.toggle_diagnostics, { desc = "Toggle Diagnostics" })

-- toggle treesitter highlights
nset("<leader>uT", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    vim.notify("Disabled Treesitter Highlights")
  else
    vim.treesitter.start()
    vim.notify("Enabled Treesitter Highlights")
  end
end, { desc = "Toggle Treesitter Highlight" })

-- toggle options
nset("<leader>uw", function() utils.toggle_option("wrap") end, { desc = "Toggle Word Wrap" })
nset("<leader>ub", function() utils.toggle_option("background", { "light", "dark" }) end, { desc = "Toggle Background" })

-- quickfix diagnostics
function set_diagnostics_in_quickfix()
  local diagnostics = vim.diagnostic.get()
  local qf_entries = {}
  for _, diagnostic in ipairs(diagnostics) do
    local bufnr = diagnostic.bufnr
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    table.insert(qf_entries, {
      bufnr = bufnr,
      lnum = diagnostic.lnum + 1,
      col = diagnostic.col + 1,
      text = diagnostic.message,
      filename = bufname,
    })
  end
  vim.fn.setqflist(qf_entries, "r")
  vim.cmd("copen")
end

vim.api.nvim_set_keymap("n", "<leader>xD", ":lua set_diagnostics_in_quickfix()<CR>", { noremap = true, silent = true, desc = "Diagnostics to Quickfix list" })
-- quickfix navigation
nset("<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
nset("<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
nset("[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
nset("]q", vim.cmd.cnext, { desc = "Next Quickfix" })
-- delete quickfix items
function remove_quickfix_item()
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
      "<cmd>lua remove_quickfix_item()<CR>",
      { noremap = true, silent = true, desc = "Remove Quickfix Item" }
    )
  end,
})
