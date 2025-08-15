return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "VimEnter",
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
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      local function wordcount()
        return tostring(vim.fn.wordcount().words) .. " words"
      end

      local function readingtime()
        return tostring(math.ceil(vim.fn.wordcount().words / 200.0)) .. " min"
      end

      local function is_markdown()
        return vim.bo.filetype == "markdown" or vim.bo.filetype == "asciidoc"
      end

      return {
        options = {
          theme = "auto",
          -- globalstatus = false,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            -- {
            --   require('auto-session.lib').current_session_name
            -- },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            -- { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            { "filename", path = 4 },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = function() return { fg = Snacks.util.color("Statement") } end,
              -- color = { fg = get_highlight("Statement").fg },
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            -- {
            --   "diagnostics",
            --   symbols = {
            --     error = icons.diagnostics.Error,
            --     warn = icons.diagnostics.Warn,
            --     info = icons.diagnostics.Info,
            --     hint = icons.diagnostics.Hint,
            --   },
            --   -- separator = ""
            -- },
            {
              "diff",
              -- symbols = {
              --   added = icons.git.added,
              --   modified = icons.git.modified,
              --   removed = icons.git.removed,
              -- },
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
            { "progress", separator = " ", padding = { left = 1, right = 1 } },
            { wordcount, cond = is_markdown },
            { readingtime, cond = is_markdown },
          },
          lualine_z = {
            { "location", padding = { left = 1, right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
  -- winbars
  {
    "rebelot/heirline.nvim",
    lazy = false,
    dependencies = {
      "nvim-lualine/lualine.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      winbar_disabled_buftypes = { "nofile", "prompt", "help", "quickfix", "terminal" },
      winbar_disabled_filetypes = { "^git.*", "fugitive", "Trouble", "dashboard", "neo-tree", "which-key", "lazygit" },
      -- toggle this to remove the mode wapper on active winbar
      enable_mode_wrapper = true,
      -- customize mode color assignments here
      -- (defaults are for inkline.nvim)
      mode_colors = {
        n = "blue",
        i = "green",
        v = "purple",
        V = "purple",
        ["\22"] = "purple",
        c = "yellow",
        s = "orange",
        S = "orange",
        ["\19"] = "orange",
        R = "red",
        r = "red",
        ["!"] = "gray",
        t = "gray",
      },
      -- customize heirline color mappings to colorscheme highlights here
      -- (defaults are for inkline.nvim)
      color_highlight_mappings = {
        bright_bg = "Folded",
        bright_fg = "Folded",
        red = "DiagnosticError",
        dark_red = "DiffDelete",
        green = "String",
        blue = "Function",
        gray = "NonText",
        orange = "Constant",
        yellow = "Todo",
        purple = "Statement",
        cyan = "Special",
        diag_warn = "DiagnosticWarn",
        diag_error = "DiagnosticError",
        diag_hint = "DiagnosticHint",
        diag_info = "DiagnosticInfo",
        git_del = "diffDeleted",
        git_add = "diffAdded",
        git_change = "diffChanged",
        modified = "CursorLineNr",
      },
      inactive_color = "#2d2d30",
    },
    config = function(_, opts)
      local heirline_config = require("config.utils.heirline")

            local function setup_colors()
                local h_map = opts.color_highlight_mappings
                local h = heirline_config.get_highlight
                return {
                    bright_bg = h(h_map.bright_bg).bg,
                    bright_fg = h(h_map.bright_fg).fg,
                    red = h(h_map.red).fg,
                    dark_red = h(h_map.dark_red).bg,
                    green = h(h_map.green).fg,
                    blue = h(h_map.blue).fg,
                    gray = h(h_map.gray).fg,
                    orange = h(h_map.orange).fg,
                    yellow = h(h_map.yellow).bg,
                    purple = h(h_map.purple).fg,
                    cyan = h(h_map.cyan).fg,
                    diag_warn = h(h_map.diag_warn).fg,
                    diag_error = h(h_map.diag_error).fg,
                    diag_hint = h(h_map.diag_hint).fg,
                    diag_info = h(h_map.diag_info).fg,
                    git_del = h(h_map.git_del).fg,
                    git_add = h(h_map.git_add).fg,
                    git_change = h(h_map.git_change).fg,
                }
            end
            require("heirline").load_colors(setup_colors)

            vim.api.nvim_create_augroup("Heirline", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    utils.on_colorscheme(setup_colors)
                end,
                group = "Heirline",
            })

            require("heirline").setup({
                winbar = heirline_config.build_winbar(opts),
                opts = heirline_config.build_opts(opts),
            })
        end,
    },
}
