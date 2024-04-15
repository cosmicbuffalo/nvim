return {
  {
    "neovim/nvim-lspconfig",
    -- enabled = false,
    opts = {
      -- this is now done with vim.g.autoformat
      -- autoformat = false, -- Disable autoformat by default
    },
    dependencies = {
      -- "nvimdev/lspsaga.nvim",
      -- config = function ()
      --   require("lspsaga").setup({})
      -- end,
      -- dependencies = {
      --   'nvim-treesitter/nvim-treesitter',
      --   'nvim-tree/nvim-web-devicons',
      -- }
      -- {
      --   "nvimtools/none-ls.nvim",
      --   optional = true,
      --   opts = function(_, opts)
      --     local nls = require("null-ls")
      --     ops.sources = opts.sources or {}
      --     table.insert(opts.sources, nls.builtins.formatting.rubocop)
      --   end
      -- }
    }
  },
}
