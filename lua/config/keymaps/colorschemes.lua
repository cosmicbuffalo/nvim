local set = vim.keymap.set
local nset = function(...) set("n", ...) end

-- switch back and forth between color schemes
local current_colorscheme = vim.g.colors_name
local previous_colorscheme = nil

function switch_color_scheme()
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
function update_colorscheme()
  local new_colorscheme = vim.g.colors_name
  if new_colorscheme ~= current_colorscheme then
    previous_colorscheme = current_colorscheme
    current_colorscheme = new_colorscheme
  end
end
-- Autocommand to detect colorscheme changes
vim.cmd([[
  augroup update_colorscheme
    autocmd!
    autocmd ColorScheme * lua update_colorscheme()
  augroup END
]])

nset("<leader>uc", "<cmd>lua switch_color_scheme()<cr>", { desc = "Last Color Scheme", noremap = true, silent = true })
