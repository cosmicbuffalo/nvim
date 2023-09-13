return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      -- {
      --   "nvim-telescope/telescope-frecency.nvim",
      --   dependencies = {
      --     "kkharji/sqlite.nvim",
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
      -- {
      --   "<leader><leader>",
      --   function()
      --     require("telescope").extensions.frecency.frecency({
      --       promp_title = "Recent Files",
      --       workspace = "CWD",
      --       sorter = require("telescope.config").values.file_sorter(),
      --     })
      --   end,
      --   desc = "Find Recent Files",
      -- },
    },
    config = function()
      local telescope = require("telescope")
      -- telescope.load_extension("harpoon")
      telescope.load_extension("undo")
      -- telescope.load_extension("frecency")
    end,
  },
}
