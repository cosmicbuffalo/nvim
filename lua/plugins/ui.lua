return {
  -- icons
  -- { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "echasnovski/mini.icons",
    -- enabled = false,
    opts = {},
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        -- needed since it will be false when loading and mini will fail
        package.loaded["nvim-web-devicons"] = {}
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    lazy = false,
    -- event = "VeryLazy",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>A", group = "Alternate" },
          { "<leader>a", group = "AI" },
          { "<leader><tab>", group = "tabs" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>m", group = "markdown" },
          { "<leader>n", group = "Neotree" },
          { "<leader>q", group = "quit/session" },
          { "<leader>r", group = "Run tests" },
          { "<leader>s", group = "search" },
          { "<leader>sn", group = "noice" },

          { "<leader>t", group = "treesitter/test" },
          { "<leader>u", group = "UI", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>v", group = "Vimux/visual" },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
  -- routes various messages and notifications to different views
  {
    "folke/noice.nvim",
    -- enabled = false,
    dependencies = {
      -- Better `vim.notify()`
      {
        "rcarriga/nvim-notify",
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
    },
    event = "VeryLazy",
    opts = {
      commands = {
        history = {
          -- filter = {
          --   any = {
          --     { event = "notify" },
          --     { error = true },
          --     { warning = true },
          --     { event = "msg_show" },
          --     { event = "lsp", kind = "message" },
          --   },
          -- },
        },
      },
      views = {
        split = {
          enter = true,
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          silent = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "echo",
            find = "Treesitter",
          },
          view = "notify",
        },
        {
          filter = {
            event = "msg_show",
            kind = "echo",
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+ lines" },
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
  },
}
