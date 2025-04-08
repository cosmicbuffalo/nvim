return {
  -- Fuzzy finder.
  -- The default key bindings to find files will use Telescope's
  -- `find_files` or `git_files` depending on whether the
  -- directory is a git repo.
  {
    "nvim-telescope/telescope.nvim",
    enabled = true,
    cmd = "Telescope",
    tag = "0.1.8",
    lazy = false,
    -- priority = 500,
    -- version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "debugloop/telescope-undo.nvim",
      "jemag/telescope-diff.nvim",
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      },

      -- {
      --   "nvim-telescope/telescope-frecency.nvim",
      --   config = function()
      --     require("telescope").load_extension("frecency")
      --   end,
      --   dependencies = {
      --     "kkharji/sqlite.lua",
      --   },
      -- },
    },
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
      -- find
      { "<leader>bf", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Find" },
      {
        "<leader>fc",
        [[lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath("config")})]],
        desc = "Config files",
      },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
      -- colorscheme picker
      { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with Preview" },
      -- plugin files
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      -- ruby gems
      {
        "<leader>fG",
        function()
          local function get_ruby_gems_directory()
            local command = "gem env gemdir"
            local handle = io.popen(command, "r") -- Run the command and open for reading
            if handle == nil then
              vim.notify("Failed to run command: " .. command)
              return nil
            end
            local gem_dir = handle:read("*a") -- Read the entire output
            handle:close()

            -- Trim any trailing whitespace or new lines
            gem_dir = string.gsub(gem_dir, "^%s*(.-)%s*$", "%1")

            if gem_dir == "" then
              vim.notify("No gems directory found.")
              return nil
            end

            return gem_dir .. "/gems"
          end
          local gem_dir = get_ruby_gems_directory()
          if gem_dir == nil then
            vim.notify("Failed to find Ruby gems directory.")
          end
          require("telescope.builtin").find_files({ cwd = gem_dir })
        end,
        desc = "Find Ruby Gem File",
      },
      -- help tags
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find help tags",
        silent = true,
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--no-ignore",
              "-g",
              "!{.git,node_modules,redux_devtools,tmp,vendor}",
            },
          })
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({
            attach_mappings = function(prompt_bufnr, map)
              local action_state = require("telescope.actions.state")
              local bd = require("mini.bufremove").delete
              local delete_buffer = function()
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                current_picker:delete_selection(function(selection)
                  local bufnr = selection.bufnr
                  local force = vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal"
                  if force then
                    return pcall(vim.api.nvim_buf_delete, bufnr, { force = force })
                  elseif vim.fn.getbufvar(bufnr, "&modified") == 1 then
                    local choice =
                      vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)), "&Yes\n&No\n&Cancel")
                    if choice == 1 then -- Yes
                      vim.api.nvim_buf_call(bufnr, function()
                        vim.cmd("write")
                      end)
                      return bd(bufnr)
                    elseif choice == 2 then -- No
                      return bd(bufnr, true)
                    end
                  else
                    return bd(bufnr)
                  end
                end)
              end
              map("n", "<c-x>", delete_buffer)
              map("i", "<c-x>", delete_buffer)
              return true
            end,
          })
        end,
        desc = "Buffers",
      },
      {
        "<leader>fd",
        function()
          require("telescope").extensions.diff.diff_current({ hidden = true })
        end,
        desc = "Diff with current file",
      },
      {
        "<leader>sg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Grep (args)",
      },
      {
        "<leader>sw",
        function()
          require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
        end,
        desc = "Grep word under cursor (args)",
      },
      {
        "<leader>sw",
        function()
          require("telescope-live-grep-args.shortcuts").grep_visual_selection()
        end,
        mode = "v",
        desc = "Grep selection (args)",
      },
    },
    config = function(opts)
      function ShortenDirStrings(str)
        return str
          :gsub("integration", "int")
          :gsub("implementation", "impl")
          :gsub("features", "feat")
          :gsub("platform", "plat")
          :gsub("servicing", "serv")
          :gsub("application_lifecycle", "life")
          :gsub("application_workflows", "wkfl")
          :gsub("underwriter_external_communication", "uwcom")
          :gsub("cannabis", "cann")
          :gsub("lessors_risk_only", "lro")
          :gsub("commercial_lessors_risk", "clr")
          :gsub("artisan_contractors", "arc")
          :gsub("builders_risk", "bldr")
      end
      local lga_actions = require("telescope-live-grep-args.actions")

      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end

      local select_dir_for_grep = function(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local fb = require("telescope").extensions.file_browser
        local lga = require("telescope").extensions.live_grep_args
        local current_line = action_state.get_current_line()

        fb.file_browser({
          files = false,
          depth = false,
          attach_mappings = function(prompt_bufnr)
            require("telescope.actions").select_default:replace(function()
              local entry_path = action_state.get_selected_entry().Path
              local dir = entry_path:is_dir() and entry_path or entry_path:parent()
              local relative = dir:make_relative(vim.fn.getcwd())
              local absolute = dir:absolute()

              lga.live_grep_args({
                results_title = relative .. "/",
                cwd = absolute,
                default_text = current_line,
              })
            end)

            return true
          end,
        })
      end
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- border = false,
          -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          borderchars = { "▄", "▌", "▀", "▐", "▗", "▖", "▘", "▝" },
          -- borderchars =    { "▄", "",  "",  "▐",  "▗", "▖", "",  "" },
          -- borderchars = { "", "", "", "", "", "", "", "" },
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          layout_config = {
            height = 0.95,
            width = 0.95,
            horizontal = {
              prompt_position = "top",
              preview_width = 0.6,
            },
            vertical = {
              prompt_position = "top",
              mirror = true,
            },
          },
          path_display = function(opts, path)
            local function url_decode(str)
              str = str:gsub("%%(%x%x)", function(hex)
                return string.char(tonumber(hex, 16))
              end)
              return str
            end
            local decoded_path = url_decode(path)
            local file = require("telescope.utils").path_tail(decoded_path)

            local path_without_file = decoded_path:gsub(file .. "$", ""):gsub("^/Users/[^/]+/", "~/")
            -- if string.find(path_without_file, "^app/") or string.find(path_without_file, "^config/") then
            --   return string.format("%s (%s)", file, path_without_file:gsub("/$", ""))
            -- else
            local dir = require("telescope.utils").path_tail(path_without_file:gsub("/$", ""))
            if dir == "" or dir == file then
              return string.format("%s", file)
            end

            -- local git_dir = vim.fn.finddir(".git", ".;")
            -- if git_dir and #git_dir > 0 then
            --   local rel_path = decoded_path:sub(#git_dir):gsub(dir .. "/" .. file .. "$", "")
            --   return string.format("%s/%s (.%s)", dir, file, rel_path)
            -- end

            -- local rel_path = decoded_path:sub(#cwd):gsub(dir .. "/" .. file .. "$", "")
            local rel_path = path_without_file:gsub(dir .. "/$", "")
            if rel_path == "" then
              return string.format("%s/%s", dir, file)
            end
            return string.format("%s/%s (%s)", ShortenDirStrings(dir), file, ShortenDirStrings(rel_path:gsub("/$", "")))
            -- end
          end,
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              -- ["<c-t>"] = open_with_trouble,
              -- ["<a-t>"] = open_selected_with_trouble,
              -- ["<a-i>"] = find_files_no_ignore,
              -- ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              -- ["<a-i>"] = find_files_no_ignore,
              -- ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },

          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-t>"] = select_dir_for_grep,
              },
            },
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("diff")
      require("telescope").load_extension("undo")
      require("telescope").load_extension("ui-select")
      vim.cmd([[
        highlight TelescopeBorder guifg=#282828
        highlight TelescopePromptBorder guifg=#282828
        highlight TelescopeResultsBorder guifg=#282828
        highlight TelescopePreviewBorder guifg=#282828
        highlight TelescopePromptTitle guifg=#FFFFFF
        highlight TelescopePromptNormal guibg=#282828 guifg=#FFD700
        highlight TelescopePromptPrefix guibg=#282828 guifg=#FFD700
        highlight TelescopeResultsTitle guifg=#FFFFFF
        highlight TelescopePreviewTitle guifg=#FFFFFF
        highlight TelescopeSelection guibg=#282828 guifg=#FFD700
        highlight TelescopeSelectionCaret guibg=#282828 guifg=#FFD700
        highlight TelescopeMatching guifg=#0D8Bd6
      ]])
    end,
  },
}
