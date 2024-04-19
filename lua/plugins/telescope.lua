return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
          require("telescope").load_extension("live_grep_args")
        end,
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").load_extension("ui-select")
        end,
      },
      {
        "debugloop/telescope-undo.nvim",
        config = function()
          require("telescope").load_extension("undo")
        end,
      },
      {
        "jemag/telescope-diff.nvim",
        config = function()
          require("telescope").load_extension("diff")
        end,
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
      -- add a keymap to browse plugin files
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
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
          require("telescope").extensions.live_grep_args.live_grep_args({ cwd = require("lazyvim.util").root() })
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

      -- {
      --   "<leader><leader>",
      --   function()
      --     require("telescope").extensions.frecency.frecency({
      --       prompt_title = "Recent Files",
      --       workspace = "CWD",
      --       sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
      --     })
      --   end,
      --   desc = "Find Recent Files",
      -- },
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
      require("telescope").setup({
        defaults = {
          -- border = false,
          -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          borderchars = { "▄", "▌", "▀", "▐", "▗", "▖", "▘", "▝" },
          -- borderchars =    { "▄", "",  "",  "▐",  "▗", "▖", "",  "" },
          -- borderchars = { "", "", "", "", "", "", "", "" },
          layout_strategy = "vertical",
          layout_config = {
            height = 0.95,
            width = 0.95,
            horizontal = {
              prompt_position = "top",
              preview_width = 0.6,
            },
            vertical = {
              mirror = false,
            },
          },
          path_display = function(opts, path)
            local file = require("telescope.utils").path_tail(path)
            local path_without_file = path:gsub(file .. "$", ""):gsub("^/Users/[^/]+/", "~/")
            -- if string.find(path_without_file, "^app/") or string.find(path_without_file, "^config/") then
            --   return string.format("%s (%s)", file, path_without_file:gsub("/$", ""))
            -- else
            local dir = require("telescope.utils").path_tail(path_without_file:gsub("/$", ""))
            if dir == "" or dir == file then
              return string.format("%s", file)
            end

            -- local git_dir = vim.fn.finddir(".git", ".;")
            -- if git_dir and #git_dir > 0 then
            --   local rel_path = path:sub(#git_dir):gsub(dir .. "/" .. file .. "$", "")
            --   return string.format("%s/%s (.%s)", dir, file, rel_path)
            -- end

            -- local rel_path = path:sub(#cwd):gsub(dir .. "/" .. file .. "$", "")
            local rel_path = path_without_file:gsub(dir .. "/$", "")
            if rel_path == "" then
              return string.format("%s/%s", dir, file)
            end
            return string.format("%s/%s (%s)", ShortenDirStrings(dir), file, ShortenDirStrings(rel_path:gsub("/$", "")))
            -- end
          end,
          mappings = {
            i = {
              ["<C-Down>"] = require("telescope.actions").cycle_history_next,
              ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
            },
            n = {
              ["<C-Down>"] = require("telescope.actions").cycle_history_next,
              ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },

          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      })
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
  {
    "stevearc/dressing.nvim",
    config = function()
      -- require("dressing").setup({
      --   select = {
      --     telescope = {
      --       borderchars = { "", "", "", "", "", "", "", "" },
      --     },
      --   },
      -- })
    end,
  },
}
