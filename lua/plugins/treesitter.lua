return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    opts = {
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
  }
}
