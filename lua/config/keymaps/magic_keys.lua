local set = vim.keymap.set
local iset = function(...) set("i", ...) end
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
  local col = vim.fn.col(".") - 1
  if col <= 0 then
    return
  end

  local prev_char = vim.fn.getline("."):sub(col, col)
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
iset("/", "v:lua.magic_key()", { noremap = true, expr = true, silent = true })

-- Update last_key_time on each keypress
vim.cmd([[
  augroup UpdateKeyPressTime
    autocmd!
    autocmd InsertCharPre * lua _G.last_key_time = vim.fn.reltimefloat(vim.fn.reltime())
  augroup END
]])
