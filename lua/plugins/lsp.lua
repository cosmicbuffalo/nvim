local Utils = require("config.utils")
local LspConfig = require("config.lsp")

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              winblend = 0, -- transparent background
            },
          },
        },
      },

      {
        "mason-org/mason.nvim",
        cmd = "Mason",
        tag = "v2.0.0",
        lazy = false,
        keys = {
          { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
        },
        opts = {},
      },
      { "mason-org/mason-lspconfig.nvim", tag = "v2.0.0" },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      -- customize your keymap here, or disable a keymap by setting it to false
      keymap = {
        go_to_definition = "gd",
        go_to_declaration = "gD",
        go_to_references = "gr",
        go_to_implementation = "gi",
        jump_to_prev_diagnostic = "[d",
        jump_to_next_diagnostic = "]d",

        hover = "K",
        signature_help = false,
        toggle_inlay_hints = "gh",

        diagnostic_explain = "<Leader>de",
        diagnostics_to_quickfix = "<leader>dq",
        toggle_diagnostics = "<Leader>dt",

        type_definition = "<Leader>cD",
        document_symbols = "<Leader>cs",
        lsp_rename = "<Leader>cr",
        lsp_code_action = "<Leader>ca",
        lsp_code_format = false,
        lsp_info = "<Leader>ci",

        workspace_add_folder = "<Leader>cwa",
        workspace_remove_folder = "<Leader>cwr",
        workspace_list_folders = "<Leader>cwl",
        workspace_symbols = "<Leader>ws",
      },
      diagnostics = {
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {},
          },
        },
      },
      setup = {}, -- add custom setup functions for servers here
    },
    config = function(_, opts)
      local servers = opts.servers
      local blink = require("blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities(),
        opts.capabilities or {}
      )

      -- Pass opts to the on_attach function to be able to customize keymaps
      Utils.lsp.setup_on_attach(function(client, buf)
        LspConfig.on_attach(client, buf, opts)
        -- handling for custom setup functions
        local server = client.name
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
      end)
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        { "stylua", version = "v0.20.0" },
      })
      require("mason-lspconfig").setup()
      -- This handles automatic installation and updates of configured lsp
      -- severs
      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
        auto_update = true,
      })

      -- override any default config for servers with user options
      -- (handles customized server config in case where custom setup
      -- functions aren't used)
      for server_name, config in pairs(servers) do
        vim.lsp.config(server_name, config)
      end
    end,
  },
}
