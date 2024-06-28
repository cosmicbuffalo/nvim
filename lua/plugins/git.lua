return {
  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        -- customize keymaps
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "<leader>ghn", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>ghp", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- {
  --   'akinsho/git-conflict.nvim',
  --   version = "*",
  --   config = function()
  --     require('git-conflict').setup()
  --
  --     vim.api.nvim_create_autocmd('User', {
  --       pattern = 'GitConflictDetected',
  --       callback = function()
  --         vim.notify('Conflict detected in ' .. vim.fn.expand('<afile>'))
  --         vim.keymap.set("n", "<leader>gm", ":GitConflictListQf<CR>", { desc = "Open Merge Conflict QF List" })
  --       end
  --     })
  --     vim.api.nvim_create_autocmd('User', {
  --       pattern = 'GitConflictResolved',
  --       callback = function()
  --         vim.notify('Conflict resolved in ' .. vim.fn.expand('<afile>'))
  --       end
  --     })
  --   end
  -- },
  {
    -- 'sindrets/diffview.nvim',
    'cosmicbuffalo/diffview.nvim',
    cmd = {'DiffviewOpen', 'DiffviewToggle' },
    keys = {
      { "<leader>gd", "<cmd>DiffviewToggle<CR>", desc = "Toggle Diff Viewer" },
    }
  }
}
