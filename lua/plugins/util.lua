return {
  -- seamless navigation between vim and tmux panes
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      {
        "<C-h>",
        "<cmd>TmuxNavigateLeft<cr>",
        mode = { "n", "i", "x", "o" },
        desc = "Tmux Navigate Left",
        silent = true,
      },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Tmux Navigate Down", silent = true },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Tmux Navigate Up", silent = true },
      {
        "<C-l>",
        "<cmd>TmuxNavigateRight<cr>",
        mode = { "n", "i", "x", "o" },
        desc = "Tmux Navigate Right",
        silent = true,
      },
    },
  },
  -- visualize and restore branching undo history
  {
    "mbbill/undotree",
    cmd = "Undotree",
    keys = {
      { "<leader>U", ":UndotreeToggle<CR>", desc = "Undo Tree" },
      { "<leader>su", ":Telescope undo<cr>", desc = "Undo Tree (Telescope)" },
    },
  },
  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  -- open url under cursor in the browser
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "Open url in browser" } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gx").setup({
        open_callback = function(url)
          vim.fn.setreg("+", url) -- make gx copy to clipboard to use with open clipboard links script
        end,
      })
    end,
    submodules = false, -- not needed, submodules are required only for tests
  },
  -- unix shell commands from vim
  { "tpope/vim-eunuch", cmd = { "Move", "Rename", "Remove", "Delete", "Mkdir" } },
  -- increment/decrement date strings
  { "tpope/vim-speeddating" },
  -- preview lines in buffer as you type :lineno
  {
    "nacro90/numb.nvim",
    config = function()
      require("numb").setup()
    end,
  },
  -- newer search/replace as a buffer
  {
    "MagicDuck/grug-far.nvim",
    -- enabled = false,
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sR",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace (GrugFar)",
      },
    },
  },
  -- toggle terminals with <c-_> or <c-/>
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-_>]],
        winbar = {
          enabled = true,
          name_formatter = function(term)
            return term.name
          end,
        },
      })
      require("which-key").add({
        { "<C-/>", desc = "Toggle Terminal" },
        { "<C-_>", desc = "Toggle Terminal" },
      })
    end,
  },
  -- track coding time
  { "wakatime/vim-wakatime", lazy = false },
}
