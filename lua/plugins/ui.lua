return {
  -- icons
  -- { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "cosmicbuffalo/lazy_jumpliner_recipe",
    opts = {
      enable_eyeliner_by_default = true,
      enable_mini_jump = true,
    },
  },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "rcarriga/nvim-notify",
    enabled = true,
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>uh",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Notification History",
      },
    },
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "IBLEnable", "IBLDisable", "IBLToggle", "IBLEnableScope", "IBLDisableScope", "IBLToggleScope" },
    keys = {
      {
        "<leader>uI",
        function()
          require("ibl").setup_buffer(0, { enabled = not require("ibl.config").get_config(0).enabled })
        end,
        desc = "Toggle Indention Guides",
      },
    },
    opts = function()
      return {
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { show_start = false, show_end = false },
        exclude = {
          filetypes = {
            "Trouble",
            "alpha",
            "dashboard",
            "help",
            "lazy",
            "mason",
            "neo-tree",
            "notify",
            "snacks_dashboard",
            "snacks_notif",
            "snacks_terminal",
            "snacks_win",
            "toggleterm",
            "trouble",
          },
        },
      }
    end,
  },
  -- NOTE: this doesn't work well with snacks dashboard
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "VeryLazy",
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
          "snacks_dashboard", -- snacks dashboard should be disabled but this isn't working for some reason
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function(args)
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
