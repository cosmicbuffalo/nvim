local SwitchColorschemeKeyMap = require("config.utils").colors.SwitchColorschemeKeyMap

return {
  -- Util for persisting chosen colorscheme
  {
    "cosmicbuffalo/telescope-colorscheme-persist.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = false,
    opts = {
      -- The default keybind needs to be disabled to avoid conflicts with
      -- lazy.nvim's lazy loading behavior using `keys` settings in specs
      keybind = false,
    },
    keys = { SwitchColorschemeKeyMap },
  },
  {
    "folke/tokyonight.nvim",
    keys = { SwitchColorschemeKeyMap },
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "hectron/inkline.nvim",
    priority = 1000,
    lazy = false,
    keys = { SwitchColorschemeKeyMap },
    opts = {
      transparent = false,
      dim_inactive_windows = true,
      purple_comments = false,
      style = "original",
      cache = false,
    },
    config = function(_, opts)
      require("inkline").setup(opts)
      vim.cmd.colorscheme("inkline")
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    keys = {
      {
        "<leader>uc",
        function()
          if vim.g.colorizer_on then
            vim.cmd("ColorizerToggle")
            vim.g.colorizer_on = false
          else
            vim.cmd("Lazy reload nvim-colorizer.lua")
            vim.cmd("ColorizerToggle")
            vim.g.colorizer_on = true
          end
        end,
        desc = "Toggle Colorizer",
      },
    },
  },
}
