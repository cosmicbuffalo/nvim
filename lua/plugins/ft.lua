return {
  -- lots of magic for rails repos, similar to lsp features
  "tpope/vim-rails",
  -- slim syntax highlighting (doesn't work super well tho)
  { "slim-template/vim-slim", ft = "slim" },
  -- live markdown preview in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true, desc = "Start Markdown Preview" } },
      { "<leader>ms", ":MarkdownPreviewStop<CR>", { noremap = true, silent = true , desc = "Stop Markdown Preview"} },
      { "<leader>mt", ":MarkdownPreviewToggle<CR>", { noremap = true, silent = true , desc = "Toggle Markdown Preview"} },
    },
  },
  -- supposedly enables syntax highlighting in markdown codeblocks, hard to tell if it's working tho
  {
    "plasticboy/vim-markdown",
    config = function()
      vim.g.vim_markdown_fenced_laguages = {
        "ruby=rb",
      }
    end,
  },
  {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    opts = {},
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}
}
