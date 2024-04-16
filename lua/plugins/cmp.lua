return {
  {
    "L3MON4D3/LuaSnip",
    -- enabled = false,
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    -- enabled = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        }),
      })
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping({
          ["<M-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<M-e>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<M-p>"] = cmp.mapping.scroll_docs(-4),
          ["<M-f>"] = cmp.mapping.scroll_docs(4),
          -- ["<M-Space>"] = cmp.mapping.complete(),
          ["<M-o>"] = cmp.mapping.abort(),
          ["<M-i>"] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- disable mappings
          ["<Right>"] = cmp.mapping(function(fallback)
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
          ["<Tab>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
          end, { "i" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("lazyvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
