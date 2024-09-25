return {
  -- Color schemes
  {
    -- current primary theme. has decent colors but kinda too blue. I like the highlight groups and the built in dimming of inactive though
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      light_style = "day",
      dim_inactive = true,
      -- hide_inactive_statusline=true,
      lualine_bold = true,
    },
    init = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },
  { "rebelot/kanagawa.nvim" }, -- this one is pretty good, especially the wave variant. dragon is also pretty good but a little dim. highlight groups are pretty good but would need to add dimming and fix the giant statuscol
  { "marko-cerovac/material.nvim" }, -- material darker is decent, and deep ocean is similar to tokyonight. the choice of dark keys is annoying tho. other colors are also too samey
  { "EdenEast/nightfox.nvim" }, -- carbonfox is pretty nice, and dayfox might be the best light theme I've found
  { "projekt0n/github-nvim-theme" }, -- dark default is pretty good, but highlight groups are pretty different from tokyonight. would need to fix eyeliner, bars, telescope
  { "ellisonleao/gruvbox.nvim" }, -- also pretty good but with pretty different highlight groups. would need to fix statuscol, bars, eyeliner, cmp, which-key, popup highlights, maybe more
  { "ptdewey/darkearth-nvim" }, -- also pretty good but with some different highlight groups. less broken than gruvbox, but things like gitsigns and telescope need some tweaks, also eyeliner
  { "olimorris/onedarkpro.nvim" }, -- too much contrast
  { "sainnhe/everforest" }, -- pretty green. might be good with a background tweak. would need to fix eyeliner
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "rockyzhang24/arctic.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "arctic",
    branch = "v2",
  },
  {
    "Mofiqul/vscode.nvim",
    init = function()
      -- vim.o.background = "dark"
      -- vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "polirritmico/monokai-nightasty.nvim",
    init = function()
      -- vim.opt.background = "dark" -- default to dark or light style
      -- vim.cmd.colorscheme("monokai-nightasty")
    end,
  },

  -- colorize hex colors in css, javascript, html
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
  -- colorize text in qf windows and whatnot
  {
    "m00qek/baleia.nvim",
    config = function()
      require("baleia").setup({})
    end,
  },
  -- highlight jump points on f/F/t/T
  {
    "cosmicbuffalo/eyeliner.nvim",
    keys = { "f", "F", "t", "T" },
    config = function()
      require("eyeliner").setup({
        highlight_on_key = true,
        -- dim = true,
      })
      vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg="yellow", bold = true, underline = true })
    end,
  },
}
