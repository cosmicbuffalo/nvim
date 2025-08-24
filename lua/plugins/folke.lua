local Utils = require("config.utils")

local open_lazygit_with_tracked_window = function()
  Utils.set_tracked_window()
  Snacks.lazygit({ cofigure = true })
end

local remote_q = 'nvim --server "$NVIM" --remote-send "q"'
local remote_open_with_tracked_window =
  'nvim --server "$NVIM" --remote-send "<C-\\><C-N>:lua require(\\"config.utils\\").open_in_tracked_window(\\"{{filename}}\\")<CR>"'
local remote_goto_line = 'nvim --server "$NVIM" --remote-send ":{{line}}<CR>"'
local remote_q_open = remote_q .. " && " .. remote_open_with_tracked_window
local lazygit_edit_command = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (' .. remote_q_open .. ")"
local lazygit_edit_at_line_command = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || ('
  .. remote_q_open
  .. " && "
  .. remote_goto_line
  .. ")"
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>a", group = "AI" },
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
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>sn", group = "noice" },
          { "<leader>t", group = "treesitter/test" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>v", group = "visual" },
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
          { "zj", desc = "Move to next fold" },
          { "zk", desc = "Move to previous fold" },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = false,
      },

      scroll = {
        enabled = false,
      },
      indent = {
        enabled = false,
      },
      lazygit = {
        config = {
          os = {
            edit = lazygit_edit_command,
            editAtLine = lazygit_edit_at_line_command,
            editAtLineAndWait = "nvim +{{line}} {{filename}}",
            openDirInEditor = '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
          },
        },
      },
      zen = {},
    },
    keys = {
      {
        "<leader>gg",
        function()
          open_lazygit_with_tracked_window()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "[G]it [B]lame",
      },
      {
        "<leader>b.",
        function()
          Snacks.scratch()
        end,
        desc = "New Scratch [b]uffer",
      },
      {
        "<leader>bS",
        function()
          Snacks.scratch.select()
        end,
        desc = "Scratch [b]uffer [S]elect",
      },
      {
        "<leader>uZ",
        function()
          Snacks.zen()
        end,
        desc = "[Z]en mode",
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "neiotsrahdcmglpufbjywxzq",
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },
		-- stylua: ignore
		keys = {
			{ "<leader>ss", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "<leader>sS", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",          mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",          mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			-- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
  },
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = { "rcarriga/nvim-notify" },
    opts = {
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
				"<leader>uh",
				function()
					require("telescope").extensions.notify.notify()
				end,
				desc = "Notification History",
			},
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
  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      focus = true,
      pinned = true,
      keys = {
        ["<leader>z"] = "fold_toggle",
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle<cr>", desc = "LSP Viewer (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },
  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todos" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
