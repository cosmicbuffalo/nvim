-- TODO: I'd like to figure out how to lazy load these and keep the same lazy buffer local keymap behavior
-- but I haven't found out how to do it yet
return {
  {
    "emilsoman/spec-outline.vim",
    config = function()
      vim.g.spec_outline_orientation = "right"
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*_spec.rb",
        callback = function()
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<leader>cs",
            ":SpecOutlineToggle<CR>",
            { noremap = true, silent = true, desc = "Toggle Outline (Spec)" }
          )
        end,
      })
    end,
  },
  {
    "vim-test/vim-test",
    dependencies = {
      {
        "benmills/vimux",
        dependencies = {
          "jgdavey/vim-turbux",
          "samguyjones/vim-crosspaste",
        },
        init = function()
          vim.g["test#strategy"] = "vimux"
        end,
      },
    },
    keys = {
      { "<Leader>t<space>", "<cmd>wa<CR> <cmd>TestFile<CR>", desc = "Run file" },
      { "<Leader>te", "<cmd>wa<CR> <cmd>TestNearest<CR>", desc = "Run example (focused)" },
      { "<Leader>ta", "<cmd>wa<CR> <cmd>TestLast<CR>", desc = "Run again" },
    },
  },
}
