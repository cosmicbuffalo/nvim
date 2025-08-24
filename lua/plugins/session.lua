return {
  {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Desktop", "~/Downloads", "/" },
        auto_session_use_git_branch = true,
        session_lens = {
          buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
        single_session_mode = true,
        pre_save_cmds = {},
        post_restore_cmds = {},
        no_restore_cmds = {
          function()
            if #vim.fn.argv() == 0 then
              require("oil").open()
            end
          end,
        },
      })
			-- stylua: ignore
			require("telescope").load_extension("session-lens")
    end,
    keys = {
      {
        "<leader>qS",
        function()
          require("auto-session.session-lens").search_session()
        end,
        noremap = true,
        desc = "Session List",
      },
      { "<leader>qs", ":SessionSave<cr>", noremap = true, desc = "Save Session" },
      { "<leader>qd", ":SessionDelete<cr>", noremap = true, desc = "Delete Session" },
      { "<leader>qr", ":SessionRestore<cr>", noremap = true, desc = "Restore Session" },
      { "<leader>qp", ":SessionPurgeOrphaned<cr>", noremap = true, desc = "Purge Orphaned Sessions" },
      {
        "<leader>qo",
        function()
          local current_session = vim.v.this_session
          if current_session and current_session ~= "" then
            vim.cmd.edit(vim.fn.fnameescape(current_session))
          else
            vim.notify("No session to open", vim.log.levels.WARN)
          end
        end,
        noremap = true,
        desc = "Open Current Session File",
      },
    },
  },
}
