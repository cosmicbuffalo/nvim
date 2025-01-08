local Utils = require("config.utils")
local set = vim.keymap.set
local vset = function(...)
  set("v", ...)
end
-- format selections (more reliable rubocop)
function run_rubocop_on_selection()
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
  os.remove(temp_file)
end

function format_selection()
  local current_file = vim.fn.expand("%")
  if string.match(current_file, "%.rb$") then
    run_rubocop_on_selection()
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

-- vset("<leader>cf", format_selection, { desc = "Format selection" })

set({ "n", "v" }, "<leader>cf", function()
  Utils.format({ force = true })
end, { desc = "Format" })
