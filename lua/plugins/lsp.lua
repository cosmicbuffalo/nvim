return {
  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = false,
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

      -- LazyVim.format.register(LazyVim.lsp.formatter())
      -- stylua: ignore
      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>ci", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, vim.tbl_deep_extend("force", opts, { desc = "Goto Definition" }))
        -- { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, vim.tbl_deep_extend("force", opts, { desc = "Goto Declaration" }))
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, vim.tbl_deep_extend("force", opts, { desc = "Goto Reference" }))
        -- { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
        -- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        -- { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },

        vim.keymap.set("n", "<leader>cT", function() require('copilot.suggestion').toggle_auto_trigger() end, vim.tbl_deep_extend("force", opts, { desc = "Toggle Copilot" }))
        vim.keymap.set("n", "<leader>cS", function() vim.lsp.buf.workspace_symbol() end, vim.tbl_deep_extend("force", opts, { desc = "Workspace Symbol" }))
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
          ruby_lsp = function()
            require("lspconfig").ruby_lsp.setup({
              settings = {
                rubyLsp = {
                  featuresConfiguration = {
                    inlayHint = {
                      enableAll = true,
                    },
                  },
                },
              },
            })
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
          -- override mappings
          ["<Right>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
          ["<Left>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
          ["<Down>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
          ["<Up>"] = cmp.mapping(function(fallback)
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
          -- format = function(_, item)
          --   local icons = require("lazyvim.config").icons.kinds
          --   if icons[item.kind] then
          --     item.kind = icons[item.kind] .. item.kind
          --   end
          --   return item
          -- end,
        },
      })
    end,
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = { "LspAttach", "ColorScheme" },
    config = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      local function reset_highlights()
        -- hl-groups can have any name
        vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
        vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
        vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
        vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
        vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })
      end

      local function text_format(symbol)
        local res = {}

        local round_start = { "", "SymbolUsageRounding" }
        local round_end = { "", "SymbolUsageRounding" }

        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, round_start)
          table.insert(res, { "󰌹 ", "SymbolUsageRef" })
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰳽 ", "SymbolUsageDef" })
          table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
          table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if stacked_functions_content ~= "" then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { " ", "SymbolUsageImpl" })
          table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        return res
      end

      require("symbol-usage").setup({
        text_format = text_format,
        request_pending_text = false,
        vt_position = "end_of_line",
        vt_priority = 100,
        disable = {
          filetypes = { "markdown", "ruby" },
        },
      })
      reset_highlights()

      vim.keymap.set("n", "<leader>uu", function()
        require("symbol-usage").toggle_globally()
        require("symbol-usage").refresh()
        reset_highlights()
      end, { desc = "Toggle Symbol Usage" })

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = reset_highlights
      })
    end,
  },
  -- symbol outline viewer
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>co", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    opts = {
      outline_window = {
        -- show_numbers = false, -- these don't work
        -- show_relative_numbers = false, -- these don't work
        auto_close = false,
        auto_jump = true,
      },
      -- outline_items = {
      --   show_symbol_lineno = true
      -- }
    },
  },
}
