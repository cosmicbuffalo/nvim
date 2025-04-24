return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {
      check_ts = true,
    },
  },
  -- jump between more complex pairs with %
  -- also does highlighting of destination pairs
  {
    "andymass/vim-matchup",
    lazy = false,
  },
  -- surround text with quotes, brackets, etc.
  {
    "kylechui/nvim-surround",
    -- enabled = false,
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        move_cursor = false,
        -- keymaps = {
        --   visual = "",
        -- }
      })
    end,
  },
  -- similar to nvim-surround, haven't decided which I like better yet
  -- {
  --   enabled = false,
  --   "echasnovski/mini.surround",
  --   keys = function(_, keys)
  --     -- Populate the keys based on the user's options
  --     local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
  --     local opts = require("lazy.core.plugin").values(plugin, "opts", false)
  --     local mappings = {
  --       { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
  --       { opts.mappings.delete, desc = "Delete Surrounding" },
  --       { opts.mappings.find, desc = "Find Right Surrounding" },
  --       { opts.mappings.find_left, desc = "Find Left Surrounding" },
  --       { opts.mappings.highlight, desc = "Highlight Surrounding" },
  --       { opts.mappings.replace, desc = "Replace Surrounding" },
  --       { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
  --     }
  --     mappings = vim.tbl_filter(function(m)
  --       return m[1] and #m[1] > 0
  --     end, mappings)
  --     return vim.list_extend(mappings, keys)
  --   end,
  --   opts = {
  --     mappings = {
  --       add = "gsa", -- Add surrounding in Normal and Visual modes
  --       delete = "gsd", -- Delete surrounding
  --       find = "gsf", -- Find surrounding (to the right)
  --       find_left = "gsF", -- Find surrounding (to the left)
  --       highlight = "", -- Highlight surrounding
  --       replace = "gsr", -- Replace surrounding
  --       update_n_lines = "gsn", -- Update `n_lines`
  --     },
  --     custom_surroundings = {
  --       ["("] = { input = { "(", ")" }, output = { left = "(", right = ")" } },
  --       [")"] = { input = { "(", ")" }, output = { left = "(", right = ")" } },
  --       ["["] = { input = { "[", "]" }, output = { left = "[", right = "]" } },
  --       ["]"] = { input = { "[", "]" }, output = { left = "[", right = "]" } },
  --       ["{"] = { input = { "{", "}" }, output = { left = "{ ", right = " }" } },
  --       ["}"] = { input = { "{", "}" }, output = { left = "{ ", right = " }" } },
  --     },
  --   },
  -- },
}
