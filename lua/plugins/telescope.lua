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
              local actions = require('telescope.actions')
              map("n", "<c-x>", actions.delete_buffer)
              map("i", "<c-x>", actions.delete_buffer)
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
