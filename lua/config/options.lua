-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.softtabstop = 2
opt.autoindent = true
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.incsearch = true
opt.hlsearch = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 50
opt.foldmethod = "indent"
opt.foldlevel = 99 -- unfold everything by default
opt.guicursor =
  "n-v-c-sm:block-nCursor-blinkwait50-blinkon50-blinkoff50,i-ci-ve:ver25-Cursor-blinkon100-blinkoff100,r-cr-o:hor20"

-- Don't want relative no on inactive Windows
local relativeNo = vim.api.nvim_create_augroup("RelativeNo", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  pattern = "*",
  group = relativeNo,
  callback = function()
    if not vim.g.zen_mode_active then
      vim.cmd([[set relativenumber]])
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  pattern = "*",
  group = relativeNo,
  callback = function()
    if not vim.g.zen_mode_active then
      vim.cmd([[set norelativenumber]])
    end
  end,
})

-- This is global settings for diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
})
