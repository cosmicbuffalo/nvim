local set = vim.keymap.set
local nset = function(...) set("n", ...) end
local utils = require("config.utils")

function lazygit_edit(original_buffer)
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

  if not utils.is_valid_path(vim.fn.getreg("+")) then
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

-- this will store the buffer that was active when lazygit was started so that files can be opened in that buffer's window
_G.lazygit_target_buffer = nil

-- Start Lazygit with custom keymaps
function start_lazygit()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = { border = "single" },
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<esc>", { noremap = true, silent = true })
      -- I wanted to overwrite the built in e command in lazygit with this keymap, but since the keymap attaches
      -- to the buffer, it also affects the behavior of "e" while typing commit messages, which I want to avoid
      -- so instead of overwriting the built in "e" command, I'm using <c-e> to open the file under the cursor in
      -- lazygit within the same window that opened lazygit originally
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "t",
        "<c-e>",
        string.format([[<cmd>lua lazygit_edit(%d)<CR>]], _G.lazygit_target_buffer),
        { noremap = true, silent = true, desc = "Edit file" }
      )
    end,
  })
  local current_buffer = vim.api.nvim_get_current_buf()
  _G.lazygit_target_buffer = current_buffer
  lazygit:toggle()
end

nset("<leader>gg", start_lazygit, { noremap = true, silent = true, desc = "Lazygit (root dir)" })

function blame_line(opts)
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

nset("<leader>gb", blame_line, { desc = "Git Blame Line" })

