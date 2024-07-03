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

      -- local icons = require("lazyvim.config").icons
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
            -- LazyVim.lualine.root_dir(),
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
            --   color = fg("Statement"),
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
    dependencies = {
      "nvim-lualine/lualine.nvim",
      {
        "Bekaboo/dropbar.nvim",
        dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
        opts = {
          general = {
            enable = false,
          },
        },
      },
    },
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local colors = require("tokyonight.colors").setup()

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

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = " [+]",
          hl = { fg = colors.orange, bold = true },
        },
        -- {
        --   condtion = function()
        --     return (not vim.bo.modifiable) or vim.bo.readonly
        --   end,
        --   provider = " ",
        --   hl = { fg = "orange" },
        -- },
      }

      local FileNameModifier = {
        hl = function()
          if vim.bo.modified then
            return { fg = colors.orange, bold = true, force = true }
          end
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
      local mode_colors = {
        n = colors.blue,
        i = colors.green,
        v = colors.magenta,
        V = colors.magenta,
        ["\22"] = colors.magenta,
        c = colors.yellow,
        s = colors.teal,
        S = colors.teal,
        ["\19"] = colors.teal,
        R = colors.red,
        r = colors.red,
        ["!"] = colors.yellow,
        t = colors.bg_highlight,
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
