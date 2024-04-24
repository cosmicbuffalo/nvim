return {
  {
    "nvim-neotest/neotest",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
    },
    opts = {
      adapters = { "neotest-rspec" },
    },
  },
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
    'vim-test/vim-test',
    dependencies = {
      'preservim/vimux'
    },
    config = function()
      vim.keymap.set('n', '<leader>tt', ':TestFile<CR>', { desc = 'Run all tests in file' })
      vim.keymap.set('n', '<leader>tr', ':TestNearest<CR>', { desc = 'Run nearest example' })
      vim.keymap.set('n', '<leader>tT', ':TestSuite<CR>', { desc = 'Run test suite' })

      vim.cmd("let test#strategy = 'vimux'")
    end


  }
}
