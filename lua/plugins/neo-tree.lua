local open_root = function()
  local current_file = vim.fn.expand("%:p")
  -- vim.notify("current_file" .. current_file)
  require("neo-tree.command").execute({
    toggle = true,
    source = "filesystem",
    -- dir = LazyVim.root(),
    reveal = current_file,
  })
end

local open_cwd = function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    -- event = "VimEnter",
    branch = "v3.x",
    keys = {
      { "<leader>fe", open_root, desc = "Explorer NeoTree (Root Dir)" },
      { "<leader>fE", open_cwd, desc = "Explorer NeoTree (cwd)" },
      { "<leader>e", open_root, desc = "Explorer NeoTree (Root Dir)" },
      { "<leader>E", open_cwd, desc = "Explorer NeoTree (cwd)" },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    -- deactivate = function()
    --   vim.cmd([[Neotree close]])
    -- end,
    opts = {
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status" },
      auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
      -- hide_root_node = true,
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      source_selector = {
        -- winbar = true,
        -- statusline = true,
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "git_status" },
          -- { source = "document_symbols" }
        },
      },
      commands = {
        open_in_finder = function(state)
          local node = state.tree:get_node()
          if node then
            if node.type == "message" then
              return
            end

            local path = node:get_id()
            if node.type == "directory" then
              vim.cmd("silent !open " .. vim.fn.shellescape(path))
            elseif node.type == "file" then
              vim.cmd("silent !open -R " .. vim.fn.shellescape(path))
            end
          end
        end,
      },
      buffers = {
        commands = {
          buffer_delete = function(state)
            local node = state.tree:get_node()
            if node then
              if node.type == "message" then
                return
              end

              local bufnr = node.extra.bufnr
              local bd = require("mini.bufremove").delete
              if vim.fn.getbufvar(bufnr, "&modified") == 1 then
                local choice =
                  vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)), "&Yes\n&No\n&Cancel")
                if choice == 1 then -- Yes
                  vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("write")
                  end)
                  bd(bufnr)
                elseif choice == 2 then -- No
                  bd(bufnr, true)
                end
              else
                bd(bufnr)
              end
              local manager = require("neo-tree.sources.manager")
              local refresh = require("neo-tree.utils").wrap(manager.refresh, "buffers")
              refresh()
            else
              vim.notify("No node found to delete", "error")
            end
          end,
          -- buffer_save = function(state)
          --   local node = state.tree:get_node()
          --   if node then
          --     if node.type == "message" then
          --       return
          --     end
          --
          --     local bufnr = node.extra.bufnr
          --     -- TODO save buffer
          --   else
          --     vim.notify("No node found to save", "error")
          --   end
          -- end
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
              vim.notify("Copied path to clipboard: " .. path, "info")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = "open_in_finder",
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            modified = "",
          },
        },
        diagnostics = {
          symbols = {
            error = " ",
            warn = " ",
            hint = " ",
            info = " ",
          },
        },
      },
    },
    config = function(_, opts)
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

      for type, icon in pairs(signs) do
        local hl = "Diagnostic" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })

      end
      vim.fn.sign_define("DiagnosticSignError", { text = signs.Error, texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = signs.Warn, texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = signs.Info, texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = signs.Hint, texthl = "DiagnosticSignHint" })
      -- vim.notify("calling neo-tree config")
      -- local function on_move(data)
      --   LazyVim.lsp.on_rename(data.source, data.destination)
      -- end

      -- local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        -- { event = events.FILE_MOVED, handler = on_move },
        -- { event = events.FILE_RENAMED, handler = on_move },
        -- {
        --   event = events.FILE_OPENED,
        --   handler = function(data)
        --     -- vim.notify("auto closing neo-tree")
        --     require("neo-tree.command").execute({ action = "close" })
        --   end
        -- }
      })
      require("neo-tree").setup(opts)

      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}
