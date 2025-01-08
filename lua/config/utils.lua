local LazyUtil = require("lazy.core.util")

local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end

    t[k] = require("config.utils." .. k)
    return t[k]
  end,
})

function M.toggle_option(option, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return vim.notify(
      "Set " .. option .. " to " .. vim.opt_local[option]:get(),
      { title = "Option", level = vim.log.levels.INFO }
    )
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if vim.opt_local[option]:get() then
    vim.notify("Enabled " .. option, { title = "Option", level = vim.log.levels.INFO })
  else
    vim.notify("Disabled " .. option, { title = "Option", level = vim.log.levels.WARN })
  end
end

function M.toggle_diagnostics()
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

function M.next_diagnostic(severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.goto_next({ severity = severity })
  end
end

function M.prev_diagnostic(severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.goto_prev({ severity = severity })
  end
end

function M.relative_path()
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
  return relative_path
end

function M.path()
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

  return relative_path
end

function M.is_valid_path(path)
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

-- stolen from lazyvim
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

-- stolen from lazyvim
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

return M
