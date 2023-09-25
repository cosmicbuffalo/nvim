return {
  {
    "nvim-treesitter/nvim-treesitter",
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
    determines = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
