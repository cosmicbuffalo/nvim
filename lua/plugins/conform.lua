local Utils = require("config.utils")

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
          Utils.format({ force = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
      {
        "<leader>uF",
        function()
          Utils.format.toggle()
        end,
        desc = "Toggle auto formatting",
      },
    },
    init = function()
      Utils.format.register({
        name = "conform.nvim",
        priority = 100,
        primary = true,
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          ---@param v conform.FormatterInfo
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end,
    opts = {
      notify_on_error = true,
      log_level = vim.log.levels.INFO,
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        ruby = { "rubocop" },
        eruby = { "erb_format" },
        go = { "gofumpt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
}
