return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("lazyvim.config").icons
      vim.o.laststatus = vim.g.lualine_laststatus
      local Util = LazyVim.ui

      local function wordcount()
        return tostring(vim.fn.wordcount().words) .. " words"
      end

      local function readingtime()
        return tostring(math.ceil(vim.fn.wordcount().words / 200.0)) .. " min"
      end

      local function is_markdown()
        return vim.bo.filetype == "markdown" or vim.bo.filetype == "asciidoc"
      end

      local colors = {
        [""] = LazyVim.ui.fg("Special"),
        ["Normal"] = LazyVim.ui.fg("Special"),
        ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
        ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
      }

      return {
        options = {
          theme = "auto",
          globalstatus = false,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {

          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            LazyVim.lualine.root_dir(),
            -- {
            --   require('auto-session.lib').current_session_name
            -- },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            -- { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            { "filename", path = 4 },
            -- { LazyVim.lualine.pretty_path() },
            -- stylua: ignore
            -- {
            --   function() return require("nvim-navic").get_location() end,
            --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            -- },
            -- {
            --   "aerial",
            --   sep = " ", -- separator between symbols
            --   sep_icon = "", -- separator between icon and symbol
            --
            --   -- The number of symbols to render top-down. In order to render only 'N' last
            --   -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
            --   -- be used in order to render only current symbol.
            --   depth = 5,
            --
            --   -- When 'dense' mode is on, icons are not rendered near their symbols. Only
            --   -- a single icon that represents the kind of current symbol is rendered at
            --   -- the beginning of status line.
            --   dense = false,
            --
            --   -- The separator to be used to separate symbols in dense mode.
            --   dense_sep = ".",
            --
            --   -- Color the symbol icons.
            --   colored = true,
            -- }
          },
          lualine_x = {
            -- stylua: ignore
            -- {
            --   require("noice").api.statusline.mode.get,
            --   cond = require("noice").api.statusline.mode.has,
            --   color = Util.fg("Statement"),
            -- },
            -- copilot status
            -- {
            --   function()
            --     local icon = require("lazyvim.config").icons.kinds.Copilot
            --
            --     local status = require("copilot.api").status.data
            --
            --     return icon .. (status.message or "")
            --   end,
            --   cond = function()
            --     if not package.loaded["copilot"] then
            --       return
            --     end
            --     local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
            --     if not ok then
            --       return false
            --     end
            --     return ok and #clients > 0
            --   end,
            --   color = function()
            --     if not package.loaded["copilot"] then
            --       return
            --     end
            --     local status = require("copilot.api").status.data
            --     return colors[status.status] or colors[""]
            --   end,
            -- },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = Util.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              -- separator = ""
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress",  separator = " ",   padding = { left = 1, right = 1 } },
            { wordcount,   cond = is_markdown },
            { readingtime, cond = is_markdown },
          },
          lualine_z = {
            -- function()
            --   return " " .. os.date("%R")
            -- end,
            { "location", padding = { left = 1, right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
}
