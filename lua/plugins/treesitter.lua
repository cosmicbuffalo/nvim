return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    opts = {
      indent = { enable = false },
      autotag = { enable = true },
      ensure_installed = {
        "ruby",
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "tsx",
        "yaml",
      },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["ac"] = { query = "@class.outer", desc = "Select around class" },
            ["ic"] = { query = "@class.inner", desc = "Select inside class" },
            ["af"] = { query = "@function.outer", desc = "Select around function" },
            ["if"] = { query = "@function.inner", desc = "Select inside function" },
            ["al"] = { query = "@loop.outer", desc = "Select around loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inside loop" },
            ["ab"] = { query = "@block.outer", desc = "Select around block" },
            ["ib"] = { query = "@block.inner", desc = "Select inside block" },
          },
          selection_modes = {
            ['@class.outer'] = "V"
          }
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- enabled = false,
    config = function()
      require("treesitter-context").setup({
        max_lines = 6,
        multiline_threshold = 3,
        trim_scope = "inner",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- enabled = false,
    determines = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "windwp/nvim-ts-autotag",
    -- enabled = false,
  },
}
