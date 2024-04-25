return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",

    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      {
        "williamboman/mason.nvim",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      {
        "L3MON4D3/LuaSnip",
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        -- stylua: ignore
        -- keys = {
        --   {
        --     "<tab>",
        --     function()
        --       return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        --     end,
        --     expr = true, silent = true, mode = "i",
        --   },
        --   { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
        --   { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        -- },
      },
      { "rafamadriz/friendly-snippets" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = {
            markdown = false,
            help = false,
          },
        },
      },
      { "zbirenbaum/copilot-cmp", dependencies = "copilot.lua" },
    },
    config = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local lsp = require("lsp-zero")

      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup({})

      LazyVim.format.register(LazyVim.lsp.formatter())
      -- stylua: ignore
      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, vim.tbl_deep_extend("force", opts, { desc = "Goto Definition" }))
        -- { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, vim.tbl_deep_extend("force", opts, { desc = "Goto Declaration" }))
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, vim.tbl_deep_extend("force", opts, { desc = "Goto Reference" }))
        -- { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
        -- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        -- { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },

        vim.keymap.set("n", "<leader>ct", function() require('copilot.suggestion').toggle_auto_trigger() end, vim.tbl_deep_extend("force", opts, { desc = "Toggle Copilot" }))
        vim.keymap.set("n", "<leader>cs", function() vim.lsp.buf.workspace_symbol() end, vim.tbl_deep_extend("force", opts, { desc = "Workspace Symbol" }))
        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", function() vim.lsp.buf.code_action() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }))
        vim.keymap.set({ "n", "v" }, "<leader>cA", function() vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } }) end, vim.tbl_deep_extend("force", opts, { desc = "LSP Source Action" }))
        -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, vim.tbl_deep_extend("force", opts, { desc = "LSP References" }))
        vim.keymap.set("n", "<leader>cr", function() vim.lsp.buf.rename() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }))

        vim.keymap.set("n", "<leader>xd", function() vim.diagnostic.setloclist() end, vim.tbl_deep_extend("force", opts, { desc = "Show Diagnostics" }))
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, vim.tbl_deep_extend("force", opts, { desc = "Next Diagnostic" }))
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, vim.tbl_deep_extend("force", opts, { desc = "Previous Diagnostic" }))

        local diagnostic_goto = function(next, severity)
          local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
          severity = severity and vim.diagnostic.severity[severity] or nil
          return function()
            go({ severity = severity })
          end
        end
        vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
        vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
        vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
        vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
        vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
        vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

        vim.keymap.set({ "n", "v" }, "<leader>cc", function() vim.lsp.codelens.run() end, vim.tbl_deep_extend("force", opts, { desc = "Run Codelens" }))
        vim.keymap.set("n", "<leader>cC", function() vim.lsp.codelens.refresh() end, vim.tbl_deep_extend("force", opts, { desc = "Refresh & Display Codelens" }))

        if client.name == "copilot" then
          copilot_cmp._on_insert_enter({})
        end
      end)

      require("mason").setup({})
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      require("mason-lspconfig").setup({
        ensure_installed = {
          "tsserver",
          "eslint",
          "lua_ls",
          "jsonls",
          "html",
          "bashls",
          "marksman",
          "solargraph",
        },
        handlers = {
          lsp.default_setup,
          lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })

      local cmp_action = require("lsp-zero").cmp_action()
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      require("luasnip.loaders.from_vscode").lazy_load()

      -- autopair completion handling
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          -- custom mappings
          ["<M-n>"] = { c = cmp.mapping.select_next_item(cmp_select) },
          ["<M-e>"] = { c = cmp.mapping.select_prev_item(cmp_select) },
          ["<M-i>"] = { c = cmp.mapping.confirm({ select = true }) },
          ["<M-o>"] = { c = cmp.mapping.abort() },
        }),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          -- custom mappings
          ["<M-n>"] = { c = cmp.mapping.select_next_item(cmp_select) },
          ["<M-e>"] = { c = cmp.mapping.select_prev_item(cmp_select) },
          ["<M-i>"] = { c = cmp.mapping.confirm({ select = true }) },
          ["<M-o>"] = { c = cmp.mapping.abort() },
          ["<M-p>"] = { c = cmp.mapping.scroll_docs(-4) },
          ["<M-f>"] = { c = cmp.mapping.scroll_docs(4) },
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "copilot", group_index = 1, priority = 100 },
          { name = "nvim_lsp" },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          -- default mappings
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          -- custom mappings
          ["<M-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<M-e>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<M-i>"] = cmp.mapping.confirm({ select = true }),
          ["<M-o>"] = cmp.mapping.abort(),
          ["<M-p>"] = cmp.mapping.scroll_docs(-4),
          ["<M-f>"] = cmp.mapping.scroll_docs(4),
          ["<Right>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
          ["<Left>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
          -- snippet mappings
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
          ["<Tab>"] = cmp_action.luasnip_supertab(),
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        formatting = {
          format = function(_, item)
            local icons = require("lazyvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
      })
    end,
  },
}
