local set = vim.keymap.set
local nset = function(...) set("n", ...) end
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
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = { border = "single" },
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "t",
        "<c-e>",
        string.format([[<cmd>lua LazygitEdit(%d)<CR>]], _G.lazygit_target_buffer),
        { noremap = true, silent = true }
      )
    end,
  })
  local _lazygit_toggle = function()
    lazygit:toggle()
  end
  local current_buffer = vim.api.nvim_get_current_buf()
  _G.lazygit_target_buffer = current_buffer
  _lazygit_toggle()
end

nset("<leader>gg", [[<Cmd>lua StartLazygit()<CR>]], { noremap = true, silent = true, desc = "Lazygit (root dir)" })

function BlameLine(opts)
  opts = vim.tbl_deep_extend("force", {
    count = 3,
    filetype = "git",
    size = {
      width = 0.6,
      height = 0.6,
    },
    border = "rounded",
  }, opts or {})
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local file = vim.api.nvim_buf_get_name(0)
  local root = vim.fs.dirname(".git") or "."
  local cmd = { "git", "-C", root, "log", "-n", opts.count, "-u", "-L", line .. ",+1:" .. file }
  return require("lazy.util").float_cmd(cmd, opts)
end
nset("<leader>gb", BlameLine, { desc = "Git Blame Line" })
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
