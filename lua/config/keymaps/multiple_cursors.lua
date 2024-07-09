-- helpers
local set = vim.keymap.set
local nset = function(...) set("n", ...) end
local vset = function(...) set("v", ...) end
-- "Multiple Cursors"
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-- https://github.com/akinsho/dotfiles/blob/45c4c17084d0aa572e52cc177ac5b9d6db1585ae/.config/nvim/plugin/mappings.lua#L298
--
-- -- Functions for multiple cursors
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]], true, true, true)

function setup_multiple_cursors()
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

nset("cn", "*``cgn", { desc = "Initiate multiple cursors" })
vset("cn", [[g:mc . "``cgn"]], { desc = "Initiate multiple cursors", expr = true, noremap = true, silent = true })
nset("cN", "*``cgN", { desc = "Initiate multiple cursors (in backwards direction)" })
vset(
  "cN",
  [[g:mc . "``cgN"]],
  { desc = "Initiate multiple cursors (in backwards direction)", expr = true, noremap = true, silent = true }
)

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.

nset("cq", [[:\<C-u>call v:lua.setup_multiple_cursors()<CR>*``qz]], { desc = "Initiate multiple cursor macro" })
vset(
  "cq",
  [[":\<C-u>call v:lua.setup_multiple_cursors()<CR>gv" . g:mc . "``qz"]],
  { desc = "Initiate multiple cursor macro", expr = true, noremap = true, silent = true }
)
nset(
  "cQ",
  [[:\<C-u>call v:lua.setup_multiple_cursors()<CR>#``qz]],
  { desc = "Initiate multiple cursor macro (backwards)" }
)
vset(
  "cQ",
  [[":\<C-u>call v:lua.setup_multiple_cursors()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
  { desc = "Initiate multiple cursor macro (backwards)", expr = true, noremap = true, silent = true }
)
