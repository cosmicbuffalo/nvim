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
      "preservim/vimux",
    },
    config = function()
      vim.cmd("let test#strategy = 'vimux'")
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*_spec.rb",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>t<space>", ":TestFile<CR>", { desc = "Run all tests in file" })
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>te", ":TestNearest<CR>", { desc = "Run nearest example" })
        end,
      })
    end,
  },
}
