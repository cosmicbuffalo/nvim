return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = function()
      local opts = {
        format = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_fallback = true, -- not recommended to change
        },
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          javascript = { { "prettierd", "prettier"} },
          ruby = { "rubocop" }

        },
        formatters = {
          injected = { options = { ignore_errors = true } },
        },
      }
      return opts
    end,
  },
}
