return {
  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
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
        -- init = function()
        --   -- when noice is not enabled, install notify on VeryLazy
        --   if not LazyVim.has("noice.nvim") then
        --     LazyVim.on_very_lazy(function()
        --       vim.notify = require("notify")
        --     end)
        --   end
        -- end,
      },
    },
    event = "VeryLazy",
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
        hover = {
          silent = true,
        },
      },
      routes = {
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
            -- ["not"] = {
            --   any = {
            --     { has = true },
            --     { cleared = true },
            --   }
            -- }
          },
          view = "mini",
        },
        -- {
        --   filter = {
        --     event = "msg_show",
        --     ["not"] = { find = "[w]" },
        --     any = {
        --       { has = true },
        --       { cleared = true },
        --     },
        --   },
        --   opts = { skip = true },
        -- },
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
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                 desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
      { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,              expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
      { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,              expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
    },
  },
}
