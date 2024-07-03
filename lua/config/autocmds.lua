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
local root_names = { ".git", "Gemfile" }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

local set_root = function()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return
  end
  path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    if root_file == nil then
      return
    end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  -- Set current directory
  vim.fn.chdir(root)
end

local root_augroup = augroup("MyAutoRoot", {})
autocmd("BufEnter", { group = root_augroup, callback = set_root })

local function set_lazyvim_autocommands()

  local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
  end

  -- Check if we need to reload the file when it changed
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end,
  })

  -- Highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- resize splits if window got resized
  vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd("tabdo wincmd =")
      vim.cmd("tabnext " .. current_tab)
    end,
  })

  -- go to last loc when opening a buffer
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
      local exclude = { "gitcommit" }
      local buf = event.buf
      if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
        return
      end
      vim.b[buf].lazyvim_last_loc = true
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local lcount = vim.api.nvim_buf_line_count(buf)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  -- close some filetypes with <q>
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
      "PlenaryTestPopup",
      "help",
      "lspinfo",
      "notify",
      "qf",
      "spectre_panel",
      "startuptime",
      "tsplayground",
      "neotest-output",
      "checkhealth",
      "neotest-summary",
      "neotest-output-panel",
      "dbout",
      "gitsigns.blame",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
  })

  -- make it easier to close man-files when opened inline
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("man_unlisted"),
    pattern = { "man" },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
    end,
  })

  -- wrap and check for spell in text filetypes
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
  })

  -- Fix conceallevel for json files
  -- vim.api.nvim_create_autocmd({ "FileType" }, {
  --   group = augroup("json_conceal"),
  --   pattern = { "json", "jsonc", "json5" },
  --   callback = function()
  --     vim.opt_local.conceallevel = 0
  --   end,
  -- })

  -- Auto create dir when saving a file, in case some intermediate directory does not exist
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
      if event.match:match("^%w%w+:[\\/][\\/]") then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
  })

  -- vim.filetype.add({
  --   pattern = {
  --     [".*"] = {
  --       function(path, buf)
  --         return vim.bo[buf]
  --             and vim.bo[buf].filetype ~= "bigfile"
  --             and path
  --             and vim.fn.getfsize(path) > vim.g.bigfile_size
  --             and "bigfile"
  --           or nil
  --       end,
  --     },
  --   },
  -- })
  --
  -- vim.api.nvim_create_autocmd({ "FileType" }, {
  --   group = augroup("bigfile"),
  --   pattern = "bigfile",
  --   callback = function(ev)
  --     vim.b.minianimate_disable = true
  --     vim.schedule(function()
  --       vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
  --     end)
  --   end,
  -- })
end
set_lazyvim_autocommands()
