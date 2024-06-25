
-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  pattern = "*",
})

-- Set wrap for telescope previews
autocmd("User", {
  callback = function()
    vim.opt_local.wrap = true
  end,
  pattern = "TelescopePreviewerLoaded",
})

-- tint_group = augroup("dimming", { clear = true })
-- autocmd({ "FocusGained", "VimEnter", "BufEnter" }, {
--   group = tint_group,
--   pattern = "*",
--   callback = function()
--     require("tint").untint(vim.api.nvim_get_current_win())
--   end,
-- })
--
-- autocmd("FocusLost", {
--   group = tint_group,
--   pattern = "*",
--   callback = function()
--     require("tint").tint(vim.api.nvim_get_current_win())
--   end,
-- })

local baleia = require("baleia").setup({})
autocmd("BufReadPost", {
  pattern = "Trouble",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    baleia.once(bufnr)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  end,
})

-- vim.cmd([[autocmd FileType ruby setlocal indentkeys-=.]])

-- Opens non-text files in the default program instead of in Neovim
local openFile = augroup("openFile", {})
autocmd("BufReadPost", {
  pattern = {
    "*.jpeg",
    "*.jpg",
    "*.pdf",
    "*.png",
  },
  callback = function()
    vim.fn.jobstart('open "' .. vim.fn.expand("%") .. '"', {
      detach = true,
    })
    local bd = require("mini.bufremove").delete
    bd(0)
    -- vim.api.nvim_buf_delete(0, {})
  end,
  group = openFile,
})

-- Array of file names indicating root directory. Modify to your liking.
local root_names = { '.git', 'Gemfile' }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

local set_root = function()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return end
  path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    if root_file == nil then return end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  -- Set current directory
  vim.fn.chdir(root)
end

local root_augroup = augroup('MyAutoRoot', {})
autocmd('BufEnter', { group = root_augroup, callback = set_root })
