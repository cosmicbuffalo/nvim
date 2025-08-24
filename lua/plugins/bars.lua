local Utils = require("config.utils")
return {

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        opts = {
          override_by_filename = {
            ["rakefile"] = {
              icon = "",
              color = "#ff4f3f",
              cterm_color = "52",
              name = "Rakefile",
            },
            ["Gemfile"] = {
              icon = "",
              color = "#ff4f3f",
              cterm_color = "52",
              name = "Rakefile",
            },
          },
          override_by_extension = {
            ["config.ru"] = {
              icon = "",
              color = "#ff4f3f",
              cterm_color = "52",
              name = "ConfigRu",
            },
            ["rb"] = {
              icon = "",
              color = "#ff4f3f",
              cterm_color = "52",
              name = "Rb",
            },
          },
        },
      },
      "AndreM222/copilot-lualine",
    },
    opts = function()
      -- NOTE: This isn't personalizable without duplicating the entire function
      local utils = require("lualine.utils.utils")
      local highlight = require("lualine.highlight")
      local conf = require("lualine").get_config()
      local diagnostics_message = require("lualine.component"):extend()

      diagnostics_message.default = {
        colors = {
          error = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticError" }, "#e32636"),
          warning = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticWarn" }, "#ffa500"),
          info = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticInfo" }, "#ffffff"),
          hint = utils.extract_color_from_hllist({ "fg", "sp" }, { "DiagnosticHint" }, "#273faf"),
        },
      }
      function diagnostics_message:init(options)
        diagnostics_message.super:init(options)
        self.options.colors = vim.tbl_extend("force", diagnostics_message.default.colors, self.options.colors or {})
        self.highlights = { error = "", warn = "", info = "", hint = "" }
        self.highlights.error = highlight.create_component_highlight_group(
          { fg = self.options.colors.error },
          "diagnostics_message_error",
          self.options
        )
        self.highlights.warn = highlight.create_component_highlight_group(
          { fg = self.options.colors.warn },
          "diagnostics_message_warn",
          self.options
        )
        self.highlights.info = highlight.create_component_highlight_group(
          { fg = self.options.colors.info },
          "diagnostics_message_info",
          self.options
        )
        self.highlights.hint = highlight.create_component_highlight_group(
          { fg = self.options.colors.hint },
          "diagnostics_message_hint",
          self.options
        )
      end

      function diagnostics_message:update_status(_is_focused)
        local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
        local diagnostics = vim.diagnostic.get(0, { lnum = r - 1 })
        if #diagnostics > 0 then
          table.sort(diagnostics, function(a, b)
            if a.col == b.col then
              return a.severity < b.severity
            else
              return a.col < b.col
            end
          end)

          local icons = { "󰅚 ", "󰀪 ", "󰋽 ", "󰌶 " }
          local hl = { self.highlights.error, self.highlights.warn, self.highlights.info, self.highlights.hint }

          local messages = {}
          for _, diag in ipairs(diagnostics) do
            -- Take only the first line of multi-line diagnostic messages
            local first_line = diag.message:match("^[^\r\n]*")
            local msg = icons[diag.severity] .. (diag.col + 1) .. ": " .. first_line
            table.insert(messages, msg)
          end

          -- Use the most severe diagnostic's highlight for the entire string
          local most_severe = diagnostics[1]
          return highlight.component_format_highlight(hl[most_severe.severity]) .. table.concat(messages, "  ")
        else
          return ""
        end
      end

      local new_conf = vim.tbl_deep_extend("force", conf, {
        theme = "inkline",
        sections = {
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              separator = { right = "" },
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              path = 1,
              separator = { left = "" },
              padding = { left = 0 },
            },
            {
              diagnostics_message,
              colors = {
                error = "#e32636",
                warn = "#ffa500",
                -- info = "#ffffff",
                -- hint = "#273faf",
              },
              fmt = function(str)
                local max_width = vim.o.columns - 80
                if #str > max_width then
                  return str:sub(1, max_width - 3) .. "..."
                end
                return str
              end,
            },
          },
          lualine_x = {
            {
              function()
                local ok, noice = pcall(require, "noice")
                if ok then
                  return noice.api.status.command.get()
                end
                return ""
              end,
              cond = function()
                local ok, noice = pcall(require, "noice")
                return ok and noice.api.status.command.has()
              end,
              color = { fg = "#ff9e64" },
            },
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg == "" then
                  return ""
                else
                  return "recording @" .. reg
                end
              end,
              color = { fg = "yellow" },
            },
            {
              "searchcount",
              color = { fg = "cyan" },
            },
            {
              "copilot",
              padding = { left = 1, right = 0 },
            },
            -- "lsp_status"
          },
        },
      })

      return new_conf
    end,
  },
  {
    "rebelot/heirline.nvim",
    lazy = false,
    dependencies = {
      "nvim-lualine/lualine.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "Bekaboo/dropbar.nvim",
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
              local utils = require("dropbar.utils")
              local sources = require("dropbar.sources")
              if vim.bo[buf].ft == "oil" then
                return {
                  sources.path,
                }
              end
              if vim.bo[buf].ft == "markdown" then
                return {
                  sources.path,
                  sources.markdown,
                }
              end
              if vim.bo[buf].buftype == "terminal" then
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
            end,
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
                  local full_path = bufname:gsub("^%S+://", "", 1)
                  local git_root = vim.fs.find(".git", { upward = true, path = full_path, type = "directory" })
                  if git_root and #git_root > 0 then
                    local git_dir = vim.fs.dirname(git_root[1])
                    return vim.fs.dirname(git_dir)
                  end
                end

                local ok, cwd = pcall(vim.fn.getcwd, win)
                return ok and cwd or vim.fn.getcwd()
              end,
            },
            lsp = {
              valid_symbols = {
                -- Customize this list to control what can show
                -- up as breadcrumbs in the dropbar winbar
                -- for lsp source
                "Module",
                "Namespace",
                "Class",
                "Method",
                "Function",
                "Constructor",
                "Array",
                "Object",
              },
            },
            treesitter = {
              valid_types = {
                -- TODO: This filtering doesn't actually work
                -- Customize this list to control what can show
                -- up as breadcrumbs in the dropbar winbar for
                -- treesitter source
                "class",
                "constructor",
                "do_statement",
                "function",
                "if_statement",
                "method",
                "namespace",
                "table",
                "type",
                "object",
              },
            },
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
            function()
              require("dropbar.api").pick()
            end,
            desc = "Drop[b]ar - [O]pen Picker",
          },
        },
      },
    },
    opts = {
      winbar_disabled_buftypes = { "nofile", "prompt", "help", "quickfix", "terminal" },
      winbar_disabled_filetypes = {
        "^git.*",
        "fugitive",
        "Trouble",
        "dashboard",
        "neo-tree",
        "which-key",
        "lazygit",
      },
      -- toggle this to remove the mode wapper on active winbar
      enable_mode_wrapper = true,
      -- customize mode color assignments here
      -- (settings for inkline or tokyonight are automatically applied)
      mode_colors = Utils.colors.get_mode_colors,
      -- customize heirline color mappings to colorscheme highlights here
      -- (settings for inkline or tokyonight are automatically applied)
      color_highlight_mappings = Utils.colors.get_highlight_mappings,
      inactive_color = "#1e2124",
    },
    config = function(_, opts)
      local heirline_config = require("config.heirline")
      local setup_colors = function()
        return Utils.colors.setup_heirline_colors(opts)
      end
      require("heirline").load_colors(setup_colors)

      vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local utils = require("heirline.utils")
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
          require("config.heirline").toggle_winbar()
        end,
        desc = "Toggle [U]I [W]inbar",
      },
    },
  },
}
