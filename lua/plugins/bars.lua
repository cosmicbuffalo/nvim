return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
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
      -- PERF: we don't need this lualine require madness 🤷
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

      -- local utils = require("heirline.utils")
      -- local fg = function(hl_name)
      --   return utils.get_highlight(hl_name).fg
      -- end
      -- local bg = function(hl_name)
      --   return utils.get_highlight(hl_name).bg
      -- end

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
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              -- color = fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              -- color = fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              -- color = fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              -- color = fg("Special"),
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
  -- winbars
  {
    "rebelot/heirline.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-lualine/lualine.nvim",
      {
        "Bekaboo/dropbar.nvim",
        dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
        opts = {
          general = {
            enable = false, -- turn off the automatic attachment behavior since it'll be handled by the component in heirline
          },
          icons = {
            ui = {
              bar = {
                separator = "  ",
                extends = "…",
              },
              menu = {
                separator = " ",
                indicator = " ",
              },
            },
          },
        },
        keys = {
          {
            "<leader>bo",
            function()
              require("dropbar.api").pick()
            end,
            desc = "Dropbar Picker",
          },
        },
      },
    },
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local function get_dropbar_winbar_content()
        return "%{%v:lua.dropbar.get_dropbar_str()%}"
      end

      local FileNameBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      }

      local FileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then
            return "[No Name]"
          end

          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end

          return filename
        end,
      }

      local function h(name)
        return utils.get_highlight(name)
      end

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = " [+]",
          hl = { fg = h("CursorLineNr").fg, bold = true },
        },
        -- {
        --   condtion = function()
        --     return (not vim.bo.modifiable) or vim.bo.readonly
        --   end,
        --   provider = " ",
        --   hl = { fg = h("CursorLineNr").fg },
        -- },
      }

      local FileNameModifier = {
        hl = function()
          if vim.bo.modified then
            return { fg = h("CursorLineNr").fg, bold = true, force = true }
          end

          return { fg = h("Comment").fg }
        end,
      }

      local Align = { provider = "%=" }
      local Space = { provider = " " }

      FileNameBlock =
        utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifier, FileName), FileFlags, { provider = "%<" })

      local InactiveWinbar = {
        condition = function()
          return conditions.is_not_active()
        end,
        {
          -- Align,
          Space,
          FileNameBlock,
          Align,
        },
      }
      -- local component_separators = { left = "", right = "" }
      local section_separators = { left = "", right = "" }
      local mode_names = {
        n = "NORMAL",
        no = "O-PENDING",
        nov = "O-PENDING",
        noV = "O-PENDING",
        ["no\22"] = "O-PENDING",
        niI = "NORMAL",
        niR = "NORMAL",
        niV = "NORMAL",
        nt = "NORMAL",
        v = "VISUAL",
        vs = "VISUAL",
        V = "V-LINE",
        Vs = "V-LINE",
        ["\22"] = "V-BLOCK",
        ["\22s"] = "V-BLOCK",
        s = "SELECT",
        S = "S-LINE",
        ["\19"] = "S-BLOCK",
        i = "INSERT",
        ic = "INSERT",
        ix = "INSERT",
        R = "REPLACE",
        Rc = "REPLACE",
        Rx = "REPLACE",
        Rv = "V-REPLACE",
        Rvc = "V-REPLACE",
        Rvx = "V-REPLACE",
        c = "COMMAND",
        cr = "COMMAND",
        cv = "Ex",
        cvr = "Ex",
        r = "PROMPT",
        rm = "PROMPT",
        ["r?"] = "CONFIRM",
        ["!"] = "!",
        t = "TERMINAL",
      }

      local function setup_colors()
        return {
          bright_bg = utils.get_highlight("Folded").bg,
          bright_fg = utils.get_highlight("Folded").fg,
          red = utils.get_highlight("DiagnosticError").fg,
          dark_red = utils.get_highlight("DiffDelete").bg,
          green = utils.get_highlight("String").fg,
          blue = utils.get_highlight("Function").fg,
          gray = utils.get_highlight("NonText").fg,
          orange = utils.get_highlight("Constant").fg,
          yellow = utils.get_highlight("Todo").bg,
          purple = utils.get_highlight("Statement").fg,
          cyan = utils.get_highlight("Special").fg,
          diag_warn = utils.get_highlight("DiagnosticWarn").fg,
          diag_error = utils.get_highlight("DiagnosticError").fg,
          diag_hint = utils.get_highlight("DiagnosticHint").fg,
          diag_info = utils.get_highlight("DiagnosticInfo").fg,
          git_del = utils.get_highlight("diffDeleted").fg,
          git_add = utils.get_highlight("diffAdded").fg,
          git_change = utils.get_highlight("diffChanged").fg,
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

      local mode_colors = {
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
      }

      local ModeWrapStart = {
        init = function(self)
          self.mode = vim.fn.mode(1)
          self.short_mode = self.mode:sub(1, 1)
        end,
        static = {
          mode_names = mode_names,
          mode_colors = mode_colors,
        },
        {
          provider = " ",
          hl = function(self)
            if conditions.is_not_active() then
              return { bg = "#2d2d30" }
            end
            return { bg = self.mode_colors[self.short_mode] }
          end,
        },
        {
          provider = section_separators.left,
          hl = function(self)
            if conditions.is_not_active() then
              return { fg = "#2d2d30" }
            end
            return { fg = self.mode_colors[self.short_mode] }
          end,
        },
      }

      local ModeWrapEnd = {
        init = function(self)
          self.mode = vim.fn.mode(1)
          self.short_mode = self.mode:sub(1, 1)
        end,
        static = {
          mode_names = mode_names,
          mode_colors = mode_colors,
        },
        {
          provider = section_separators.right,
          hl = function(self)
            if conditions.is_not_active() then
              return { fg = "#2d2d30" }
            end
            return { fg = self.mode_colors[self.short_mode] }
          end,
        },
        {
          provider = " ",
          hl = function(self)
            if conditions.is_not_active() then
              return { bg = "#2d2d30" }
            end
            return { bg = self.mode_colors[self.short_mode] }
          end,
        },
        -- {
        --   provider = function(self)
        --     return self.mode_names[self.mode]
        --   end,
        --   hl = function(self)
        --     return {
        --       fg = colors.black,
        --       bg = self.mode_colors[self.short_mode],
        --       bold = true
        --     }
        --   end
        -- },
        -- {
        --   provider = " ",
        --   hl = function(self)
        --     return { bg = self.mode_colors[self.short_mode] }
        --   end
        -- },
      }

      local ActiveWinbar = {
        condition = function()
          return conditions.is_active()
        end,
        -- hl = {
        --
        --   bg = colors.bright_bg,
        --   force = true,
        -- },
        {
          {
            provider = function()
              return get_dropbar_winbar_content()
            end,
          },

          {
            provider = "%=",
          },
          FileFlags,
          Space,
          -- Mode,
        },
        -- update = {
        --   { "FocusGained", "FocusLost", "WinEnter", "WinLeave", "WinClosed", "WinNew", "WinScrolled", "WinResized" },
        -- },
        -- flexible = true
      }

      local DefaultWinbar = {
        ModeWrapStart,
        ActiveWinbar,
        InactiveWinbar,
        ModeWrapEnd,
      }

      local SpecialWinbar = {
        condition = function()
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix", "trouble", "neo-tree", "oil", "acwrite" },
          })
        end,
      }

      require("heirline").setup({
        winbar = {
          fallthrough = false,
          SpecialWinbar, -- TODO: add special bars for oil, neo-tree, trouble
          DefaultWinbar,
        },
        opts = {
          disable_winbar_cb = function(args)
            return conditions.buffer_matches({
              buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
              filetype = { "^git.*", "fugitive", "Trouble", "dashboard", "neo-tree", "which-key", "lazygit" },
            })
          end,
        },
      })
    end,
  },
}
