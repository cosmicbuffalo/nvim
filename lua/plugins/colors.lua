return {
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  -- { "cosmicbuffalo/darkplus.nvim" },
  -- { "cosmicbuffalo/shanghainight.nvim", branch = "wip" },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      light_style="day",
      dim_inactive=true,
      -- hide_inactive_statusline=true,
      lualine_bold=true
    },
  },
  -- {
  --   dir = "/Users/ndelannoy/.local/share/nvim/lazy/arctic",
  --   dependencies = { "rktjmp/lush.nvim" },
  --   priority = 1000,
  --   config = function()
  --     vim.cmd("colorscheme arctic")
  --   end
  -- },
  -- {
  --   "rockyzhang24/arctic.nvim",
  --   dependencies = { "rktjmp/lush.nvim" },
  --   lazy = false,
  --   name = "arctic",
  --   branch = "v2",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd("colorscheme arctic")
  --   end
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "css",
        "javascript",
        "html",
        "slim",
      })
    end,
  },
  {
    "m00qek/baleia.nvim",
    config = function()
      require("baleia").setup({})
    end,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      -- vim.g.everforest_enable_italic = true
      -- vim.cmd.colorscheme("everforest")
    end,
  },
}
