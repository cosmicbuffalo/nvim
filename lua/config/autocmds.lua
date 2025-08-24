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

-- set conceallevel to 2 for obsidian files
local obsidianGroup = augroup("Obsidian", {})
autocmd("BufReadPost", {
  pattern = vim.fn.expand("~") .. "/Obsidian/**.md",
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Relative line numbers for active pane only
local relnum_augroup = augroup("RelativeLineNumbers", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = relnum_augroup,
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = true
    end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = relnum_augroup,
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end,
})
