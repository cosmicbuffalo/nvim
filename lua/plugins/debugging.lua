return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {},
    config = function() end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
        keys = {
          {
            "<leader>dU",
            function()
              require("dapui").toggle({})
            end,
            desc = "Dap UI",
          },
          {
            "<leader>de",
            function()
              require("dapui").eval()
            end,
            desc = "Eval",
            mode = { "n", "v" },
          },
        },
        opts = {},
        confg = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "jbyuki/one-small-step-for-vimkind",
        config = function()
          local dap = require("dap")
          dap.adapters.nlua = function(callback, conf)
            local adapter = {
              type = "server",
              host = conf.host or "127.0.0.1",
              port = conf.port or 8086,
            }
            if conf.start_neovim then
              local dap_run = dap.run
              dap.run = function(c)
                adapter.port = c.port
                adapter.host = c.host
              end
              require("osv").run_this()
              dap.run = dap_run
            end
            callback(adapter)
          end
          dap.configurations.lua = {
            {
              type = "nlua",
              request = "attach",
              name = "Run this file",
              start_neovim = {},
            },
            {
              type = "nlua",
              request = "attach",
              name = "Attach to running Neovim instance (port = 8086)",
              port = 8086,
            },
          }
        end,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
      -- { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      -- { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      -- { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>ds", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>du", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over" },
      -- { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      -- { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          -- "ruby",
        },
      })
      -- local dap = require("dap")
      -- local dapui = require("dapui")

      -- dap.configurations.lua = {
      --   {
      --     type = "nlua",
      --     request = "attach",
      --     name = "Attach to running Neovim instance",
      --   },
      -- }
      -- dap.adapters.nlua = function(callback, config)
      --   callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      -- end
      -- dap.listeners.before.attach.dapui_config = function()
      --   dapui.open()
      -- end
      -- dap.listeners.before.launch.dapui_config = function()
      --   dapui.open()
      -- end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end

      -- vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      -- vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      -- vim.keymap.set("n", "<leader>ds", dap.step_into, { desc = "Step Into" })
      -- vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Step Over" })
      -- -- vim.keymap.set("n", "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover" })
      -- vim.keymap.set("n", "<leader>dd", require("osv").launch({ port = 8086 }), { desc = "Launch" })
    end,
  },
}
