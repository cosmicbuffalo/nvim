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
      {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
          require("telescope").load_extension("frecency")
        end,
        dependencies = {
          "kkharji/sqlite.lua",
        },
      },
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
        "<leader><leader>",
        function()
          require("telescope").extensions.frecency.frecency({
            prompt_title = "Recent Files",
            workspace = "CWD",
            sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
          })
        end,
        desc = "Find Recent Files",
      },
    },
  },
}
