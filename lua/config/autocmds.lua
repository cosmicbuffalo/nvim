-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local Util = require("lazyvim.util")
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

tint_group = augroup("dimming", { clear = true })
autocmd("FocusGained", {
  group = tint_group,
  pattern = "*",
  callback = function()
    require("tint").untint(vim.api.nvim_get_current_win())
  end,
})

autocmd("FocusLost", {
  group = tint_group,
  pattern = "*",
  callback = function()
    require("tint").tint(vim.api.nvim_get_current_win())
  end,
})

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

autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      -- Util.notify("closing neo tree and restoring session")
      require("neo-tree").close_all()
      vim.defer_fn(function()
        require("persistence").load()
      end, 100)
    end, 400)
  end,
})
