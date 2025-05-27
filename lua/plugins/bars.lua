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
      {
        "cosmicbuffalo/dropbar.nvim",
        lazy = false,
        opts = {
          menu = {
            -- turn this off to disable dynamic preview on menu movement
            -- dynamic previews can also be toggled per source (see below)
            -- preview = false,
          },
          bar = {
            -- turn off the automatic attachment behavior since it'll be
            -- handled by the component in heirline
            enable = false,
            sources = function(buf, _)
              local utils = require('dropbar.utils')
              local sources = require('dropbar.sources')
              if vim.bo[buf].ft == 'oil' then
                return {
                  sources.path
                }
              end
              if vim.bo[buf].ft == 'markdown' then
                return {
                  sources.path,
                  sources.markdown,
                }
              end
              if vim.bo[buf].buftype == 'terminal' then
                return {
                  sources.terminal,
                }
              end
              return {
                sources.path,
                utils.source.fallback({
                  sources.lsp,
                  -- sources.treesitter,
                }),
              }
            end
          },
          sources = {
            path = {
              -- Preview is turned off by default for the path source
              preview = false,
              -- This customizes the path source for oil buffers
              -- oil buffers will show the path relative to the
              -- git root, if available
              relative_to = function(buf, win)
                local bufname = vim.api.nvim_buf_get_name(buf)
                if vim.startswith(bufname, "oil://") then
                  local full_path = bufname:gsub('^%S+://', '', 1)
                  local git_root = vim.fs.find('.git',
                    { upward = true, path = full_path, type = 'directory' })
                  if git_root and #git_root > 0 then
                    local git_dir = vim.fs.dirname(git_root[1])
                    return vim.fs.dirname(git_dir)
                  end
                end

                local ok, cwd = pcall(vim.fn.getcwd, win)
                return ok and cwd or vim.fn.getcwd()
              end
            },
            lsp = {
              valid_symbols = {
                -- Customize this list to control what can show
                -- up as breadcrumbs in the dropbar winbar
                -- for lsp source
                'Module',
                'Namespace',
                'Class',
                'Method',
                'Function',
                'Constructor',
                'Array',
                'Object',
              }
            },
            treesitter = {
              valid_types = {
                -- TODO: This filtering doesn't actually work
                -- Customize this list to control what can show
                -- up as breadcrumbs in the dropbar winbar for
                -- treesitter source
                'class',
                'constructor',
                'do_statement',
                'function',
                'if_statement',
                'method',
                'namespace',
                'table',
                'type',
                'object',
              }
            }
          },
          icons = {
            -- Icons for dropbar can be customized here
            ui = {
              bar = {
                -- separator = " > ",
                separator = "  ",
                extends = "…",
              },
              menu = {
                -- indicator = "> ",
                indicator = " ",
                separator = " ",
              },
            },
          },
        },
        keys = {
          {
            "<leader>bo",
            function() require("dropbar.api").pick() end,
            desc = "Drop[b]ar - [O]pen Picker",
          },
        },
      },
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
        keys = {
            {
                "<leader>uW",
                function()
                    require("heirline_config").toggle_winbar()
                end,
                desc = "Toggle [U]I [W]inbar",
            }
        }
    },
  -- {
  --   "rebelot/heirline.nvim",
  --   lazy=false,
  --   dependencies = {
  --     "nvim-lualine/lualine.nvim",
  --     {
  --       "Bekaboo/dropbar.nvim",
  --       lazy = false,
  --       dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
  --       opts = {
  --         bar = {
  --           enable = false, -- turn off the automatic attachment behavior since it'll be handled by the component in heirline
  --           sources = function(buf, _)
  --             local sources = require('dropbar.sources')
  --             local utils = require('dropbar.utils')
  --             if vim.bo[buf].ft == 'oil' then
  --               return {
  --                 sources.path
  --               }
  --             end
  --             if vim.bo[buf].ft == 'markdown' then
  --               return {
  --                 sources.path,
  --                 sources.markdown,
  --               }
  --             end
  --             if vim.bo[buf].buftype == 'terminal' then
  --               return {
  --                 sources.terminal,
  --               }
  --             end
  --             return {
  --               sources.path,
  --               utils.source.fallback({
  --                 sources.lsp,
  --                 sources.treesitter,
  --               }),
  --             }
  --           end
  --         },
  --         icons = {
  --           ui = {
  --             bar = {
  --               separator = "  ",
  --               extends = "…",
  --             },
  --             menu = {
  --               separator = " ",
  --               indicator = " ",
  --             },
  --           },
  --         },
  --         sources = {
  --           path = {
  --             -- relative_to = function(buf, win)
  --             --   -- Show full path in oil buffers
  --             --   local bufname = vim.api.nvim_buf_get_name(buf)
  --             --   if vim.startswith(bufname, 'oil://') then
  --             --     local root = bufname:gsub('^S+://', '', 1)
  --             --     while root and root ~= vim.fs.dirname(root) do
  --             --       root = vim.fs.dirname(root)
  --             --     end
  --             --     return root
  --             --   end
  --             --
  --             --   local ok, cwd = pcall(vim.fn.getcwd, win)
  --             --   return ok and cwd or vim.fn.getcwd()
  --             -- end,
  --           }
  --         }
  --       },
  --       keys = {
  --         {
  --           "<leader>bo",
  --           function()
  --             require("dropbar.api").pick()
  --           end,
  --           desc = "Dropbar Picker",
  --         },
  --       },
  --     },
  --   },
  --   config = function()
  --     local conditions = require("heirline.conditions")
  --     local utils = require("heirline.utils")
  --
  --     local function get_dropbar_winbar_content()
  --       return "%{%v:lua.dropbar()%}"
  --     end
  --
  --     local FileNameBlock = {
  --       init = function(self)
  --         self.filename = vim.api.nvim_buf_get_name(0)
  --             --   local bufname = vim.api.nvim_buf_get_name(buf)
  --             --   if vim.startswith(bufname, 'oil://') then
  --       end,
  --     }
  --
  --     local FileIcon = {
  --       init = function(self)
  --         local filename = self.filename
  --         local extension = vim.fn.fnamemodify(filename, ":e")
  --         self.icon, self.icon_color =
  --           require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  --       end,
  --       provider = function(self)
  --         return self.icon and (self.icon .. " ")
  --       end,
  --       hl = function(self)
  --         return { fg = self.icon_color }
  --       end,
  --     }
  --
  --     local FileName = {
  --       provider = function(self)
  --         local filename = vim.fn.fnamemodify(self.filename, ":.")
  --         if filename == "" then
  --           return "[No Name]"
  --         end
  --
  --         if not conditions.width_percent_below(#filename, 0.25) then
  --           filename = vim.fn.pathshorten(filename)
  --         end
  --
  --         return filename
  --       end,
  --     }
  --
  --     local function h(name)
  --       return utils.get_highlight(name)
  --     end
  --
  --     local FileFlags = {
  --       {
  --         condition = function()
  --           return vim.bo.modified
  --         end,
  --         provider = " [+]",
  --         hl = { fg = h("CursorLineNr").fg, bold = true },
  --       },
  --       -- {
  --       --   condtion = function()
  --       --     return (not vim.bo.modifiable) or vim.bo.readonly
  --       --   end,
  --       --   provider = " ",
  --       --   hl = { fg = h("CursorLineNr").fg },
  --       -- },
  --     }
  --
  --     local FileNameModifier = {
  --       hl = function()
  --         if vim.bo.modified then
  --           return { fg = h("CursorLineNr").fg, bold = true, force = true }
  --         end
  --
  --         return { fg = h("Comment").fg }
  --       end,
  --     }
  --
  --     local Align = { provider = "%=" }
  --     local Space = { provider = " " }
  --
  --     FileNameBlock =
  --       utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifier, FileName), FileFlags, { provider = "%<" })
  --
  --     local InactiveWinbar = {
  --       condition = function()
  --         return conditions.is_not_active()
  --       end,
  --       {
  --         -- Align,
  --         Space,
  --         FileNameBlock,
  --         Align,
  --       },
  --     }
  --     -- local component_separators = { left = "", right = "" }
  --     local section_separators = { left = "", right = "" }
  --     local mode_names = {
  --       n = "NORMAL",
  --       no = "O-PENDING",
  --       nov = "O-PENDING",
  --       noV = "O-PENDING",
  --       ["no\22"] = "O-PENDING",
  --       niI = "NORMAL",
  --       niR = "NORMAL",
  --       niV = "NORMAL",
  --       nt = "NORMAL",
  --       v = "VISUAL",
  --       vs = "VISUAL",
  --       V = "V-LINE",
  --       Vs = "V-LINE",
  --       ["\22"] = "V-BLOCK",
  --       ["\22s"] = "V-BLOCK",
  --       s = "SELECT",
  --       S = "S-LINE",
  --       ["\19"] = "S-BLOCK",
  --       i = "INSERT",
  --       ic = "INSERT",
  --       ix = "INSERT",
  --       R = "REPLACE",
  --       Rc = "REPLACE",
  --       Rx = "REPLACE",
  --       Rv = "V-REPLACE",
  --       Rvc = "V-REPLACE",
  --       Rvx = "V-REPLACE",
  --       c = "COMMAND",
  --       cr = "COMMAND",
  --       cv = "Ex",
  --       cvr = "Ex",
  --       r = "PROMPT",
  --       rm = "PROMPT",
  --       ["r?"] = "CONFIRM",
  --       ["!"] = "!",
  --       t = "TERMINAL",
  --     }
  --
  --     local function setup_colors()
  --       return {
  --         bright_bg = utils.get_highlight("Folded").bg,
  --         bright_fg = utils.get_highlight("Folded").fg,
  --         red = utils.get_highlight("DiagnosticError").fg,
  --         dark_red = utils.get_highlight("DiffDelete").bg,
  --         green = utils.get_highlight("String").fg,
  --         blue = utils.get_highlight("Function").fg,
  --         gray = utils.get_highlight("NonText").fg,
  --         orange = utils.get_highlight("Constant").fg,
  --         yellow = utils.get_highlight("Todo").bg,
  --         purple = utils.get_highlight("Statement").fg,
  --         cyan = utils.get_highlight("Special").fg,
  --         diag_warn = utils.get_highlight("DiagnosticWarn").fg,
  --         diag_error = utils.get_highlight("DiagnosticError").fg,
  --         diag_hint = utils.get_highlight("DiagnosticHint").fg,
  --         diag_info = utils.get_highlight("DiagnosticInfo").fg,
  --         git_del = utils.get_highlight("diffDeleted").fg,
  --         git_add = utils.get_highlight("diffAdded").fg,
  --         git_change = utils.get_highlight("diffChanged").fg,
  --       }
  --     end
  --     require("heirline").load_colors(setup_colors)
  --
  --     vim.api.nvim_create_augroup("Heirline", { clear = true })
  --     vim.api.nvim_create_autocmd("ColorScheme", {
  --       callback = function()
  --         utils.on_colorscheme(setup_colors)
  --       end,
  --       group = "Heirline",
  --     })
  --
  --     local mode_colors = {
  --       n = "blue",
  --       i = "green",
  --       v = "purple",
  --       V = "purple",
  --       ["\22"] = "purple",
  --       c = "yellow",
  --       s = "orange",
  --       S = "orange",
  --       ["\19"] = "orange",
  --       R = "red",
  --       r = "red",
  --       ["!"] = "gray",
  --       t = "gray",
  --     }
  --
  --     local ModeWrapStart = {
  --       init = function(self)
  --         self.mode = vim.fn.mode(1)
  --         self.short_mode = self.mode:sub(1, 1)
  --       end,
  --       static = {
  --         mode_names = mode_names,
  --         mode_colors = mode_colors,
  --       },
  --       {
  --         provider = " ",
  --         hl = function(self)
  --           if conditions.is_not_active() then
  --             return { bg = "#2d2d30" }
  --           end
  --           return { bg = self.mode_colors[self.short_mode] }
  --         end,
  --       },
  --       {
  --         provider = section_separators.left,
  --         hl = function(self)
  --           if conditions.is_not_active() then
  --             return { fg = "#2d2d30" }
  --           end
  --           return { fg = self.mode_colors[self.short_mode] }
  --         end,
  --       },
  --     }
  --
  --     local ModeWrapEnd = {
  --       init = function(self)
  --         self.mode = vim.fn.mode(1)
  --         self.short_mode = self.mode:sub(1, 1)
  --       end,
  --       static = {
  --         mode_names = mode_names,
  --         mode_colors = mode_colors,
  --       },
  --       {
  --         provider = section_separators.right,
  --         hl = function(self)
  --           if conditions.is_not_active() then
  --             return { fg = "#2d2d30" }
  --           end
  --           return { fg = self.mode_colors[self.short_mode] }
  --         end,
  --       },
  --       {
  --         provider = " ",
  --         hl = function(self)
  --           if conditions.is_not_active() then
  --             return { bg = "#2d2d30" }
  --           end
  --           return { bg = self.mode_colors[self.short_mode] }
  --         end,
  --       },
  --     }
  --
  --     local ActiveWinbar = {
  --       condition = function()
  --         return conditions.is_active()
  --       end,
  --       -- hl = {
  --       --
  --       --   bg = colors.bright_bg,
  --       --   force = true,
  --       -- },
  --       {
  --         {
  --           provider = function()
  --             return get_dropbar_winbar_content()
  --           end,
  --         },
  --
  --         {
  --           provider = "%=",
  --         },
  --         FileFlags,
  --         Space,
  --         -- Mode,
  --       },
  --       -- update = {
  --       --   { "FocusGained", "FocusLost", "WinEnter", "WinLeave", "WinClosed", "WinNew", "WinScrolled", "WinResized" },
  --       -- },
  --       -- flexible = true
  --     }
  --
  --     local DefaultWinbar = {
  --       ModeWrapStart,
  --       ActiveWinbar,
  --       InactiveWinbar,
  --       ModeWrapEnd,
  --     }
  --
  --     local SpecialWinbar = {
  --       condition = function()
  --         return conditions.buffer_matches({
  --           buftype = { "nofile", "prompt", "help", "quickfix", "trouble", "neo-tree" },
  --         })
  --       end,
  --     }
  --
  --     require("heirline").setup({
  --       winbar = {
  --         fallthrough = false,
  --         SpecialWinbar,
  --         DefaultWinbar,
  --       },
  --       opts = {
  --         disable_winbar_cb = function(args)
  --           return conditions.buffer_matches({
  --             buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
  --             filetype = { "^git.*", "fugitive", "Trouble", "dashboard", "neo-tree", "which-key", "lazygit" },
  --           })
  --         end,
  --       },
  --     })
  --   end,
  -- },
}
