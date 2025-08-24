return {
  -- nice columns and colors for quickfix window
  {
    "yorickpeterse/nvim-pqf",
    config = function()
      require("pqf").setup()
    end,
  },
  -- bettew quickfix window with floating preview
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
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
}
