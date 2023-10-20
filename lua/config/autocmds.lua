-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  pattern = "*",
})

-- Set wrap for telescope previews
vim.api.nvim_create_autocmd("User", {
  callback = function()
    vim.opt_local.wrap = true
  end,
  pattern = "TelescopePreviewerLoaded",
})

tint_group = vim.api.nvim_create_augroup("dimming", { clear = true })
vim.api.nvim_create_autocmd("FocusGained", {
  group = tint_group,
  pattern = "*",
  callback = function()
    require("tint").untint(vim.api.nvim_get_current_win())
  end,
})
vim.api.nvim_create_autocmd("FocusLost", {
  group = tint_group,
  pattern = "*",
  callback = function()
    require("tint").tint(vim.api.nvim_get_current_win())
  end,
})
local baleia = require("baleia").setup({})
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = 'Trouble',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    baleia.once(bufnr)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

  end
})

vim.cmd [[autocmd FileType ruby setlocal indentkeys-=.]]
