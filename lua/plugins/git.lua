return {
  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    -- event = "LazyFile",
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
        -- map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- handy diffview in a tab page
  {
    -- 'sindrets/diffview.nvim',
    "cosmicbuffalo/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewToggle" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewToggle<CR>", desc = "Toggle Diff Viewer" },
    },
  },
  -- shortcuts for github things
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
      local mapping = {
        ["<leader>gy"] = { desc = "Copy GitHub link" },
      }
      local wk = require("which-key")
      wk.register(mapping, { mode = "n" })
      wk.register(mapping, { mode = "v" })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>go",
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { desc = "Open in GitHub", silent = true }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<leader>go",
        '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { desc = "Open in GitHub", silent = true }
      )
      -- not actually a gitlinker feature but included in here since it's similar
      vim.keymap.set(
        "n",
        "<leader>gp",
        '<cmd>TermExec cmd="pr" open=0<CR>',
        { desc = "Create or open PR in GitHub", silent = true }
      )
      -- Function to open PR that merged the current line in GitHub
      function open_merged_pr()
        -- Get the current file and line number
        local file = vim.fn.expand("%")
        local line = vim.fn.line(".")

        -- Get the commit SHA for the current line using git blame
        local sha = vim.fn.systemlist("git blame -L " .. vim.fn.line(".") .. "," .. vim.fn.line(".") .. " " .. vim.fn.expand("%") .. ' --porcelain | cut -d " " -f 1')[1]

        if sha and sha ~= "" then
          -- Get the PR number associated with the commit SHA using gh
          local pr_number = vim.fn.systemlist('gh pr list --search "' .. sha .. '" --state "merged" --json number --jq ".[0].number"')[1]
          if pr_number and pr_number ~= "" then
            -- Open the PR in the default web browser
            vim.notify("Opening PR #" .. pr_number)
            vim.fn.system("gh pr view " .. pr_number .. " --web")
          else
            print("No PR found for this commit.")
          end
        else
          print("No commit found for this line.")
        end
      end

      -- Set the keymap
      vim.api.nvim_set_keymap(
        "n",
        "<leader>gP",
        ":lua open_merged_pr()<CR>",
        { noremap = true, silent = true, desc = "Open PR that merged current line" }
      )
    end,
  },
}
