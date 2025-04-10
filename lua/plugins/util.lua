local LazyFileEvents = require("config.utils.lazy_utils").LazyFileEvents

return {
  {
    "numToStr/Comment.nvim",
    event = LazyFileEvents,
    opts = {},
  },

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
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true, -- default settings
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
  -- search/replace in multiple files
  -- {
  --   "nvim-pack/nvim-spectre",
  --   build = false,
  --   cmd = "Spectre",
  --   opts = { open_cmd = "noswapfile vnew" },
  --   -- stylua: ignore
  --   keys = {
  --     { "<leader>sR", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
  --   },
  -- },
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
  -- { "wakatime/vim-wakatime", lazy = false },
  -- better yank/paste
  {
    "gbprod/yanky.nvim",
    enabled = true,
    priority = 100,
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      ring = { storage = "sqlite" },
    },
    keys = {
      -- stylua: ignore
      { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
    },
    config = function(opts)
      require("yanky").setup(opts)
      require("telescope").load_extension("yank_history")
    end,
  },
  -- {
  --   'ojroques/vim-oscyank',
  --   keys = {
  --     { "y", "<Plug>OSCYankOperator", mode = { "n", "x"}, desc = "Yank Text" },
  --     { "y", "<Plug>OSCYankVisual", mode = { "v" }, desc = "Yank Text" },
  --   }
  --
  -- },
  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    -- event = "LazyFile",
    version = "v3.5.4",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        -- char = "▏",
        -- tab_char = "▏",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    -- event = "LazyFile",
    opts = {
      -- symbol = "▏",
      -- symbol = '╎',
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  -- easy column alignment
  {
    { "echasnovski/mini.align", version = "*", config = true },
  },
  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  -- replaces s command with more powerful substitution
  {
    "gbprod/substitute.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local substitute = require("substitute")

      substitute.setup()

      -- set keymaps
      local keymap = vim.keymap -- for conciseness
      keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion", noremap = true })
      keymap.set("n", "ss", substitute.line, { desc = "Substitute line", noremap = true })
      keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line", noremap = true })
      keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode", noremap = true })

      local exchange = require("substitute.exchange")
      keymap.set("n", "sx", exchange.operator, { desc = "Exchange with motion", noremap = true })
      keymap.set("n", "sxx", exchange.line, { desc = "Exchange line", noremap = true })
      keymap.set("x", "X", exchange.visual, { desc = "Exchange visual selection", noremap = true })
      keymap.set("n", "sxc", exchange.cancel, { desc = "Cancel exchange", noremap = true })
    end,
  },
}
