-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local vg = vim.g

vim.diagnostic.disable() -- disable diagnostics by default
-- vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,options,localoptions"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

opt.shell = "/bin/zsh"
vg.mapleader = " "
vg.maplocalleader = "_"
opt.termguicolors = true -- True color support
vg.autoformat = false
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vg.mouse = "a"
vg.mousemoveevent = true
vg.navic_silence = true
-- vg.minipairs_disable = true
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true
opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
-- opt.smartindent = false
-- opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.incsearch = true
opt.hlsearch = true
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 8
opt.sidescrolloff = 2
opt.updatetime = 50
opt.confirm = true -- confirm to save changes before exiting buffer
opt.cursorline = true
opt.expandtab = true -- Use spaces instead of tabs
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
opt.smoothscroll = true
-- opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
-- opt.foldmethod = "expr"
-- opt.foldtext = ""
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.wrap = false -- Disable line wrap
opt.linebreak = true -- Wrap lines at convenient points
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current

-- opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
-- for some reason this isn't working anymore
vim.o.guicursor = "n-v-c-sm:block-nCursor-blinkwait50-blinkon50-blinkoff50,i-ci-ve:ver25-Cursor-blinkon100-blinkoff100,r-cr-o:hor20"

-- Don't want relative no on inactive Windows
local relativeNo = vim.api.nvim_create_augroup("RelativeNo", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  pattern = "*",
  group = relativeNo,
  callback = function()
    if not vg.zen_mode_active then
      vim.cmd([[set relativenumber]])
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  pattern = "*",
  group = relativeNo,
  callback = function()
    if not vg.zen_mode_active then
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

-- gray
vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
-- blue
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
-- light blue
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
-- pink
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
-- front
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })

-- Disable tmux navigator when zooming the Vim pane
vg.tmux_navigator_disable_when_zoomed = 1

-- Write all buffers before navigating from vim to tmux pane
vg.tmux_navigator_save_on_switch = 2
