return {
  {
    "rmagatti/auto-session",
    -- enabled = false,
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Desktop", "~/Downloads", "/" },
        auto_session_use_git_branch = true,
        session_lens = {
          -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
          buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
        post_cwd_changed_hook = function()
          require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
        end,
        pre_save_cmds = {
          function()
            vim.cmd([[Neotree close]])
          end
        },
        post_restore_cmds = {
          function()
            vim.cmd([[Neotree close]])
          end
        },
      })
      -- stylua: ignore
      require("telescope").load_extension("session-lens")
      vim.keymap.set("n", "<leader>qS", require("auto-session.session-lens").search_session, { noremap = true, desc = "Session List" })
      vim.keymap.set("n", "<leader>qs", ":SessionSave<cr>", { noremap = true, desc = "Save Session", })
      vim.keymap.set("n", "<leader>qd", ":SessionDelete<cr>", { noremap = true, desc = "Delete Session", })
      vim.keymap.set("n", "<leader>qr", ":SessionRestore<cr>", { noremap = true, desc = "Restore Session", })
      vim.keymap.set("n", "<leader>qp", ":SessionPurgeOrphaned<cr>", { noremap = true, desc = "Purge Orphaned Sessions", })
    end,
  },
}
