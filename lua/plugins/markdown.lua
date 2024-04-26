return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true } },
      { "n", "<leader>ms", ":MarkdownPreviewStop<CR>", { noremap = true, silent = true } },
      { "n", "<leader>mt", ":MarkdownPreviewToggle<CR>", { noremap = true, silent = true } },
    }
  }
}
