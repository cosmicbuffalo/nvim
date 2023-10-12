return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- this is now done with vim.g.autoformat
      -- autoformat = false, -- Disable autoformat by default
    },
    -- dependencies = {
    --   "nvimdev/lspsaga.nvim",
    --   config = function ()
    --     require("lspsaga").setup({})
    --   end,
    --   dependencies = {
    --     'nvim-treesitter/nvim-treesitter',
    --     'nvim-tree/nvim-web-devicons',
    --   }
    -- }
  },
}
