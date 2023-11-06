return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "debugloop/telescope-undo.nvim",
        config = function()
          require("telescope").load_extension("undo")
        end,
      },
      -- {
      --   "nvim-telescope/telescope-frecency.nvim",
      --   config = function()
      --     require("telescope").load_extension("frecency")
      --   end,
      --   dependencies = {
      --     "kkharji/sqlite.lua",
      --   },
      -- },
    },
    keys = {
      -- add a keymap to browse plugin files
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({
            attach_mappings = function(prompt_bufnr, map)
              local action_state = require "telescope.actions.state"
              local bd = require("mini.bufremove").delete
              local delete_buffer = function()
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                current_picker:delete_selection(function(selection)
                  local bufnr = selection.bufnr
                  local force = vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal"
                  if force then
                    return pcall(vim.api.nvim_buf_delete, bufnr, { force = force })
                  elseif vim.fn.getbufvar(bufnr, "&modified") == 1 then
                    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)), "&Yes\n&No\n&Cancel")
                    if choice == 1 then -- Yes
                      vim.api.nvim_buf_call(bufnr, function()
                        vim.cmd("write")
                      end)
                      return bd(bufnr)
                    elseif choice == 2 then -- No
                      return bd(bufnr, true)
                    end
                  else
                    return bd(bufnr)
                  end
                end)
              end
              map("n", "<c-x>", delete_buffer)
              map("i", "<c-x>", delete_buffer)
              return true
            end
          })
        end,
        desc = "Buffers"

      }
      -- {
      --   "<leader><leader>",
      --   function()
      --     require("telescope").extensions.frecency.frecency({
      --       prompt_title = "Recent Files",
      --       workspace = "CWD",
      --       sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
      --     })
      --   end,
      --   desc = "Find Recent Files",
      -- },
    },
  },
}
